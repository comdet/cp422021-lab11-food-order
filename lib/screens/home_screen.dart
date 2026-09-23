// ============================================================================
// home_screen.dart — หน้าแรกของแอป จอแรกที่เปิดขึ้นเมื่อเริ่มแอป
//
// จอนี้เรียก MenuRepository.instance.loadMenu() เพื่อขอรายการเมนู แล้วจัดวางเป็น
// สี่ช่วงจากบนลงล่าง คือ หัวร้าน · ช่องค้นหา · เมนูแนะนำ · เมนูทั้งหมด
// จอไม่รู้ว่ารายการมาจากที่ใด เมื่อคุณเปลี่ยนแหล่งข้อมูลในงานข้อ ①
// ไฟล์นี้จึงไม่ต้องแก้
//
// ── ส่วนที่ให้มาแล้ว (ไม่ต้องแก้ในแล็บนี้) ──────────────────────────────────
//   - การขอรายการเมนูและการแสดงสามสถานะ: กำลังโหลด · ได้ข้อมูล · เกิดข้อผิดพลาด
//   - ช่องค้นหาที่กรองรายการตามชื่อ
//   - แถวเมนูแนะนำที่เลื่อนแนวนอนได้
//   - การกดการ์ดเพื่อเปิดจอรายละเอียดของเมนูนั้น
//
// ไฟล์นี้ไม่มีจุดที่ต้องเติม
// ============================================================================
import 'package:flutter/material.dart';

import '../cart_view_model.dart';
import '../data/shop_info.dart';
import '../models/menu_item.dart';
import '../repositories/menu_repository.dart';
import '../theme.dart';
import '../widgets/menu_big_card.dart';
import '../widgets/menu_card.dart';
import '../widgets/menu_skeleton.dart';
import '../widgets/section_title.dart';
import '../widgets/shop_hero.dart';
import 'menu_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  /// งานขอรายการเมนูที่ยังทำอยู่หรือทำเสร็จแล้ว FutureBuilder ข้างล่างใช้ค่านี้
  late Future<List<MenuItem>> _menuRequest;

  /// คำที่พิมพ์ในช่องค้นหา ใช้กรองรายการที่แสดง
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

  void _addToCart(MenuItem item) {
    cart.addOne(item);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('เพิ่ม ${item.name} ลงตะกร้าแล้ว'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _openDetail(MenuItem item) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) => MenuDetailScreen(item: item),
      ),
    );
  }

  /// รายการที่ผ่านการกรองตามคำค้น — ถ้าไม่ได้พิมพ์อะไรจะคืนรายการทั้งหมด
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

              return CustomScrollView(
                slivers: <Widget>[
                  SliverToBoxAdapter(child: ShopHero(shop: ShopInfo.demo)),
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
                        title: 'ยังไม่มีรายการเมนู',
                        detail:
                            'อ่านข้อมูลได้แล้วแต่ไม่พบรายการใดเลย '
                            'ถ้าเพิ่งต่อฐานข้อมูลเสร็จ '
                            'ให้กลับไปกรอกเมนูในหน้าคอนโซลก่อน',
                        tone: AppColors.textMuted,
                      ),
                    )
                  else ...<Widget>[
                    // แถวเมนูแนะนำแสดงเฉพาะตอนที่ยังไม่ได้ค้นหา
                    if (_query.trim().isEmpty) ...<Widget>[
                      const SliverToBoxAdapter(
                        child: SectionTitle(title: 'แนะนำวันนี้'),
                      ),
                      SliverToBoxAdapter(child: _recommendedRow(all)),
                    ],
                    SliverToBoxAdapter(
                      child: SectionTitle(
                        title: _query.trim().isEmpty
                            ? 'เมนูทั้งหมด'
                            : 'ผลการค้นหา ${shown.length} รายการ',
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

  /// ช่องค้นหา — กรองรายการในเครื่องทันทีที่พิมพ์ ไม่ได้ยิงคำค้นไปที่ฐานข้อมูล
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
        decoration: InputDecoration(
          hintText: 'ค้นหาเมนู',
          prefixIcon: const Icon(Icons.search, color: AppColors.textMuted),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpace.lg,
            vertical: AppSpace.md,
          ),
        ),
      ),
    );
  }

  /// แถวเมนูแนะนำ — หยิบสี่รายการแรกจากรายการที่อ่านมาได้
  /// ไม่ต้องมีฟิลด์เพิ่มในฐานข้อมูล
  Widget _recommendedRow(List<MenuItem> items) {
    final List<MenuItem> picks = items.take(4).toList();
    return SizedBox(
      height: 232,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpace.lg),
        itemCount: picks.length,
        separatorBuilder: (BuildContext context, int index) =>
            const SizedBox(width: AppSpace.md),
        itemBuilder: (BuildContext context, int index) {
          final MenuItem item = picks[index];
          return MenuBigCard(
            item: item,
            onAdd: () => _addToCart(item),
            onOpen: () => _openDetail(item),
          );
        },
      ),
    );
  }

  /// จอตอนที่ค้นหาแล้วไม่เจอรายการที่ตรง
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
