// ============================================================================
// main.dart — จุดเริ่มทำงานของแอป
//
// ลำดับการทำงาน: ฟังก์ชัน main() เรียก runApp() · runApp() วาด MaterialApp
// ซึ่งกำหนดชื่อแอป ธีมจาก theme.dart และจอแรกคือ AppShell ที่มีแถบล่างสามปุ่ม
//
// ── ส่วนที่ให้มาแล้ว (ไม่ต้องแก้) ────────────────────────────────────────────
//   - การประกอบแอปและการกำหนดหน้าแรก
//
// ไฟล์นี้ไม่มีจุดที่ต้องเติม แต่ **งานข้อ ① ทำให้ต้องกลับมาแก้ไฟล์นี้ด้วย**
// เพราะการตั้งค่าเริ่มต้นของ Firebase ต้องเกิดขึ้นที่จุดเริ่มทำงานของแอป
// ก่อนที่หน้าจอแรกจะเรียกใช้ฐานข้อมูล
// ============================================================================
import 'package:flutter/material.dart';

import 'screens/app_shell.dart';
import 'theme.dart';

void main() {
  runApp(const FoodOrderApp());
}

class FoodOrderApp extends StatelessWidget {
  const FoodOrderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'สั่งอาหาร',
      debugShowCheckedModeBanner: false,
      theme: appTheme(),
      home: const AppShell(),
    );
  }
}
