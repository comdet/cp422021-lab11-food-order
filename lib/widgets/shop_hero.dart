// ============================================================================
// shop_hero.dart — หัวหน้าแรก ภาพร้านเต็มความกว้างพร้อมข้อมูลร้าน
//
// ── ส่วนที่ให้มาแล้ว (ไม่ต้องแก้ในแล็บนี้) ──────────────────────────────────
//   - ภาพร้านพร้อมแถบไล่สีทับด้านล่าง เพื่อให้ตัวอักษรสีขาวอ่านออกบนภาพทุกภาพ
//   - ชื่อร้าน คำอธิบาย ป้ายคะแนน เวลาส่ง และสถานะเปิดร้าน
//
// ไฟล์นี้ไม่มีจุดที่ต้องเติม
// ============================================================================
import 'package:flutter/material.dart';

import '../data/shop_info.dart';
import '../theme.dart';
import 'food_image.dart';

class ShopHero extends StatelessWidget {
  const ShopHero({super.key, required this.shop});

  final ShopInfo shop;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 208,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          FoodImage(path: shop.heroImage, width: double.infinity, height: 208),
          // แถบไล่สีจากใสไปเข้ม ทำให้ตัวอักษรสีขาวอ่านออกไม่ว่าภาพจะสว่างแค่ไหน
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[
                  Color(0x00000000),
                  Color(0x66000000),
                  Color(0xCC000000),
                ],
                stops: <double>[0.30, 0.62, 1],
              ),
            ),
          ),
          Positioned(
            left: AppSpace.lg,
            right: AppSpace.lg,
            bottom: AppSpace.lg,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  shop.name,
                  style: const TextStyle(
                    fontSize: 26,
                    height: 1.35,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                Text(
                  shop.tagline,
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.45,
                    color: Color(0xFFF2E9E2),
                  ),
                ),
                const SizedBox(height: AppSpace.md),
                Wrap(
                  spacing: AppSpace.sm,
                  runSpacing: AppSpace.sm,
                  children: <Widget>[
                    _chip(
                      icon: Icons.star,
                      text: '${shop.rating} (${shop.ratingCount})',
                    ),
                    _chip(
                      icon: Icons.schedule,
                      text: 'ส่ง ${shop.deliveryMinutes} นาที',
                    ),
                    _chip(
                      icon: shop.isOpen ? Icons.check_circle : Icons.cancel,
                      text: shop.isOpen ? 'เปิดอยู่' : 'ปิดแล้ว',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// ป้ายข้อมูลหนึ่งอัน พื้นขาวโปร่ง ตัวอักษรสีเข้ม อ่านออกบนภาพทุกภาพ
  Widget _chip({required IconData icon, required String text}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpace.md, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon, size: 15, color: AppColors.brand),
          const SizedBox(width: 5),
          Text(
            text,
            style: const TextStyle(
              fontSize: 12.5,
              height: 1.4,
              fontWeight: FontWeight.w600,
              color: AppColors.text,
            ),
          ),
        ],
      ),
    );
  }
}
