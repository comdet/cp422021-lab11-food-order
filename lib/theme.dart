// ============================================================================
// theme.dart — สีและรูปแบบตัวอักษรของแอป
//
// ทุกจอเรียกใช้ค่าจากไฟล์นี้ ไม่ประกาศสีซ้ำในไฟล์ของตัวเอง
// แก้สีที่นี่ที่เดียวแล้วทุกจอเปลี่ยนตาม
//
// ── ส่วนที่ให้มาแล้ว (ไม่ต้องแก้) ────────────────────────────────────────────
//   - AppColors   ชุดสีที่ทุกจอใช้ร่วมกัน
//   - appTheme()  ค่า ThemeData ที่ main.dart ส่งให้ MaterialApp
//
// ไฟล์นี้ไม่มีจุดที่ต้องเติม
// ============================================================================
import 'package:flutter/material.dart';

/// ชุดสีของแอป — ประกาศเป็นค่าคงที่เพื่อให้ทุกจออ้างถึงค่าเดียวกัน
class AppColors {
  // ตัวสร้างแบบส่วนตัว — คลาสนี้มีไว้เก็บค่าคงที่ ไม่ได้มีไว้สร้างวัตถุ
  AppColors._();

  static const Color brand = Color(0xFFE2600F);
  static const Color background = Color(0xFFFFF8F2);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color text = Color(0xFF241B33);
  static const Color textMuted = Color(0xFF6B6577);
  static const Color line = Color(0xFFE9DED4);
  static const Color danger = Color(0xFFB3261E);
  static const Color success = Color(0xFF15803D);
}

/// ค่าตั้งต้นของหน้าตาแอปทั้งแอป — main.dart ส่งค่านี้ให้ MaterialApp
ThemeData appTheme() {
  return ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.brand,
      brightness: Brightness.light,
    ),
    scaffoldBackgroundColor: AppColors.background,
    // ค่า height ที่มากกว่า 1 ช่วยให้สระและวรรณยุกต์ภาษาไทยไม่ชนกับบรรทัดบน
    textTheme: const TextTheme(
      titleLarge: TextStyle(
        fontSize: 20,
        height: 1.45,
        fontWeight: FontWeight.w600,
        color: AppColors.text,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        height: 1.45,
        fontWeight: FontWeight.w600,
        color: AppColors.text,
      ),
      bodyMedium: TextStyle(fontSize: 14, height: 1.5, color: AppColors.text),
      bodySmall: TextStyle(fontSize: 13, height: 1.5, color: AppColors.textMuted),
      labelLarge: TextStyle(fontSize: 14, height: 1.4, fontWeight: FontWeight.w600),
    ),
  );
}
