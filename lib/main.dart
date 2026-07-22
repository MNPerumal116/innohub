import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'theme/app_theme.dart';
import 'routes/app_routes.dart';
import 'features/employee/bloc/employee_bloc.dart';
import 'features/employee/bloc/employee_detail_bloc.dart';
import 'features/login/bloc/login_bloc.dart';

void main() {
  runApp(const InnoHubApp());
}

class InnoHubApp extends StatelessWidget {
  const InnoHubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<EmployeeBloc>(
          create: (context) => EmployeeBloc(),
        ),
        BlocProvider<EmployeeDetailBloc>(
          create: (context) => EmployeeDetailBloc(),
        ),
        BlocProvider<LoginBloc>(
          create: (context) => LoginBloc(),
        ),
      ],
      child: MaterialApp(
        title: 'InnoHUB HRMS',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        navigatorKey: AppRoutes.navigatorKey,
        initialRoute: AppRoutes.splash,
        routes: AppRoutes.getRoutes(),
        onGenerateRoute: AppRoutes.onGenerateRoute,
      ),
    );
  }
}
