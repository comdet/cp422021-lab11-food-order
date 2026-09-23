// ============================================================================
// restaurant_card.dart — การ์ดร้านสองแบบที่ใช้บนหน้าแรกของแอปส่งอาหาร
//
// ── ส่วนที่ให้มาแล้ว (ไม่ต้องแก้ในแล็บนี้) ──────────────────────────────────
//   - RestaurantCard      การ์ดใบใหญ่ของรายชื่อร้านทั้งหมด ภาพอยู่ด้านบน
//   - RestaurantMiniCard  การ์ดใบเล็กของแถวร้านแนะนำที่เลื่อนแนวนอน
//   - ทั้งสองใบแสดงประเภทอาหาร คะแนนพร้อมจำนวนรีวิว เวลาส่ง และระยะทาง
//   - ร้านที่ปิดอยู่จะถูกลดความเข้มของภาพและกดไม่ได้
//
// ไฟล์นี้ไม่มีจุดที่ต้องเติม
// ============================================================================
import 'package:flutter/material.dart';

import '../models/restaurant.dart';
import '../theme.dart';
import 'food_image.dart';

class RestaurantCard extends StatelessWidget {
  const RestaurantCard({
    super.key,
    required this.restaurant,
    required this.onOpen,
  });

  final Restaurant restaurant;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpace.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpace.radiusCard),
        boxShadow: AppSpace.cardShadow,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSpace.radiusCard),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: restaurant.isOpen ? onOpen : null,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _cover(height: 150),
                Padding(
                  padding: const EdgeInsets.all(AppSpace.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        restaurant.name,
                        style: textTheme.titleLarge,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: AppSpace.xs),
                      Text(
                        '${restaurant.foodTypes.join(' · ')}  ·  '
                        '${restaurant.area}',
                        style: textTheme.bodySmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: AppSpace.sm),
                      _metaRow(context),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _cover({required double height}) {
    final Widget image = FoodImage(
      path: restaurant.imagePath,
      width: double.infinity,
      height: height,
    );
    if (restaurant.isOpen) {
      return Stack(
        children: <Widget>[
          image,
          if (restaurant.freeDelivery)
            const Positioned(
              left: AppSpace.md,
              top: AppSpace.md,
              child: _FreeTag(),
            ),
        ],
      );
    }
    return Stack(
      fit: StackFit.passthrough,
      children: <Widget>[
        ColorFiltered(
          colorFilter: const ColorFilter.mode(
            Color(0x99FFFFFF),
            BlendMode.srcATop,
          ),
          child: image,
        ),
        Positioned.fill(
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpace.md,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: AppColors.text.withValues(alpha: 0.82),
                borderRadius: BorderRadius.circular(999),
              ),
              child: const Text(
                'ปิดรับออเดอร์',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  height: 1.4,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _metaRow(BuildContext context) {
    return Wrap(
      spacing: AppSpace.md,
      runSpacing: AppSpace.xs,
      children: <Widget>[
        _meta(Icons.star, '${restaurant.rating} (${restaurant.ratingCount})'),
        _meta(Icons.schedule, '${restaurant.deliveryMinutes} นาที'),
        _meta(Icons.place_outlined, '${restaurant.distanceKm} กม.'),
      ],
    );
  }

  static Widget _meta(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Icon(icon, size: 15, color: AppColors.brand),
        const SizedBox(width: 4),
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
    );
  }
}

/// ป้ายส่งฟรีที่มุมภาพ
class _FreeTag extends StatelessWidget {
  const _FreeTag();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpace.sm, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.success,
        borderRadius: BorderRadius.circular(999),
      ),
      child: const Text(
        'ส่งฟรี',
        style: TextStyle(
          color: Colors.white,
          fontSize: 11.5,
          height: 1.4,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

/// การ์ดใบเล็กของแถวร้านแนะนำที่เลื่อนแนวนอน
class RestaurantMiniCard extends StatelessWidget {
  const RestaurantMiniCard({
    super.key,
    required this.restaurant,
    required this.onOpen,
  });

  final Restaurant restaurant;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return SizedBox(
      width: 196,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpace.radiusCard),
          boxShadow: AppSpace.cardShadow,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppSpace.radiusCard),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: restaurant.isOpen ? onOpen : null,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  FoodImage(
                    path: restaurant.imagePath,
                    width: 196,
                    height: 104,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(AppSpace.md),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          height: 24,
                          child: Text(
                            restaurant.name,
                            style: textTheme.titleMedium,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(height: AppSpace.xs),
                        Row(
                          children: <Widget>[
                            RestaurantCard._meta(
                              Icons.star,
                              '${restaurant.rating}',
                            ),
                            const SizedBox(width: AppSpace.md),
                            RestaurantCard._meta(
                              Icons.schedule,
                              '${restaurant.deliveryMinutes} นาที',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
