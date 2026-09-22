// ============================================================================
// cart_screen.dart — จอตะกร้า แสดงของที่เลือกไว้ ยอดรวม และปุ่มสั่ง
//
// ลำดับที่เกิดขึ้นเมื่อกดปุ่มสั่ง
//   1. ถาม AuthService ว่ามีบัญชีใดเข้าสู่ระบบอยู่ (งานข้อ ②)
//      ถ้ายังไม่มี จอนี้จะพาผู้ใช้ไปหน้าเข้าสู่ระบบ
//   2. รวบรวมของในตะกร้าเป็นออเดอร์หนึ่งใบ แล้วส่งให้ OrderRepository (งานข้อ ③)
//      พร้อมรหัสประจำตัวผู้ใช้ (uid) ของบัญชีที่เข้าสู่ระบบอยู่
//
// ── ส่วนที่ให้มาแล้ว (ไม่ต้องแก้ในแล็บนี้) ──────────────────────────────────
//   - รายการในตะกร้า ปุ่มเพิ่มลด และยอดรวม
//   - การเรียก AuthService และ OrderRepository ตามลำดับข้างบน
//   - การแสดงข้อความที่สองไฟล์นั้นโยนออกมา
//
// ไฟล์นี้ไม่มีจุดที่ต้องเติม
//
// ★ ก่อนทำงานข้อ ② และ ③ เสร็จ ปุ่มสั่งจะขึ้นข้อความว่ายังทำงานข้อนั้นไม่เสร็จ
//   อาการนี้ถูกต้อง ไม่ใช่ข้อผิดพลาดของโครง
// ============================================================================
import 'package:flutter/material.dart';

