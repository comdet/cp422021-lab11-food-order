// ============================================================================
// menu_detail_screen.dart — จอรายละเอียดของเมนูหนึ่งรายการ
//
// เปิดจอนี้ด้วยการกดที่การ์ดเมนูบนหน้าแรก · จอนี้รับข้อมูลเมนูเข้ามาทาง
// พารามิเตอร์ ไม่ได้อ่านข้อมูลจากที่ใดเอง จึงไม่ต้องแก้เมื่อเปลี่ยนแหล่งข้อมูล
//
// ── ส่วนที่ให้มาแล้ว (ไม่ต้องแก้ในแล็บนี้) ──────────────────────────────────
//   - ภาพใหญ่ ชื่อ ราคา ตัวเลือกจำนวน และปุ่มเพิ่มลงตะกร้า
//
// ไฟล์นี้ไม่มีจุดที่ต้องเติม
// ============================================================================
import 'package:flutter/material.dart';

import '../cart_view_model.dart';
import '../data/shop_info.dart';
import '../models/menu_item.dart';
import '../theme.dart';
import '../widgets/food_image.dart';

class MenuDetailScreen extends StatefulWidget {
  const MenuDetailScreen({super.key, required this.item});

  final MenuItem item;

  @override
  State<MenuDetailScreen> createState() => _MenuDetailScreenState();
}

class _MenuDetailScreenState extends State<MenuDetailScreen> {
  int _quantity = 1;

  void _addToCart() {
    for (int i = 0; i < _quantity; i++) {
      cart.addOne(widget.item);
    }
    final NavigatorState navigator = Navigator.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'เพิ่ม ${widget.item.name} $_quantity รายการลงตะกร้าแล้ว',
        ),
        duration: const Duration(seconds: 1),
      ),
    );
    navigator.maybePop();
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final MenuItem item = widget.item;
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 260,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: FoodImage(
                path: item.imagePath,
                width: double.infinity,
                height: 260,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppSpace.xl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(item.name, style: textTheme.headlineSmall),
                  const SizedBox(height: AppSpace.sm),
                  Text(
                    '${item.price} บาท',
                    style: textTheme.headlineSmall?.copyWith(
                      color: AppColors.brand,
                    ),
                  ),
                  const SizedBox(height: AppSpace.lg),
                  _shopRow(),
                  const SizedBox(height: AppSpace.xl),
                  Text('จำนวน', style: textTheme.titleMedium),
                  const SizedBox(height: AppSpace.sm),
                  _quantityRow(),
                  const SizedBox(height: AppSpace.xl),
                  _flowNote(),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _bottomBar(),
    );
  }

  /// แถบร้านที่ขายเมนูนี้ — ข้อมูลมาจาก ShopInfo ซึ่งเป็นค่าคงที่ของแอป
  Widget _shopRow() {
    const ShopInfo shop = ShopInfo.demo;
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(AppSpace.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpace.radiusCard),
        border: Border.all(color: AppColors.line),
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: AppColors.brandSoft,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.storefront,
              size: 22,
              color: AppColors.brand,
            ),
          ),
          const SizedBox(width: AppSpace.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(shop.name, style: textTheme.titleMedium),
                Text(
                  'ส่ง ${shop.deliveryMinutes} นาที · '
                  '${shop.rating} (${shop.ratingCount} รีวิว)',
                  style: textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// อธิบายว่ากดปุ่มล่างแล้วจะเกิดอะไร — กันเข้าใจผิดว่ากดแล้วคือสั่งอาหารเลย
  Widget _flowNote() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Icon(Icons.info_outline, size: 18, color: AppColors.textMuted),
        const SizedBox(width: AppSpace.sm),
        Expanded(
          child: Text(
            'กดเพิ่มลงตะกร้าแล้วรายการจะไปรออยู่ในตะกร้าก่อน '
            'ออเดอร์จะถูกส่งจริงเมื่อกดปุ่มสั่งอาหารที่จอตะกร้า',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
      ],
    );
  }

  Widget _quantityRow() {
    return Row(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            color: AppColors.brandSoft,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              IconButton(
                onPressed: _quantity > 1
                    ? () => setState(() => _quantity--)
                    : null,
                tooltip: 'ลดจำนวน',
                icon: const Icon(Icons.remove, color: AppColors.brandDark),
              ),
              SizedBox(
                width: 36,
                child: Text(
                  '$_quantity',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              IconButton(
                onPressed: () => setState(() => _quantity++),
                tooltip: 'เพิ่มจำนวน',
                icon: const Icon(Icons.add, color: AppColors.brandDark),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _bottomBar() {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.line)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpace.lg),
          child: FilledButton(
            onPressed: _addToCart,
            child: Text('เพิ่มลงตะกร้า · ${widget.item.price * _quantity} บาท'),
          ),
        ),
      ),
    );
  }
}
