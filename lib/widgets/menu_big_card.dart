// ============================================================================
// menu_big_card.dart — การ์ดใบใหญ่ของแถวเมนูแนะนำบนหน้าแรก
//
// ต่างจาก MenuCard ตรงที่ใบนี้วางภาพไว้ด้านบนและกว้างกว่า เพื่อให้ภาพอาหาร
// เป็นสิ่งแรกที่สะดุดตาเมื่อเปิดแอป · ใบนี้เรียงในแถวที่เลื่อนแนวนอนได้
//
// ── ส่วนที่ให้มาแล้ว (ไม่ต้องแก้ในแล็บนี้) ──────────────────────────────────
//   - ภาพ ชื่อ ราคา และปุ่มเพิ่มลงตะกร้าที่มุมขวาบนของภาพ
//
// ไฟล์นี้ไม่มีจุดที่ต้องเติม
// ============================================================================
import 'package:flutter/material.dart';

import '../models/menu_item.dart';
import '../theme.dart';
import 'food_image.dart';

class MenuBigCard extends StatelessWidget {
  const MenuBigCard({
    super.key,
    required this.item,
    required this.onAdd,
    required this.onOpen,
  });

  final MenuItem item;

  /// เรียกเมื่อกดปุ่มบวกที่มุมภาพ
  final VoidCallback onAdd;

  /// เรียกเมื่อกดที่ตัวการ์ด เพื่อเปิดจอรายละเอียดของเมนูนี้
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return SizedBox(
      width: 182,
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
              onTap: onOpen,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      FoodImage(path: item.imagePath, width: 182, height: 120),
                      Positioned(
                        right: AppSpace.sm,
                        bottom: AppSpace.sm,
                        child: _addButton(),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpace.md,
                      AppSpace.md,
                      AppSpace.md,
                      AppSpace.md,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          height: 44,
                          child: Text(
                            item.name,
                            style: textTheme.titleMedium,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(height: AppSpace.xs),
                        Text(
                          '${item.price} บาท',
                          style: textTheme.titleMedium?.copyWith(
                            color: AppColors.brand,
                          ),
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

  Widget _addButton() {
    return Material(
      color: AppColors.brand,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onAdd,
        child: const SizedBox(
          width: 36,
          height: 36,
          child: Icon(Icons.add, size: 21, color: Colors.white),
        ),
      ),
    );
  }
}
