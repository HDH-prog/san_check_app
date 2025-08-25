// screens/main_screen.dart

import 'package:flutter/material.dart';
import '../core/design_system/design_system.dart';
import 'map/map_screen.dart';
import 'mountain/mountain_info_screen.dart';
import 'community/community_screen.dart';
import 'safety/safety_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const MapScreen(),
    const MountainInfoScreen(),
    const CommunityScreen(),
    const SafetyScreen(),
  ];

  final List<_NavItem> _navItems = [
    _NavItem(icon: Icons.map, label: '지도'),
    _NavItem(icon: Icons.landscape, label: '산정보'),
    _NavItem(icon: Icons.people, label: '커뮤니티'),
    _NavItem(icon: Icons.shield, label: '안전'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _screens),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: AppSpacing.elevation8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) => setState(() => _selectedIndex = index),
          type: BottomNavigationBarType.fixed,
          backgroundColor: AppColors.white,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.textTertiary,
          selectedLabelStyle: AppTypography.labelSmall,
          unselectedLabelStyle: AppTypography.labelSmall,
          items: _navItems
              .map(
                (item) => BottomNavigationBarItem(
                  icon: Icon(item.icon),
                  label: item.label,
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;

  _NavItem({required this.icon, required this.label});
}
