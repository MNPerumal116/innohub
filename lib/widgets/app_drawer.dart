import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../core/storage/token_storage.dart';
import '../features/login/bloc/login_bloc.dart';
import '../features/login/bloc/login_event.dart';
import '../routes/app_routes.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  String _name = 'Loading...';
  String _email = '';

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final storage = TokenStorage.instance;
    final username = await storage.getUsername();
    // Assuming username is the email as seen in the curl request
    setState(() {
      _name = 'HR Admin'; // Hardcoded for now based on UI mock
      _email = username ?? 'user@innohub.com';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF0F172A),
      child: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.only(top: 20, left: 20, bottom: 20),
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'InnoHub HR',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'HR/Admin Portal',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            
            // Profile snippet
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              color: const Color(0xFF0F172A),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=5'), // Female avatar matching web UI
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(_name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14)),
                        Text(_email, style: const TextStyle(color: Colors.white70, fontSize: 12), overflow: TextOverflow.ellipsis),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _buildMenuItem(Icons.people_outline, 'Employees', isSelected: true, onTap: () {
                    Navigator.pop(context); // Close drawer
                    Navigator.pushNamed(context, AppRoutes.employeeDirectory);
                  }),
                ],
              ),
            ),
            
            const Divider(color: Colors.white24, height: 1),
            _buildMenuItem(Icons.settings_outlined, 'Settings', isBoxed: false, onTap: () {}),
            _buildMenuItem(Icons.logout, 'Logout', isBoxed: false, onTap: () {
               context.read<LoginBloc>().add(const LoginLogoutRequested());
               Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (route) => false);
            }),
            const SizedBox(height: 10),
            
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, {bool isSelected = false, bool isBoxed = true, VoidCallback? onTap}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        boxShadow: isBoxed ? const [
          BoxShadow(
            color: Colors.black12, // Gray shadow
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ] : null,
      ),
      child: Material(
        color: isBoxed ? const Color(0xFF1E293B) : Colors.transparent, // Grey box background conditionally
        borderRadius: BorderRadius.circular(8),
        clipBehavior: Clip.antiAlias,
        child: ListTile(
          leading: Icon(icon, color: Colors.white70, size: 20),
          title: Text(
            title,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
              fontWeight: FontWeight.normal,
            ),
          ),
          onTap: onTap,
          dense: true,
          horizontalTitleGap: 0,
        ),
      ),
    );
  }


}
