import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';

class ConfirmClockInScreen extends StatefulWidget {
  const ConfirmClockInScreen({super.key});

  @override
  State<ConfirmClockInScreen> createState() => _ConfirmClockInScreenState();
}

class _ConfirmClockInScreenState extends State<ConfirmClockInScreen> {
  // ── live clock ─────────────────────────────────────────────────────────────
  late Timer _clockTimer;
  DateTime _now = DateTime.now();

  // ── map ────────────────────────────────────────────────────────────────────
  final MapController _mapController = MapController();
  LatLng _initialCamera = const LatLng(11.0168, 76.9558); // Coimbatore fallback
  LatLng? _currentLatLng;

  // ── location ───────────────────────────────────────────────────────────────
  bool _locating = true;
  bool _locationDenied = false;
  String _addressLine = 'Fetching location…';
  String? _selfieImagePath;

  // geofence centre (office) & radius in metres
  static const _officeLocation = LatLng(11.0168, 76.9558);
  static const _geofenceRadius = 200.0;
  bool _withinGeofence = false;

  @override
  void initState() {
    super.initState();
    _clockTimer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => setState(() => _now = DateTime.now()),
    );
    _initLocation();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is String) _selfieImagePath = args;
  }

  @override
  void dispose() {
    _clockTimer.cancel();
    super.dispose();
  }

  // ── location helpers ───────────────────────────────────────────────────────

  Future<void> _initLocation() async {
    setState(() => _locating = true);

    // Check if location service is enabled
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        _locating = false;
        _locationDenied = true;
        _addressLine = 'Location services are disabled.';
      });
      return;
    }

    // Check / request permission
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      setState(() {
        _locating = false;
        _locationDenied = true;
        _addressLine = 'Location permission denied.';
      });
      return;
    }

    try {
      final pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 15),
        ),
      );

      final latLng = LatLng(pos.latitude, pos.longitude);
      _updatePosition(latLng);
    } catch (e) {
      setState(() {
        _locating = false;
        _addressLine = 'Could not fetch location.';
      });
    }
  }

  Future<void> _updatePosition(LatLng latLng) async {
    _currentLatLng = latLng;

    // Geofence check
    final distanceMetres = const Distance().as(
      LengthUnit.Meter,
      latLng,
      _officeLocation,
    );
    _withinGeofence = distanceMetres <= _geofenceRadius;

    // Reverse geocode
    String address =
        '${latLng.latitude.toStringAsFixed(5)}, ${latLng.longitude.toStringAsFixed(5)}';
    try {
      final placemarks = await placemarkFromCoordinates(
        latLng.latitude,
        latLng.longitude,
      );
      if (placemarks.isNotEmpty) {
        final p = placemarks.first;
        address = [
          if ((p.street ?? '').isNotEmpty) p.street,
          if ((p.subLocality ?? '').isNotEmpty) p.subLocality,
          if ((p.locality ?? '').isNotEmpty) p.locality,
          if ((p.administrativeArea ?? '').isNotEmpty) p.administrativeArea,
          if ((p.postalCode ?? '').isNotEmpty) p.postalCode,
          if ((p.country ?? '').isNotEmpty) p.country,
        ].join(', ');
      }
    } catch (_) {} // use coordinate fallback

    setState(() {
      _addressLine = address;
      _locating = false;
    });

    // Move map to new location
    Future.delayed(const Duration(milliseconds: 300), () {
      _mapController.move(latLng, 16.0);
    });
  }

  void _centerOnMe() {
    if (_currentLatLng == null) {
      _initLocation();
      return;
    }
    _mapController.move(_currentLatLng!, 16.0);
  }

  // ── clock in ───────────────────────────────────────────────────────────────

  void _clockIn() {
    if (!_withinGeofence && _currentLatLng != null) {
      _showGeofenceWarning();
      return;
    }
    Navigator.pop(context, true);
  }

  void _showGeofenceWarning() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.location_off, color: Colors.orange),
            SizedBox(width: 8),
            Expanded(child: Text('Outside Office Zone')), // Fixed overflow here
          ],
        ),
        content: const Text(
          'You are outside the office geofence. Do you still want to clock in?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pop(context, true);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            child: const Text(
              'Clock In Anyway',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  // ── build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Confirm Clock In',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Stack(
        children: [
          // ── Flutter Map (OpenStreetMap) ─────────────────────────────────
          Positioned.fill(
            child: _locating
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(color: Color(0xFF2563EB)),
                        SizedBox(height: 16),
                        Text(
                          'Fetching your location…',
                          style: TextStyle(color: Color(0xFF64748B)),
                        ),
                      ],
                    ),
                  )
                : _locationDenied
                ? _buildLocationDenied()
                : FlutterMap(
                    mapController: _mapController,
                    options: MapOptions(
                      initialCenter: _currentLatLng ?? _initialCamera,
                      initialZoom: 16.0,
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName: 'com.example.innohub',
                      ),
                      CircleLayer(
                        circles: [
                          CircleMarker(
                            point: _officeLocation,
                            radius: _geofenceRadius,
                            useRadiusInMeter: true,
                            color: Colors.green.withOpacity(0.15),
                            borderColor: Colors.green.withOpacity(0.6),
                            borderStrokeWidth: 2,
                          ),
                        ],
                      ),
                      if (_currentLatLng != null)
                        MarkerLayer(
                          markers: [
                            Marker(
                              point: _currentLatLng!,
                              width: 40,
                              height: 40,
                              child: Icon(
                                Icons.location_on,
                                color: _withinGeofence
                                    ? Colors.green
                                    : Colors.red,
                                size: 40,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
          ),

          // ── Selfie thumbnail (top-right) ────────────────────────────────
          if (_selfieImagePath != null)
            Positioned(
              top: 16,
              right: 16,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.green, width: 3),
                  boxShadow: const [
                    BoxShadow(color: Colors.black26, blurRadius: 6),
                  ],
                ),
                child: ClipOval(
                  child: Image.file(
                    File(_selfieImagePath!),
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),

          // ── Geofence status badge ───────────────────────────────────────
          if (!_locating && !_locationDenied)
            Positioned(
              left: 16,
              top: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: _withinGeofence
                        ? Colors.green
                        : Colors.orange.shade400,
                  ),
                  borderRadius: BorderRadius.circular(6),
                  boxShadow: const [
                    BoxShadow(color: Colors.black12, blurRadius: 4),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _withinGeofence
                          ? Icons.verified_outlined
                          : Icons.location_off_outlined,
                      size: 12,
                      color: _withinGeofence ? Colors.green : Colors.orange,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _withinGeofence
                          ? 'WITHIN OFFICE ZONE'
                          : 'OUTSIDE OFFICE ZONE',
                      style: TextStyle(
                        color: _withinGeofence ? Colors.green : Colors.orange,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // ── Center-on-me FAB ────────────────────────────────────────────
          if (!_locating && !_locationDenied)
            Positioned(
              right: 16,
              bottom: 160,
              child: FloatingActionButton.small(
                heroTag: 'center_loc',
                onPressed: _centerOnMe,
                backgroundColor: Colors.white,
                child: const Icon(Icons.near_me, color: Color(0xFF2563EB)),
              ),
            ),

          // ── Refresh FAB ─────────────────────────────────────────────────
          if (!_locating && _locationDenied)
            Positioned(
              right: 16,
              bottom: 160,
              child: FloatingActionButton.small(
                heroTag: 'retry_loc',
                onPressed: _initLocation,
                backgroundColor: const Color(0xFF2563EB),
                child: const Icon(Icons.refresh, color: Colors.white),
              ),
            ),

          // ── Bottom panel ─────────────────────────────────────────────────
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 12,
                    offset: Offset(0, -3),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Address
                  const Text(
                    'LOCATION',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 14,
                        color: Color(0xFF2563EB),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          _addressLine,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF1E293B),
                            height: 1.4,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(color: Color(0xFFE2E8F0), height: 1),
                  const SizedBox(height: 16),
                  // Time + Clock In button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            DateFormat('hh : mm : ss a').format(_now),
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            DateFormat('EEEE, dd MMM yyyy').format(_now),
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                      ElevatedButton.icon(
                        onPressed: _locating ? null : _clockIn,
                        icon: const Icon(
                          Icons.login,
                          size: 18,
                          color: Colors.white,
                        ),
                        label: const Text(
                          'Clock In',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2563EB),
                          foregroundColor: Colors.white,
                          disabledBackgroundColor: const Color(0xFF94A3B8),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 28,
                            vertical: 14,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 0,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationDenied() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.location_off, size: 64, color: Color(0xFF94A3B8)),
            const SizedBox(height: 16),
            const Text(
              'Location Permission Required',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Please enable location access to verify your clock-in location.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xFF64748B)),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => Geolocator.openLocationSettings(),
              icon: const Icon(Icons.settings_outlined, color: Colors.white),
              label: const Text(
                'Open Settings',
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2563EB),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
