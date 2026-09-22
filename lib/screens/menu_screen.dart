// ============================================================================
// menu_screen.dart — จอเมนู เป็นจอแรกที่เปิดขึ้นเมื่อเริ่มแอป
//
// จอนี้เรียก MenuRepository.instance.loadMenu() เพื่อขอรายการเมนู แล้ววาดการ์ด
// ทีละรายการ · จอไม่รู้ว่ารายการมาจากที่ใด เมื่อคุณเปลี่ยนแหล่งข้อมูลในงานข้อ ①
// ไฟล์นี้จึงไม่ต้องแก้
//
// ── ส่วนที่ให้มาแล้ว (ไม่ต้องแก้ในแล็บนี้) ──────────────────────────────────
//   - การขอรายการเมนูและการแสดงสามสถานะ: กำลังโหลด · ได้ข้อมูล · เกิดข้อผิดพลาด
//   - ปุ่มลองใหม่เมื่อโหลดไม่สำเร็จ
//   - ปุ่มตะกร้าพร้อมจำนวนชิ้น ซึ่งเปลี่ยนตามตะกร้าเอง
//   - ปุ่มเข้าสู่ระบบที่มุมบนขวา
//
// ไฟล์นี้ไม่มีจุดที่ต้องเติม
// ============================================================================
import 'package:flutter/material.dart';

import '../cart_view_model.dart';
import '../models/menu_item.dart';
import '../repositories/menu_repository.dart';
import '../theme.dart';
import '../widgets/menu_card.dart';
import '../widgets/menu_skeleton.dart';
import 'cart_screen.dart';
import 'login_screen.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  /// งานขอรายการเมนูที่ยังทำอยู่หรือทำเสร็จแล้ว FutureBuilder ข้างล่างใช้ค่านี้
  late Future<List<MenuItem>> _menuRequest;

  @override
  void initState() {
    super.initState();
    _menuRequest = MenuRepository.instance.loadMenu();
  }

  void _reloadMenu() {
    setState(() {
      _menuRequest = MenuRepository.instance.loadMenu();
    });
  }

  void _addToCart(MenuItem item) {
    cart.addOne(item);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('เพิ่ม ${item.name} ลงตะกร้าแล้ว'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _openCart() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) => const CartScreen(),
      ),
    );
  }

  void _openLogin() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) => const LoginScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('เมนูของร้าน'),
        actions: <Widget>[
          IconButton(
            onPressed: _openLogin,
            tooltip: 'เข้าสู่ระบบ',
            icon: const Icon(Icons.person_outline),
          ),
          _cartButton(),
          const SizedBox(width: AppSpace.sm),
        ],
      ),
      body: FutureBuilder<List<MenuItem>>(
        future: _menuRequest,
        builder: (BuildContext context, AsyncSnapshot<List<MenuItem>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // โครงร่างเทาแทนวงกลมหมุน — ผู้ใช้เห็นทันทีว่ากำลังจะมีรายการกี่แถว
            // และหน้าจอไม่กระโดดเมื่อข้อมูลมาถึง
            return const MenuSkeletonList();
          }
          if (snapshot.hasError) {
            return _errorView(snapshot.error);
          }
          final List<MenuItem> items = snapshot.data ?? const <MenuItem>[];
          if (items.isEmpty) {
            return _emptyView();
          }
          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(
              AppSpace.lg,
              AppSpace.lg,
              AppSpace.lg,
              AppSpace.xl,
            ),
            itemCount: items.length,
            itemBuilder: (BuildContext context, int index) {
              final MenuItem item = items[index];
              return MenuCard(item: item, onAdd: () => _addToCart(item));
            },
          );
        },
      ),
    );
  }

  /// ปุ่มตะกร้าพร้อมจำนวนชิ้น — ListenableBuilder ฟังการแจ้งเตือนจากตะกร้า
  /// แล้ววาดปุ่มนี้ใหม่เองเมื่อของในตะกร้าเปลี่ยน
  Widget _cartButton() {
    return ListenableBuilder(
      listenable: cart,
      builder: (BuildContext context, Widget? child) {
        final int count = cart.totalQuantity;
        return IconButton(
          onPressed: _openCart,
          tooltip: count < 1 ? 'ตะกร้า' : 'ตะกร้า $count ชิ้น',
          icon: Badge(
            isLabelVisible: count > 0,
            backgroundColor: Colors.white,
            textColor: AppColors.brand,
            label: Text('$count'),
            child: const Icon(Icons.shopping_cart_outlined),
          ),
        );
      },
    );
  }

  /// จอตอนที่ขอรายการเมนูสำเร็จแต่ไม่มีข้อมูลสักรายการ
  /// อาการนี้เกิดบ่อยตอนทำงานข้อ ① เสร็จใหม่ ๆ แต่ยังไม่ได้กรอกเมนูในคอนโซล
  Widget _emptyView() {
    return _stateView(
      icon: Icons.restaurant_menu,
      title: 'ยังไม่มีรายการเมนู',
      detail:
          'อ่านข้อมูลได้แล้วแต่ไม่พบรายการใดเลย '
          'ถ้าเพิ่งต่อฐานข้อมูลเสร็จ ให้กลับไปกรอกเมนูในหน้าคอนโซลก่อน',
      tone: AppColors.textMuted,
    );
  }

  /// จอที่แสดงเมื่อขอรายการเมนูไม่สำเร็จ
  /// ข้อความที่แสดงคือข้อความจริงที่ repository โยนออกมา ไม่ได้เขียนทับ
  Widget _errorView(Object? error) {
    return _stateView(
      icon: Icons.cloud_off,
      title: 'โหลดรายการเมนูไม่สำเร็จ',
      detail: '$error',
      tone: AppColors.danger,
    );
  }

  /// โครงร่วมของจอว่างและจอผิดพลาด — ไอคอน หัวข้อ คำอธิบาย และปุ่มลองใหม่
  Widget _stateView({
    required IconData icon,
    required String title,
    required String detail,
    required Color tone,
  }) {
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
              decoration: BoxDecoration(
                color: tone.withValues(alpha: 0.10),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 44, color: tone),
            ),
            const SizedBox(height: AppSpace.lg),
            Text(title, style: textTheme.titleLarge),
            const SizedBox(height: AppSpace.sm),
            Text(
              detail,
              textAlign: TextAlign.center,
              style: textTheme.bodySmall,
            ),
            const SizedBox(height: AppSpace.xl),
            FilledButton(onPressed: _reloadMenu, child: const Text('ลองใหม่')),
          ],
        ),
      ),
    );
  }
}
