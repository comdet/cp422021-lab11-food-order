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
      appBar: AppBar(
        title: const Text('ตะกร้า'),
        backgroundColor: AppColors.brand,
        foregroundColor: Colors.white,
      ),
      body: ListenableBuilder(
        listenable: cart,
        builder: (BuildContext context, Widget? child) {
          if (cart.isEmpty) {
            return const Center(child: Text('ยังไม่มีของในตะกร้า'));
          }
          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
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

  Widget _lineTile(OrderLine line) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Card(
      elevation: 0,
      color: AppColors.surface,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppColors.line),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 8, 8, 8),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(line.item.name, style: textTheme.titleMedium),
                  const SizedBox(height: 4),
                  Text('${line.item.price} บาท ต่อรายการ', style: textTheme.bodySmall),
                ],
              ),
            ),
            IconButton(
              onPressed: () => cart.removeOne(line.item),
              tooltip: 'ลดจำนวน',
              icon: const Icon(Icons.remove),
            ),
            Text('${line.quantity}', style: textTheme.titleMedium),
            IconButton(
              onPressed: () => cart.addOne(line.item),
              tooltip: 'เพิ่มจำนวน',
              icon: const Icon(Icons.add),
            ),
            SizedBox(
              width: 72,
              child: Text(
                '${line.lineTotal} บาท',
                textAlign: TextAlign.right,
                style: textTheme.titleMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bottomBar() {
    return ListenableBuilder(
      listenable: cart,
      builder: (BuildContext context, Widget? child) {
        final bool canSend = !cart.isEmpty && !_sending;
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    'ยอดรวม ${cart.totalPrice} บาท',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                FilledButton(
                  onPressed: canSend ? _placeOrder : null,
                  child: Text(_sending ? 'กำลังส่ง' : 'สั่ง'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
