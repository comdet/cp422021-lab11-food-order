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

class MenuCard extends StatelessWidget {
  const MenuCard({super.key, required this.item, required this.onAdd});

  final MenuItem item;

  /// ฟังก์ชันที่จอเมนูส่งเข้ามา เรียกเมื่อผู้ใช้กดปุ่มเพิ่มลงตะกร้า
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Card(
      elevation: 0,
      color: AppColors.surface,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(color: AppColors.line),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            _image(),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(item.name, style: textTheme.titleMedium),
                  const SizedBox(height: 4),
                  Text('${item.price} บาท', style: textTheme.bodySmall),
                ],
              ),
            ),
            const SizedBox(width: 8),
            FilledButton(
              onPressed: onAdd,
              child: const Text('เพิ่ม'),
            ),
          ],
        ),
      ),
    );
  }

  /// ภาพของเมนู ถ้าเปิดไฟล์ภาพไม่สำเร็จจะแสดงกรอบแทนภาพ
  Widget _image() {
    if (item.imagePath.isEmpty) {
      return _imagePlaceholder();
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Image.asset(
        item.imagePath,
        width: 84,
        height: 84,
        fit: BoxFit.cover,
        errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
          return _imagePlaceholder();
        },
      ),
    );
  }

  Widget _imagePlaceholder() {
    return Container(
      width: 84,
      height: 84,
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.line),
      ),
      child: const Icon(Icons.restaurant, color: AppColors.textMuted),
    );
  }
}
