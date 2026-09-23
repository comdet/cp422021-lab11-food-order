// ============================================================================
// home_screen.dart — หน้าแรกของแอปส่งอาหาร
//
// หน้าแรกของแอปส่งอาหารไม่ใช่เมนูอาหาร แต่เป็น **รายชื่อร้านที่ส่งถึงที่อยู่นี้**
// ผู้ใช้เลือกร้านก่อน แล้วจึงเห็นเมนูของร้านนั้นในจอถัดไป
//
// จอนี้ไล่รายชื่อร้านจาก lib/data/demo_restaurants.dart ซึ่งเขียนค้างไว้ในโค้ด
// **รายชื่อร้านไม่ใช่งานของแล็บนี้** งานของคุณคือเมนูของร้าน (งานข้อ ①)
// ซึ่งอยู่ในจอถัดไป
//
// ── ส่วนที่ให้มาแล้ว (ไม่ต้องแก้ในแล็บนี้) ──────────────────────────────────
//   - แถบที่อยู่ปลายทาง
//   - ช่องค้นหาร้านตามชื่อ ประเภทอาหาร และอำเภอ
//   - แถวร้านแนะนำที่เลื่อนแนวนอน และรายชื่อร้านทั้งหมด
//   - การกดร้านเพื่อเปิดจอเมนูของร้านนั้น
//
// ไฟล์นี้ไม่มีจุดที่ต้องเติม
// ============================================================================
import 'package:flutter/material.dart';

import '../data/delivery_info.dart';
import '../data/demo_restaurants.dart';
import '../models/restaurant.dart';
import '../theme.dart';
import '../widgets/address_bar.dart';
import '../widgets/restaurant_card.dart';
import '../widgets/section_title.dart';
import 'restaurant_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _query = '';

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

  /// ร้านที่ผ่านการกรองตามคำค้น — ค้นได้ทั้งชื่อร้าน ประเภทอาหาร และอำเภอ
  List<Restaurant> get _shown {
    final String q = _query.trim().toLowerCase();
    if (q.isEmpty) {
      return demoRestaurants;
    }
    return demoRestaurants.where((Restaurant r) {
      final String haystack = '${r.name} ${r.foodTypes.join(' ')} ${r.area}'
          .toLowerCase();
      return haystack.contains(q);
    }).toList();
  }

  /// ร้านแนะนำ — เรียงตามคะแนนแล้วหยิบสี่ร้านแรกที่เปิดอยู่
  List<Restaurant> get _recommended {
    final List<Restaurant> open =
        demoRestaurants.where((Restaurant r) => r.isOpen).toList()
          ..sort((Restaurant a, Restaurant b) => b.rating.compareTo(a.rating));
    return open.take(4).toList();
  }

  @override
  Widget build(BuildContext context) {
    final bool searching = _query.trim().isNotEmpty;
    final List<Restaurant> shown = _shown;
    return Scaffold(
      body: Column(
        children: <Widget>[
          AddressBar(info: DeliveryInfo.demo, onChange: _changeAddress),
          Expanded(
            child: CustomScrollView(
              slivers: <Widget>[
                SliverToBoxAdapter(child: _searchField()),
                if (!searching) ...<Widget>[
                  const SliverToBoxAdapter(
                    child: SectionTitle(title: 'ร้านแนะนำ'),
                  ),
                  SliverToBoxAdapter(child: _recommendedRow()),
                ],
                SliverToBoxAdapter(
                  child: SectionTitle(
                    title: searching
                        ? 'พบ ${shown.length} ร้าน'
                        : 'ร้านทั้งหมดที่ส่งถึงคุณ',
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
                        final Restaurant r = shown[index];
                        return RestaurantCard(
                          restaurant: r,
                          onOpen: () => _openRestaurant(r),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
        ],
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
          hintText: 'ค้นหาร้านหรือประเภทอาหาร',
          prefixIcon: Icon(Icons.search, color: AppColors.textMuted),
          contentPadding: EdgeInsets.symmetric(
            horizontal: AppSpace.lg,
            vertical: AppSpace.md,
          ),
        ),
      ),
    );
  }

  Widget _recommendedRow() {
    final List<Restaurant> picks = _recommended;
    return SizedBox(
      height: 196,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpace.lg),
        itemCount: picks.length,
        separatorBuilder: (BuildContext context, int index) =>
            const SizedBox(width: AppSpace.md),
        itemBuilder: (BuildContext context, int index) {
          final Restaurant r = picks[index];
          return RestaurantMiniCard(
            restaurant: r,
            onOpen: () => _openRestaurant(r),
          );
        },
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
            'ไม่พบร้านที่ตรงกับคำว่า "${_query.trim()}"',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