import '../auth_service.dart';
import '../cart_view_model.dart';
import '../models/food_order.dart';
import '../repositories/order_repository.dart';
import '../theme.dart';
import '../widgets/food_image.dart';
import 'login_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  /// จริงระหว่างที่กำลังส่งออเดอร์ ใช้กันการกดปุ่มซ้ำ
  bool _sending = false;

  Future<void> _placeOrder() async {
    // อ้างถึงสองตัวนี้ไว้ก่อนเรียกงานที่ต้องรอ เพราะหลังจากรอแล้วหน้าจออาจถูกปิดไปแล้ว
    final ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);
    final NavigatorState navigator = Navigator.of(context);

    String? uid;
    try {
      uid = AuthService.instance.currentUid;
    } on UnimplementedError catch (error) {
      _show(messenger, error.message ?? 'ยังทำงานข้อ ② ไม่เสร็จ');
      return;
    }

    if (uid == null) {
      // ยังไม่มีบัญชีใดเข้าสู่ระบบ — พาไปหน้าเข้าสู่ระบบก่อน
      _show(messenger, 'ต้องเข้าสู่ระบบก่อนจึงจะสั่งได้');
      await navigator.push(
        MaterialPageRoute<void>(
          builder: (BuildContext context) => const LoginScreen(),
        ),
      );
      return;
    }

    final FoodOrder order = cart.buildOrder();
    setState(() {
      _sending = true;
    });
    try {
      await OrderRepository.instance.placeOrder(order: order, uid: uid);
      cart.clear();
      _show(messenger, 'ส่งออเดอร์เรียบร้อย');
    } on UnimplementedError catch (error) {
      _show(messenger, error.message ?? 'ยังทำงานข้อ ③ ไม่เสร็จ');
    } catch (error) {
      // ข้อความที่แสดงคือข้อความจริงที่ repository โยนออกมา ไม่ได้เขียนทับ
      _show(messenger, 'ส่งออเดอร์ไม่สำเร็จ: $error');
    } finally {
      if (mounted) {
        setState(() {
          _sending = false;
        });
      }
    }
  }

  void _show(ScaffoldMessengerState messenger, String message) {
    messenger.showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ตะกร้า')),
      body: ListenableBuilder(
        listenable: cart,
        builder: (BuildContext context, Widget? child) {
          if (cart.isEmpty) {
            return _emptyView();
          }
          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(
              AppSpace.lg,
              AppSpace.lg,
              AppSpace.lg,
              AppSpace.lg,
            ),
            itemCount: cart.lines.length,
            itemBuilder: (BuildContext context, int index) {
              return _lineTile(cart.lines[index]);
            },
          );
        },
      ),
      bottomNavigationBar: _bottomBar(),
    );
  }

  /// จอตอนที่ยังไม่มีของในตะกร้า — บอกสถานะและมีทางเดินต่อให้กดได้
  Widget _emptyView() {
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
                Icons.shopping_cart_outlined,
                size: 44,
                color: AppColors.brand,
              ),
            ),
            const SizedBox(height: AppSpace.lg),
            Text('ยังไม่มีของในตะกร้า', style: textTheme.titleLarge),
            const SizedBox(height: AppSpace.sm),
            Text(
              'กลับไปที่จอเมนูแล้วกดปุ่มบวกที่รายการที่ต้องการ',
              textAlign: TextAlign.center,
              style: textTheme.bodySmall,
            ),
            const SizedBox(height: AppSpace.xl),
            OutlinedButton(
              onPressed: () => Navigator.of(context).maybePop(),
              child: const Text('กลับไปเลือกเมนู'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _lineTile(OrderLine line) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpace.md),
      padding: const EdgeInsets.all(AppSpace.sm),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpace.radiusCard),
        boxShadow: AppSpace.cardShadow,
      ),
      child: Row(
        children: <Widget>[
          FoodImage(
            path: line.item.imagePath,
            width: 64,
            height: 64,
            radius: AppSpace.radiusControl,
          ),
          const SizedBox(width: AppSpace.md),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  line.item.name,
                  style: textTheme.titleMedium,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSpace.xs),
                Text(
                  '${line.lineTotal} บาท',
                  style: textTheme.titleMedium?.copyWith(
                    color: AppColors.brand,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpace.sm),
          _quantityStepper(line),
        ],
      ),
    );
  }

  /// กล่องเพิ่มลดจำนวน — รวมปุ่มลบ ตัวเลข และปุ่มบวกไว้ในกรอบเดียว
  /// เพื่อให้เห็นว่าสามอย่างนี้เป็นชุดเดียวกัน ไม่ใช่ปุ่มสามปุ่มที่ไม่เกี่ยวกัน
  Widget _quantityStepper(OrderLine line) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.brandSoft,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _stepperButton(
            icon: Icons.remove,
            tooltip: 'ลดจำนวน',
            onPressed: () => cart.removeOne(line.item),
          ),
          SizedBox(
            width: 28,
            child: Text(
              '${line.quantity}',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          _stepperButton(
            icon: Icons.add,
            tooltip: 'เพิ่มจำนวน',
            onPressed: () => cart.addOne(line.item),
          ),
        ],
      ),
    );
  }

  Widget _stepperButton({
    required IconData icon,
    required String tooltip,
    required VoidCallback onPressed,
  }) {
    return IconButton(
      onPressed: onPressed,
      tooltip: tooltip,
      visualDensity: VisualDensity.compact,
      constraints: const BoxConstraints(minWidth: 38, minHeight: 38),
      padding: EdgeInsets.zero,
      icon: Icon(icon, size: 20, color: AppColors.brandDark),
    );
  }

  Widget _bottomBar() {
    return ListenableBuilder(
      listenable: cart,
      builder: (BuildContext context, Widget? child) {
        final bool canSend = !cart.isEmpty && !_sending;
        final TextTheme textTheme = Theme.of(context).textTheme;
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.surface,
            border: Border(top: BorderSide(color: AppColors.line)),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpace.lg,
                AppSpace.md,
                AppSpace.lg,
                AppSpace.md,
              ),
              child: Row(
                children: <Widget>[
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('ยอดรวม', style: textTheme.bodySmall),
                      Text(
                        '${cart.totalPrice} บาท',
                        style: textTheme.titleLarge?.copyWith(
                          color: AppColors.brand,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: AppSpace.lg),
                  Expanded(
                    child: FilledButton(
                      onPressed: canSend ? _placeOrder : null,
                      child: Text(_sending ? 'กำลังส่ง' : 'สั่งอาหาร'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
