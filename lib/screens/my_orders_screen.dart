// ============================================================================
// my_orders_screen.dart — จอ "ออเดอร์ของฉัน"
//
// แสดงออเดอร์ที่สั่งไปแล้วในรอบการใช้งานนี้ พร้อมสถานะของแต่ละใบ
// สถานะตั้งต้นของออเดอร์ใหม่คือ waiting แปลว่า **ยังไม่มีคนส่งรับงาน**
//
// ── ส่วนที่ให้มาแล้ว (ไม่ต้องแก้ในแล็บนี้) ──────────────────────────────────
//   - รายการออเดอร์พร้อมร้าน ยอดรวม ที่อยู่ปลายทาง และสถานะ
//   - จอตอนที่ยังไม่เคยสั่ง
//
// ไฟล์นี้ไม่มีจุดที่ต้องเติม
//
// ★ จอนี้อ่านจากหน่วยความจำของแอป ไม่ได้อ่านจากฐานข้อมูล
//   การให้คนส่งอาหารเห็นงานที่รอรับ และการเปลี่ยนสถานะ เป็นเนื้อของสัปดาห์ถัดไป
// ============================================================================
import 'package:flutter/material.dart';

import '../models/food_order.dart';
import '../my_orders_store.dart';
import '../screens/app_shell.dart';
import '../theme.dart';

class MyOrdersScreen extends StatelessWidget {
  const MyOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ออเดอร์ของฉัน')),
      body: ListenableBuilder(
        listenable: myOrders,
        builder: (BuildContext context, Widget? child) {
          if (myOrders.isEmpty) {
            return _emptyView(context);
          }
          final List<FoodOrder> orders = myOrders.orders;
          return ListView.builder(
            padding: const EdgeInsets.all(AppSpace.lg),
            itemCount: orders.length,
            itemBuilder: (BuildContext context, int index) {
              return _orderCard(context, orders[index], orders.length - index);
            },
          );
        },
      ),
    );
  }

  Widget _orderCard(BuildContext context, FoodOrder order, int number) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final int pieces = order.lines.fold<int>(
      0,
      (int sum, OrderLine line) => sum + line.quantity,
    );
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpace.md),
      padding: const EdgeInsets.all(AppSpace.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpace.radiusCard),
        boxShadow: AppSpace.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  order.restaurantName.isEmpty ? 'ร้าน' : order.restaurantName,
                  style: textTheme.titleMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              _statusChip(order.status),
            ],
          ),
          const SizedBox(height: AppSpace.sm),
          Text(
            'ออเดอร์ที่ $number · $pieces รายการ',
            style: textTheme.bodySmall,
          ),
          const SizedBox(height: AppSpace.xs),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Icon(
                Icons.place_outlined,
                size: 16,
                color: AppColors.textMuted,
              ),
              const SizedBox(width: 6),
              Expanded(child: Text(order.address, style: textTheme.bodySmall)),
            ],
          ),
          const Divider(height: AppSpace.xl),
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  'ค่าอาหาร ${order.subtotal} · ค่าส่ง ${order.deliveryFee}',
                  style: textTheme.bodySmall,
                ),
              ),
              Text(
                '${order.total} บาท',
                style: textTheme.titleMedium?.copyWith(color: AppColors.brand),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statusChip(String status) {
    final bool waiting = status == 'waiting';
    final Color tone = waiting ? AppColors.brand : AppColors.success;
    final String label = waiting ? 'รอคนส่งรับงาน' : status;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpace.md, vertical: 5),
      decoration: BoxDecoration(
        color: tone.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(
            waiting ? Icons.schedule : Icons.check_circle,
            size: 14,
            color: tone,
          ),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              height: 1.4,
              fontWeight: FontWeight.w600,
              color: tone,
            ),
          ),
        ],
      ),
    );
  }

  Widget _emptyView(BuildContext context) {
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
                Icons.receipt_long,
                size: 44,
                color: AppColors.brand,
              ),
            ),
            const SizedBox(height: AppSpace.lg),
            Text('ยังไม่เคยสั่ง', style: textTheme.titleLarge),
            const SizedBox(height: AppSpace.sm),
            Text(
              'เลือกร้านจากหน้าแรก ใส่ของลงตะกร้า แล้วกดสั่ง '
              'ออเดอร์จะมาขึ้นที่จอนี้พร้อมสถานะ',
              textAlign: TextAlign.center,
              style: textTheme.bodySmall,
            ),
            const SizedBox(height: AppSpace.xl),
            OutlinedButton(
              onPressed: () => shellTab.value = 0,
              child: const Text('ไปเลือกร้าน'),
            ),
          ],
        ),
      ),
    );
  }
}
