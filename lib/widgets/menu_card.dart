// ============================================================================
// menu_card.dart — การ์ดของเมนูหนึ่งรายการบนจอเมนู
//
// การ์ดนี้รับข้อมูลที่จะแสดงเข้ามาทางพารามิเตอร์ และไม่อ่านข้อมูลจากที่ใดเอง
// เมื่อแหล่งข้อมูลเปลี่ยนจากรายการตัวอย่างไปเป็น Cloud Firestore ไฟล์นี้จึงไม่ต้องแก้
//
// ── ส่วนที่ให้มาแล้ว (ไม่ต้องแก้ในแล็บนี้) ──────────────────────────────────
//   - การแสดงภาพ ชื่อ และราคา
//   - กรอบแทนภาพเมื่อไม่มีภาพของรายการนั้น หรือเปิดไฟล์ภาพไม่สำเร็จ
//   - ปุ่มเพิ่มลงตะกร้า ซึ่งเรียกฟังก์ชันที่จอเมนูส่งเข้ามาทาง onAdd
//
// ไฟล์นี้ไม่มีจุดที่ต้องเติม
// ============================================================================
import 'package:flutter/material.dart';

import '../models/menu_item.dart';
import '../theme.dart';
import 'food_image.dart';

class MenuCard extends StatelessWidget {
  const MenuCard({super.key, required this.item, required this.onAdd});

  final MenuItem item;

  /// ฟังก์ชันที่จอเมนูส่งเข้ามา เรียกเมื่อผู้ใช้กดปุ่มเพิ่มลงตะกร้า
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpace.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpace.radiusCard),
        boxShadow: AppSpace.cardShadow,
      ),
      // ClipRRect ทำให้ภาพชิดขอบซ้ายของการ์ดได้โดยมุมยังโค้งตามการ์ด
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSpace.radiusCard),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onAdd,
            // IntrinsicHeight กำหนดความสูงของแถวให้เท่ากับชิ้นที่สูงที่สุดในแถว
            // ถ้าไม่มีบรรทัดนี้ ภาพจะไม่รู้ว่าต้องสูงเท่าใดเพราะรายการเลื่อนได้
            // มีความสูงไม่จำกัด
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  FoodImage(path: item.imagePath, width: 108, height: 108),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(
                        AppSpace.md,
                        AppSpace.md,
                        AppSpace.sm,
                        AppSpace.md,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            item.name,
                            style: textTheme.titleMedium,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: AppSpace.sm),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: <Widget>[
                              Text(
                                '${item.price}',
                                style: textTheme.titleLarge?.copyWith(
                                  color: AppColors.brand,
                                ),
                              ),
                              const SizedBox(width: AppSpace.xs),
                              Text('บาท', style: textTheme.bodySmall),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: AppSpace.md),
                    child: Center(child: _addButton()),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// ปุ่มวงกลมเพิ่มลงตะกร้า — ขนาด 44 จุด เท่ากับขนาดที่นิ้วกดได้สบาย
  Widget _addButton() {
    return SizedBox(
      width: 44,
      height: 44,
      child: FilledButton(
        onPressed: onAdd,
        style: FilledButton.styleFrom(
          padding: EdgeInsets.zero,
          minimumSize: const Size(44, 44),
          shape: const CircleBorder(),
        ),
        child: const Icon(Icons.add, size: 24),
      ),
    );
  }
}
