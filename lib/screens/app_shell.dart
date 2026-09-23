// ============================================================================
// app_shell.dart — โครงของแอป แถบล่างสามปุ่มและจอที่อยู่ใต้แต่ละปุ่ม
//
// main.dart เปิดจอนี้เป็นจอแรก · จอนี้ไม่มีเนื้อหาของตัวเอง หน้าที่เดียวคือ
// สลับว่าจะแสดงจอใดใต้แถบล่าง และพาไปมาระหว่างสามจอ
//
// ใช้ IndexedStack แทนการสร้างจอใหม่ทุกครั้งที่กดสลับ เพื่อให้จอที่สลับออกไป
// ยังจำสถานะของตัวเองไว้ เช่น ตำแหน่งที่เลื่อนค้างไว้ และคำที่พิมพ์ในช่องค้นหา
//
// ── ส่วนที่ให้มาแล้ว (ไม่ต้องแก้ในแล็บนี้) ──────────────────────────────────
//   - แถบล่างสี่ปุ่ม หน้าแรก · ออเดอร์ของฉัน · ตะกร้า · บัญชี
//   - ป้ายจำนวนชิ้นบนปุ่มตะกร้า ซึ่งเปลี่ยนตามตะกร้าเอง
//   - shellTab ตัวแปรที่จออื่นใช้สั่งให้สลับปุ่มได้
//
// ไฟล์นี้ไม่มีจุดที่ต้องเติม
// ============================================================================
import 'package:flutter/material.dart';

import '../cart_view_model.dart';
import '../theme.dart';
import 'cart_screen.dart';
import 'home_screen.dart';
import 'login_screen.dart';
import 'my_orders_screen.dart';

/// ปุ่มที่กำลังเลือกอยู่บนแถบล่าง — 0 หน้าแรก · 1 ออเดอร์ของฉัน · 2 ตะกร้า · 3 บัญชี
///
/// ประกาศไว้นอกคลาสเพื่อให้จออื่นสั่งสลับได้ เช่น จอตะกร้าตอนที่ว่าง
/// มีปุ่มพากลับไปหน้าแรก
final ValueNotifier<int> shellTab = ValueNotifier<int>(0);

class AppShell extends StatelessWidget {
  const AppShell({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: shellTab,
      builder: (BuildContext context, int index, Widget? child) {
        return Scaffold(
          body: IndexedStack(
            index: index,
            children: const <Widget>[
              HomeScreen(),
              MyOrdersScreen(),
              CartScreen(),
              LoginScreen(),
            ],
          ),
          bottomNavigationBar: _bottomBar(index),
        );
      },
    );
  }

  Widget _bottomBar(int index) {
    return ListenableBuilder(
      listenable: cart,
      builder: (BuildContext context, Widget? child) {
        final int count = cart.totalQuantity;
        return NavigationBar(
          selectedIndex: index,
          onDestinationSelected: (int value) => shellTab.value = value,
          backgroundColor: AppColors.surface,
          indicatorColor: AppColors.brandSoft,
          destinations: <Widget>[
            const NavigationDestination(
              icon: Icon(Icons.storefront_outlined),
              selectedIcon: Icon(Icons.storefront, color: AppColors.brand),
              label: 'ร้านอาหาร',
            ),
            const NavigationDestination(
              icon: Icon(Icons.receipt_long_outlined),
              selectedIcon: Icon(Icons.receipt_long, color: AppColors.brand),
              label: 'ออเดอร์',
            ),
            NavigationDestination(
              icon: Badge(
                isLabelVisible: count > 0,
                backgroundColor: AppColors.brand,
                label: Text('$count'),
                child: const Icon(Icons.shopping_cart_outlined),
              ),
              selectedIcon: Badge(
                isLabelVisible: count > 0,
                backgroundColor: AppColors.brand,
                label: Text('$count'),
                child: const Icon(Icons.shopping_cart, color: AppColors.brand),
              ),
              label: 'ตะกร้า',
            ),
            const NavigationDestination(
              icon: Icon(Icons.person_outline),
              selectedIcon: Icon(Icons.person, color: AppColors.brand),
              label: 'บัญชี',
            ),
          ],
        );
      },
    );
  }
}
