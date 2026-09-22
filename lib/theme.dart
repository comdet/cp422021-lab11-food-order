// ============================================================================
// theme.dart — สี ระยะ และรูปแบบตัวอักษรของแอปทั้งแอป
//
// ทุกจอเรียกใช้ค่าจากไฟล์นี้ ไม่ประกาศสีหรือระยะซ้ำในไฟล์ของตัวเอง
// แก้ที่นี่ที่เดียวแล้วทุกจอเปลี่ยนตาม
//
// ── ส่วนที่ให้มาแล้ว (ไม่ต้องแก้) ────────────────────────────────────────────
//   - AppColors   ชุดสีที่ทุกจอใช้ร่วมกัน
//   - AppSpace    ระยะห่างและรัศมีมุมที่ทุกจอใช้ร่วมกัน
//   - appTheme()  ค่า ThemeData ที่ main.dart ส่งให้ MaterialApp
//
// ★ ข้อควรรู้เรื่องสีปุ่ม
//   ปุ่มของ Material ไม่ได้หยิบสีจาก AppColors เอง แต่หยิบจาก colorScheme.primary
//   ถ้าสร้าง colorScheme ด้วย ColorScheme.fromSeed เพียงอย่างเดียว Material จะ
//   "ปั่น" ชุดสีขึ้นใหม่จากสีที่ให้ไป ผลคือสีปุ่มจะไม่ใช่สีแบรนด์ที่ประกาศไว้
//   ไฟล์นี้จึงกำหนด primary ทับลงไปให้เท่ากับ AppColors.brand เสมอ
//   เพื่อให้แถบหัวจอกับปุ่มเป็นสีเดียวกันจริง
//
// ไฟล์นี้ไม่มีจุดที่ต้องเติม
// ============================================================================
import 'package:flutter/material.dart';

/// ชุดสีของแอป — ประกาศเป็นค่าคงที่เพื่อให้ทุกจออ้างถึงค่าเดียวกัน
class AppColors {
  // ตัวสร้างแบบส่วนตัว — คลาสนี้มีไว้เก็บค่าคงที่ ไม่ได้มีไว้สร้างวัตถุ
  AppColors._();

  /// สีหลักของแบรนด์ ใช้กับแถบหัวจอ ปุ่มหลัก และตัวเลขราคา
  static const Color brand = Color(0xFFE2600F);

  /// สีแบรนด์เวอร์ชันเข้ม ใช้ตอนกดค้างและใช้กับตัวอักษรบนพื้นอ่อน
  static const Color brandDark = Color(0xFFB94B08);

  /// สีแบรนด์เวอร์ชันจาง ใช้เป็นพื้นของป้ายและปุ่มรอง
  static const Color brandSoft = Color(0xFFFDEDE1);

  static const Color background = Color(0xFFFFF8F2);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color text = Color(0xFF241B33);
  static const Color textMuted = Color(0xFF6B6577);
  static const Color line = Color(0xFFE9DED4);
  static const Color danger = Color(0xFFB3261E);
  static const Color success = Color(0xFF15803D);
}

/// ระยะห่างและรัศมีมุมที่ใช้ซ้ำทั้งแอป — ไม่ใส่ตัวเลขดิบกระจายตามไฟล์
class AppSpace {
  AppSpace._();

  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;

  /// รัศมีมุมของการ์ด
  static const double radiusCard = 16;

  /// รัศมีมุมของปุ่มและช่องกรอก
  static const double radiusControl = 12;

  /// เงาอ่อนใต้การ์ด ใช้แทนเส้นขอบหนา ๆ
  static const List<BoxShadow> cardShadow = <BoxShadow>[
    BoxShadow(color: Color(0x14241B33), blurRadius: 14, offset: Offset(0, 4)),
  ];
}

/// ค่าตั้งต้นของหน้าตาแอปทั้งแอป — main.dart ส่งค่านี้ให้ MaterialApp
ThemeData appTheme() {
  // เริ่มจากชุดสีที่ Material สร้างให้ แล้วทับค่าที่เป็นสีแบรนด์ด้วยค่าจริง
  // เพื่อไม่ให้ปุ่มเพี้ยนไปจากสีที่ประกาศไว้ใน AppColors
  final ColorScheme scheme =
      ColorScheme.fromSeed(
        seedColor: AppColors.brand,
        brightness: Brightness.light,
      ).copyWith(
        primary: AppColors.brand,
        onPrimary: Colors.white,
        primaryContainer: AppColors.brandSoft,
        onPrimaryContainer: AppColors.brandDark,
        surface: AppColors.surface,
        onSurface: AppColors.text,
        error: AppColors.danger,
        outline: AppColors.line,
      );

  final TextTheme textTheme = const TextTheme(
    // ค่า height ที่มากกว่า 1 ช่วยให้สระและวรรณยุกต์ภาษาไทยไม่ชนกับบรรทัดบน
    headlineSmall: TextStyle(
      fontSize: 24,
      height: 1.4,
      fontWeight: FontWeight.w700,
      color: AppColors.text,
    ),
    titleLarge: TextStyle(
      fontSize: 20,
      height: 1.45,
      fontWeight: FontWeight.w700,
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
    labelLarge: TextStyle(
      fontSize: 14,
      height: 1.4,
      fontWeight: FontWeight.w600,
    ),
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: AppColors.background,
    textTheme: textTheme,

    // แถบหัวจอ — ตั้งที่นี่ที่เดียว ทุกจอจึงไม่ต้องใส่สีเอง
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.brand,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        fontSize: 20,
        height: 1.45,
        fontWeight: FontWeight.w700,
        color: Colors.white,
      ),
    ),

    // ปุ่มหลัก — สีมาจาก colorScheme.primary ซึ่งถูกทับเป็นสีแบรนด์แล้วข้างบน
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size(0, 46),
        padding: const EdgeInsets.symmetric(horizontal: AppSpace.xl),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpace.radiusControl),
        ),
        textStyle: textTheme.labelLarge,
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(0, 46),
        foregroundColor: AppColors.brandDark,
        side: const BorderSide(color: AppColors.brand),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpace.radiusControl),
        ),
        textStyle: textTheme.labelLarge,
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.brandDark,
        textStyle: textTheme.labelLarge,
      ),
    ),

    // ช่องกรอกข้อความ — ขอบและพื้นเดียวกันทุกจอ
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surface,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpace.lg,
        vertical: AppSpace.lg,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpace.radiusControl),
        borderSide: const BorderSide(color: AppColors.line),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpace.radiusControl),
        borderSide: const BorderSide(color: AppColors.line),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpace.radiusControl),
        borderSide: const BorderSide(color: AppColors.brand, width: 1.6),
      ),
      labelStyle: const TextStyle(color: AppColors.textMuted),
    ),

    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: AppColors.text,
      contentTextStyle: const TextStyle(color: Colors.white, height: 1.5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpace.radiusControl),
      ),
    ),

    dividerTheme: const DividerThemeData(color: AppColors.line, space: 1),
  );
}
