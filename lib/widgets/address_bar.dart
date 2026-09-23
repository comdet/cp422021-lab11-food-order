// ============================================================================
// address_bar.dart — แถบที่อยู่ปลายทางบนหัวหน้าแรก
//
// แอปส่งอาหารต้องบอกตลอดเวลาว่ากำลังจะส่งไปที่ไหน เพราะเวลาส่งและร้านที่เลือกได้
// ขึ้นกับที่อยู่ปลายทาง
//
// ── ส่วนที่ให้มาแล้ว (ไม่ต้องแก้ในแล็บนี้) ──────────────────────────────────
//   - ชื่อเรียกที่อยู่ ที่อยู่เต็ม และปุ่มเปลี่ยน
//
// ไฟล์นี้ไม่มีจุดที่ต้องเติม
//
// ★ ปุ่มเปลี่ยนที่อยู่ยังไม่ผูกกับการอ่านตำแหน่งจริงจากอุปกรณ์
//   เพราะการขออนุญาตใช้ตำแหน่งเป็นเนื้อของสัปดาห์ถัดไป
// ============================================================================
import 'package:flutter/material.dart';

import '../data/delivery_info.dart';
import '../theme.dart';

class AddressBar extends StatelessWidget {
  const AddressBar({super.key, required this.info, this.onChange});

  final DeliveryInfo info;
  final VoidCallback? onChange;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.brand,
      padding: const EdgeInsets.fromLTRB(
        AppSpace.lg,
        AppSpace.md,
        AppSpace.sm,
        AppSpace.lg,
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: <Widget>[
            const Icon(Icons.delivery_dining, color: Colors.white, size: 26),
            const SizedBox(width: AppSpace.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'ส่งไปที่ · ${info.label}',
                    style: const TextStyle(
                      fontSize: 12.5,
                      height: 1.4,
                      color: Color(0xFFFFE2CE),
                    ),
                  ),
                  Text(
                    info.address,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14.5,
                      height: 1.45,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: onChange,
              style: TextButton.styleFrom(foregroundColor: Colors.white),
              child: const Text('เปลี่ยน'),
            ),
          ],
        ),
      ),
    );
  }
}
