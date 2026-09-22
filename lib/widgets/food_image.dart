// ============================================================================
// food_image.dart — ภาพอาหารหนึ่งรูป พร้อมกรอบแทนภาพเมื่อไม่มีภาพ
//
// แยกออกมาเป็นไฟล์ของตัวเองเพราะมีสองจอที่ต้องแสดงภาพอาหารเหมือนกัน
// คือจอเมนูกับจอตะกร้า · ถ้าเขียนซ้ำสองที่ เวลาต้องแก้จะลืมแก้ที่หนึ่งเสมอ
//
// ── ส่วนที่ให้มาแล้ว (ไม่ต้องแก้ในแล็บนี้) ──────────────────────────────────
//   - การเปิดภาพจากโฟลเดอร์ assets
//   - กรอบแทนภาพเมื่อ path ว่าง หรือเปิดไฟล์ภาพไม่สำเร็จ
//
// ไฟล์นี้ไม่มีจุดที่ต้องเติม
//
// ★ เมื่อทำงานข้อ ① เสร็จ ค่า imagePath จะมาจากฐานข้อมูลแทนที่จะมาจากโค้ด
//   ถ้าค่าที่กรอกในฐานข้อมูลไม่ตรงกับไฟล์ที่มีอยู่จริง จอจะแสดงกรอบแทนภาพ
//   ไม่ใช่จอขาว — ออกแบบไว้แบบนี้เพื่อให้เห็นว่าข้อมูลมาถึงแล้วแต่ภาพไม่ตรง
// ============================================================================
import 'package:flutter/material.dart';

import '../theme.dart';

class FoodImage extends StatelessWidget {
  const FoodImage({
    super.key,
    required this.path,
    required this.width,
    required this.height,
    this.radius,
  });

  /// เส้นทางของภาพในโฟลเดอร์ assets เช่น assets/images/pad-thai.jpg
  final String path;

  final double width;
  final double height;

  /// รัศมีมุมของภาพ ถ้าไม่ส่งมาจะเป็นภาพมุมตรง (ให้การ์ดข้างนอกตัดมุมเอง)
  final double? radius;

  @override
  Widget build(BuildContext context) {
    final Widget picture = path.isEmpty
        ? _placeholder()
        : Image.asset(
            path,
            width: width,
            height: height,
            fit: BoxFit.cover,
            errorBuilder:
                (BuildContext context, Object error, StackTrace? stack) {
                  return _placeholder();
                },
          );

    if (radius == null) {
      return picture;
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius!),
      child: picture,
    );
  }

  Widget _placeholder() {
    return Container(
      width: width,
      height: height,
      color: AppColors.brandSoft,
      alignment: Alignment.center,
      child: Icon(
        Icons.restaurant,
        size: width * 0.34,
        color: AppColors.brand.withValues(alpha: 0.55),
      ),
    );
  }
}
