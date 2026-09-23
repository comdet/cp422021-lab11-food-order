// ============================================================================
// restaurant_hero.dart — หัวจอของร้านที่เลือก ภาพเต็มความกว้างพร้อมข้อมูลร้าน
//
// ── ส่วนที่ให้มาแล้ว (ไม่ต้องแก้ในแล็บนี้) ──────────────────────────────────
//   - ภาพร้านพร้อมแถบไล่สีทับ เพื่อให้ตัวอักษรสีขาวอ่านออกบนภาพทุกภาพ
//   - ปุ่มถอยกลับ ชื่อร้าน ประเภทอาหาร และป้ายคะแนน เวลาส่ง ระยะทาง
//
// ไฟล์นี้ไม่มีจุดที่ต้องเติม
// ============================================================================
import 'package:flutter/material.dart';

import '../models/restaurant.dart';
import '../theme.dart';
import 'food_image.dart';

class RestaurantHero extends StatelessWidget {
  const RestaurantHero({super.key, required this.restaurant});

  final Restaurant restaurant;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 216,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          FoodImage(
            path: restaurant.imagePath,
            width: double.infinity,
            height: 216,
          ),
          // แถบไล่สีทั้งบนและล่าง บนไว้ให้ปุ่มถอยกลับอ่านออก ล่างไว้ให้ข้อความอ่านออก
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[
                  Color(0x73000000),
                  Color(0x00000000),
                  Color(0x66000000),
                  Color(0xD9000000),
                ],
                stops: <double>[0, 0.30, 0.64, 1],
              ),
            ),
          ),
          Positioned(
            left: AppSpace.sm,
            top: AppSpace.sm,
            child: SafeArea(
              bottom: false,
              child: IconButton(
                onPressed: () => Navigator.of(context).maybePop(),
                tooltip: 'ย้อนกลับ',
                icon: const Icon(Icons.arrow_back, color: Colors.white),
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
                  restaurant.name,
                  style: const TextStyle(
                    fontSize: 25,
                    height: 1.35,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                Text(
                  '${restaurant.foodTypes.join(' · ')}  ·  ${restaurant.area}',
                  style: const TextStyle(
                    fontSize: 13.5,
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
                      text: '${restaurant.rating} (${restaurant.ratingCount})',
                    ),
                    _chip(
                      icon: Icons.schedule,
                      text: 'ส่ง ${restaurant.deliveryMinutes} นาที',
                    ),
                    _chip(
                      icon: Icons.place_outlined,
                      text: '${restaurant.distanceKm} กม.',
                    ),
                    if (restaurant.freeDelivery)
                      _chip(
                        icon: Icons.local_shipping_outlined,
                        text: 'ส่งฟรี',
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
