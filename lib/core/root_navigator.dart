import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:health_app/features/ai_report/view/ai_report_screen.dart';
import 'package:health_app/features/auth/view/auth_screen.dart';
import 'package:health_app/features/auth/viewmodel/auth_view_model.dart';
import 'package:health_app/features/health_data/view/health_data_screen.dart';
import 'package:health_app/features/info_centre/view/info_centre_screen.dart';
import 'package:health_app/features/profile/view/profile_screen.dart';
import 'package:health_app/features/sharing/view/family_screen.dart';
import 'package:provider/provider.dart';

class RootNavigator extends StatefulWidget {
  const RootNavigator({super.key});

  @override
  State<RootNavigator> createState() => _RootNavigatorState();
}

class _RootNavigatorState extends State<RootNavigator> {
  int _selectedIndex = 0;

  static final List<Widget> _screens = [
    HealthDataScreen(),
    FamilyScreen(),
    InfoCentreScreen(),
    ProfileScreen(),
    AiReportScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    log('RootNavigator is building, selectedIndex: $_selectedIndex');
    final authVM = Provider.of<AuthViewModel>(context);

    // if (authVM.isLoading && authVM.user == null) {
    //   return const Scaffold(body: Center(child: CircularProgressIndicator()));
    // }

    // if (authVM.user == null) {
    //   return const AuthScreen();
    // }
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _screens),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.cyanAccent,
        unselectedItemColor: Colors.white70,
        currentIndex: _selectedIndex,
        onTap: (value) => setState(() {
          _selectedIndex = value;
        }),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard, semanticLabel: 'Dashboard'),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group, semanticLabel: 'Family'),
            label: 'Family',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group, semanticLabel: 'AI Report'),
            label: 'AI Report',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info_outline, semanticLabel: 'Info Centre'),
            label: 'Shorts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, semanticLabel: 'Profile'),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
