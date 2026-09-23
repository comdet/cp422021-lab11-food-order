// ============================================================================
// home_screen.dart — หน้าแรกของแอปส่งอาหาร   ★ มีจุดที่ต้องเติม (งานข้อ ②)
//
// หน้าแรกของแอปส่งอาหารไม่ใช่เมนูอาหาร แต่เป็น **รายชื่อร้านที่ส่งถึงที่อยู่นี้**
// ผู้ใช้เลือกร้านก่อน แล้วจึงเห็นเมนูของร้านนั้นในจอถัดไป
//
// ตอนนี้จอนี้ยังว่าง มีแต่แถบที่อยู่ปลายทางที่ให้ไว้เป็นตัวอย่าง
// **งานข้อ ② คือประกอบหน้าแรกให้เหมือนภาพเทียบ** reference-shots/home-full.png
//
// ── ส่วนที่ให้มาแล้ว (ไม่ต้องเขียนเอง) ─────────────────────────────────────
//   - AddressBar          แถบที่อยู่ปลายทาง — ประกอบไว้ให้ดูเป็นตัวอย่างข้างล่าง
//   - SectionTitle        หัวข้อของแต่ละช่วง เช่น "ร้านแนะนำ"
//   - RestaurantMiniCard  การ์ดร้านใบเล็ก สำหรับแถวที่เลื่อนแนวนอน
//   - RestaurantCard      การ์ดร้านใบใหญ่ สำหรับรายชื่อร้านทั้งหมด
//   - _openRestaurant()   เปิดจอเมนูของร้านที่กด — เรียกใช้ได้เลย
//
// ── ข้อมูลที่ให้มาแล้ว ──────────────────────────────────────────────────────
//   - demoRestaurants      รายชื่อร้าน 8 ร้าน (lib/data/demo_restaurants.dart)
//   - recentRestaurantIds  รหัสร้านที่เคยสั่ง เรียงจากล่าสุด (ไฟล์เดียวกัน)
//   - DeliveryInfo.demo    ที่อยู่ปลายทางและค่าส่ง (lib/data/delivery_info.dart)
//
// ── สิ่งที่ภาพเทียบมี เรียงจากบนลงล่าง ──────────────────────────────────────
//   1. แถบที่อยู่ปลายทาง                                   (ให้มาแล้ว)
//   2. ช่องค้นหาร้านหรือประเภทอาหาร ที่กรองรายการได้จริง      ← ต้องเติม
//   3. หัวข้อ "ร้านแนะนำ" + แถวการ์ดใบเล็กที่เลื่อนแนวนอน      ← ต้องเติม
//   4. หัวข้อ "ร้านที่เคยสั่ง" + แถวการ์ดใบเล็กที่เลื่อนแนวนอน   ← ต้องเติม
//   5. หัวข้อ "ร้านทั้งหมดที่ส่งถึงคุณ" + การ์ดใบใหญ่ทุกร้าน    ← ต้องเติม
//
// ★ ไม่ต้องเขียนชิ้นส่วนใหม่เอง งานข้อนี้คือการ **ประกอบชิ้นส่วนที่มีอยู่แล้ว**
//   ถ้าเขียน widget การ์ดร้านขึ้นมาใหม่ทั้งที่มีของให้อยู่แล้ว ถือว่ายังไม่ผ่านข้อนี้
// ============================================================================
import 'package:flutter/material.dart';

import '../data/delivery_info.dart';
import '../models/restaurant.dart';
import '../theme.dart';
import '../widgets/address_bar.dart';
import 'restaurant_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  /// คำที่พิมพ์ในช่องค้นหา — ใช้กรองรายชื่อร้านที่แสดง
  // ignore: prefer_final_fields
  String _query = '';

  /// เปิดจอเมนูของร้านที่กด — ให้มาแล้ว เรียกใช้ได้เลย
  // ignore: unused_element
  void _openRestaurant(Restaurant restaurant) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) =>
            RestaurantScreen(restaurant: restaurant),
      ),
    );
  }

  void _changeAddress() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('การเลือกที่อยู่จากตำแหน่งจริงเป็นเนื้อของสัปดาห์ถัดไป'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          // ชิ้นนี้ให้ไว้เป็นตัวอย่างว่าเรียกใช้ชิ้นส่วนที่แจกมาอย่างไร
          AddressBar(info: DeliveryInfo.demo, onChange: _changeAddress),

          // ── ★ จุดที่ต้องเติม (งานข้อ ②) — ประกอบหน้าแรกให้เหมือนภาพเทียบ ────
          // ต้องทำ: แทนที่ _todoPanel() ข้างล่างด้วยเนื้อหาจริงของหน้าแรก
          //   ให้ครบห้าช่วงตามที่เขียนไว้ในหัวไฟล์ และหน้าตาตรงกับ
          //   reference-shots/home-full.png
          //
          //   ชิ้นส่วนที่ต้องใช้: SectionTitle · RestaurantMiniCard · RestaurantCard
          //   ข้อมูล: demoRestaurants · recentRestaurantIds
          //   กดการ์ดร้านแล้วต้องเรียก _openRestaurant(ร้านใบนั้น)
          //
          //   ข้อกำหนดของช่องค้นหา: พิมพ์แล้วรายชื่อร้านต้องกรองตามจริง
          //   ค้นได้ทั้งชื่อร้าน ประเภทอาหาร และอำเภอ · ตอนค้นหาให้ซ่อนสองแถวบน
          //
          //   คำใบ้เรื่องการวาง: รายชื่อร้านยาวกว่าหน้าจอ จึงต้องอยู่ในสิ่งที่เลื่อนได้
          //   และแถวที่เลื่อนแนวนอนต้องถูกกำหนดความสูงไว้
          //
          //   อย่าลืมเติม import ของชิ้นส่วนกับข้อมูลที่ต้องใช้ด้วย
          Expanded(child: _todoPanel()),
        ],
      ),
    );
  }

  /// แผงชั่วคราวที่บอกว่าจอนี้ยังไม่ได้ทำ — ลบทิ้งเมื่อทำงานข้อ ② เสร็จ
  Widget _todoPanel() {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpace.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              width: 96,
              height: 96,
              decoration: const BoxDecoration(
                color: AppColors.brandSoft,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.dashboard_customize_outlined,
                size: 44,
                color: AppColors.brand,
              ),
            ),
            const SizedBox(height: AppSpace.lg),
            Text('หน้าแรกยังว่างอยู่', style: textTheme.titleLarge),
            const SizedBox(height: AppSpace.sm),
            Text(
              'งานข้อ ② ของแล็บคือประกอบหน้าแรกให้เหมือนภาพเทียบ '
              'โดยใช้ชิ้นส่วนที่แจกมาให้แล้ว '
              'อ่านรายละเอียดที่หัวไฟล์ lib/screens/home_screen.dart',
              textAlign: TextAlign.center,
              style: textTheme.bodySmall,
            ),
            if (_query.isNotEmpty) ...<Widget>[
              const SizedBox(height: AppSpace.lg),
              Text('คำค้นที่พิมพ์ไว้: "$_query"', style: textTheme.bodySmall),
            ],
          ],
        ),
      ),
    );
  }
}
