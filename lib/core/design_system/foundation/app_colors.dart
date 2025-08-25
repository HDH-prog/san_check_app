import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors (등산 테마)
  static const Color primary = Color(0xFF2E7D32); // 산림 그린
  static const Color primaryLight = Color(0xFF4CAF50);
  static const Color primaryDark = Color(0xFF1B5E20);

  // Secondary Colors
  static const Color secondary = Color(0xFF1565C0); // 하늘 블루
  static const Color secondaryLight = Color(0xFF2196F3);
  static const Color secondaryDark = Color(0xFF0D47A1);

  // Accent Colors
  static const Color accent = Color(0xFFFF6B35); // 등산 오렌지
  static const Color accentLight = Color(0xFFFF9800);

  // Neutral Colors (원티드 스타일)
  static const Color white = Color(0xFFFFFFFF);
  static const Color background = Color(0xFFF8F9FA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF1F3F4);

  // Text Colors
  static const Color textPrimary = Color(0xFF212529);
  static const Color textSecondary = Color(0xFF6C757D);
  static const Color textTertiary = Color(0xFFADB5BD);
  static const Color textDisabled = Color(0xFFCED4DA);

  // Border Colors
  static const Color border = Color(0xFFDEE2E6);
  static const Color borderLight = Color(0xFFE9ECEF);

  // Semantic Colors
  static const Color success = Color(0xFF28A745); // 완등/성공
  static const Color warning = Color(0xFFEAA935); // 주의/경고
  static const Color error = Color(0xFFDC3545); // 응급/위험
  static const Color info = Color(0xFF17A2B8); // 정보

  // Functional Colors
  static const Color shadow = Color(0x1A000000);
  static const Color overlay = Color(0x80000000);

  // 깃발 색상
  static const Color flagCompleted = success;
  static const Color flagNotCompleted = Color(0xFFBDBDBD);

  AppColors._();
}
