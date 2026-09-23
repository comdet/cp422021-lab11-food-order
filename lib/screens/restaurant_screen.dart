// ============================================================================
// restaurant_screen.dart — จอเมนูของร้านที่เลือกจากหน้าแรก
//
// ★ จอนี้คือจอที่เกี่ยวกับงานข้อ ① ของแล็บ
//   จอนี้เรียก MenuRepository.instance.loadMenu() เพื่อขอรายการเมนู
//   จอไม่รู้ว่ารายการมาจากที่ใด เมื่อคุณเปลี่ยนแหล่งข้อมูลใน menu_repository.dart
//   จากรายการตัวอย่างไปเป็น Cloud Firestore ไฟล์นี้จึงไม่ต้องแก้
//   และภาพหน้าจอที่ต้องส่งเป็นชิ้นที่ 1 ก็ถ่ายจากจอนี้
//
// ── ส่วนที่ให้มาแล้ว (ไม่ต้องแก้ในแล็บนี้) ──────────────────────────────────
//   - หัวร้าน พร้อมคะแนน เวลาส่ง และระยะทาง
//   - การขอรายการเมนูและการแสดงสามสถานะ: กำลังโหลด · ได้ข้อมูล · เกิดข้อผิดพลาด
//   - ช่องค้นหาเมนูภายในร้าน
//   - การเพิ่มลงตะกร้า และการเตือนเมื่อสั่งข้ามร้าน
//
// ไฟล์นี้ไม่มีจุดที่ต้องเติม
// ============================================================================
import 'package:flutter/material.dart';

import '../cart_view_model.dart';
import '../models/menu_item.dart';
import '../models/restaurant.dart';
import '../repositories/menu_repository.dart';
import '../theme.dart';
import '../widgets/menu_card.dart';
import '../widgets/menu_skeleton.dart';
import '../widgets/restaurant_hero.dart';
import '../widgets/section_title.dart';
import 'menu_detail_screen.dart';

class RestaurantScreen extends StatefulWidget {
  const RestaurantScreen({super.key, required this.restaurant});

  final Restaurant restaurant;

  @override
  State<RestaurantScreen> createState() => _RestaurantScreenState();
}

class _RestaurantScreenState extends State<RestaurantScreen> {
  late Future<List<MenuItem>> _menuRequest;
  String _query = '';

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

  /// เพิ่มลงตะกร้า — ถ้าตะกร้ามีของจากร้านอื่นอยู่ ต้องถามก่อนล้างทิ้ง
  Future<void> _addToCart(MenuItem item) async {
    final Restaurant? current = cart.restaurant;
    if (!cart.isEmpty &&
        current != null &&
        current.id != widget.restaurant.id) {
      final bool ok = await _confirmSwitch(current);
      if (!ok) {
        return;
      }
      cart.switchRestaurant(widget.restaurant);
    }
    cart.restaurant = widget.restaurant;
    cart.addOne(item);
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('เพิ่ม ${item.name} ลงตะกร้าแล้ว'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  Future<bool> _confirmSwitch(Restaurant current) async {
    final bool? answer = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('เปลี่ยนร้านหรือไม่'),
          content: Text(
            'ในตะกร้ามีของจาก ${current.name} อยู่ · '
            'หนึ่งออเดอร์สั่งได้จากร้านเดียว เพราะคนส่งไปรับที่ร้านเดียว · '
            'ถ้าสั่งจาก ${widget.restaurant.name} ของเดิมในตะกร้าจะถูกล้างทิ้ง',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('ยกเลิก'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('ล้างแล้วเปลี่ยนร้าน'),
            ),
          ],
        );
      },
    );
    return answer ?? false;
  }

  void _openDetail(MenuItem item) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) =>
            MenuDetailScreen(item: item, restaurant: widget.restaurant),
      ),
    );
  }

  List<MenuItem> _filtered(List<MenuItem> items) {
    final String q = _query.trim().toLowerCase();
    if (q.isEmpty) {
      return items;
    }
    return items
        .where((MenuItem item) => item.name.toLowerCase().contains(q))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<MenuItem>>(
        future: _menuRequest,
        builder:
            (BuildContext context, AsyncSnapshot<List<MenuItem>> snapshot) {
              final bool loading =
                  snapshot.connectionState == ConnectionState.waiting;
              final List<MenuItem> all = snapshot.data ?? const <MenuItem>[];
              final List<MenuItem> shown = _filtered(all);
              final bool searching = _query.trim().isNotEmpty;

              return CustomScrollView(
                slivers: <Widget>[
                  SliverToBoxAdapter(
                    child: RestaurantHero(restaurant: widget.restaurant),
                  ),
                  SliverToBoxAdapter(child: _searchField()),
                  if (loading)
                    const SliverToBoxAdapter(
                      child: SizedBox(
                        height: 420,
                        child: MenuSkeletonList(rows: 3),
                      ),
                    )
                  else if (snapshot.hasError)
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: _stateView(
                        icon: Icons.cloud_off,
                        title: 'โหลดรายการเมนูไม่สำเร็จ',
                        detail: '${snapshot.error}',
                        tone: AppColors.danger,
                      ),
                    )
                  else if (all.isEmpty)
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: _stateView(
                        icon: Icons.restaurant_menu,
                        title: 'ร้านนี้ยังไม่มีรายการเมนู',
                        detail:
                            'อ่านข้อมูลได้แล้วแต่ไม่พบรายการใดเลย '
                            'ถ้าเพิ่งต่อฐานข้อมูลเสร็จ '
                            'ให้กลับไปกรอกเมนูในหน้าคอนโซลก่อน',
                        tone: AppColors.textMuted,
                      ),
                    )
                  else ...<Widget>[
                    SliverToBoxAdapter(
                      child: SectionTitle(
                        title: searching
                            ? 'พบ ${shown.length} รายการ'
                            : 'เมนูของร้าน',
                      ),
                    ),
                    if (shown.isEmpty)
                      SliverToBoxAdapter(child: _noMatchView())
                    else
                      SliverPadding(
                        padding: const EdgeInsets.fromLTRB(
                          AppSpace.lg,
                          0,
                          AppSpace.lg,
                          AppSpace.xl,
                        ),
                        sliver: SliverList.builder(
                          itemCount: shown.length,
                          itemBuilder: (BuildContext context, int index) {
                            final MenuItem item = shown[index];
                            return MenuCard(
                              item: item,
                              onAdd: () => _addToCart(item),
                              onOpen: () => _openDetail(item),
                            );
                          },
                        ),
                      ),
                  ],
                ],
              );
            },
      ),
    );
  }

  Widget _searchField() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpace.lg,
        AppSpace.lg,
        AppSpace.lg,
        0,
      ),
      child: TextField(
        onChanged: (String value) => setState(() => _query = value),
        decoration: const InputDecoration(
          hintText: 'ค้นหาเมนูในร้านนี้',
          prefixIcon: Icon(Icons.search, color: AppColors.textMuted),
          contentPadding: EdgeInsets.symmetric(
            horizontal: AppSpace.lg,
            vertical: AppSpace.md,
          ),
        ),
      ),
    );
  }

  Widget _noMatchView() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpace.xl,
        AppSpace.lg,
        AppSpace.xl,
        AppSpace.xl,
      ),
      child: Column(
        children: <Widget>[
          const Icon(Icons.search_off, size: 40, color: AppColors.textMuted),
          const SizedBox(height: AppSpace.md),
          Text(
            'ไม่พบเมนูที่ตรงกับคำว่า "${_query.trim()}"',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

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
            Text(
              title,
              style: textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
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
