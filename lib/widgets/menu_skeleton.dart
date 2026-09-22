// ============================================================================
// menu_skeleton.dart — โครงร่างเทาที่แสดงระหว่างรอรายการเมนู
//
// ทำไมต้องมีไฟล์นี้
//   ตอนที่เมนูยังมาจากไฟล์ในเครื่อง ข้อมูลมาถึงทันทีจนแทบไม่เห็นช่วงรอ
//   แต่เมื่อคุณทำงานข้อ ① เสร็จ ข้อมูลจะมาจากเครือข่าย ช่วงรอจะเห็นได้จริง
//   โครงร่างเทาบอกผู้ใช้ล่วงหน้าว่ากำลังจะมีรายการหน้าตาแบบใดกี่แถว
//   และทำให้หน้าจอไม่กระโดดตอนข้อมูลมาถึง ต่างจากวงกลมหมุนกลางจอ
//
// ── ส่วนที่ให้มาแล้ว (ไม่ต้องแก้ในแล็บนี้) ──────────────────────────────────
//   - MenuSkeletonList  รายการโครงร่างเทาพร้อมการกะพริบช้า ๆ
//
// ไฟล์นี้ไม่มีจุดที่ต้องเติม
// ============================================================================
import 'package:flutter/material.dart';

import '../theme.dart';

class MenuSkeletonList extends StatefulWidget {
  const MenuSkeletonList({super.key, this.rows = 5});

  /// จำนวนแถวของโครงร่างที่จะแสดง
  final int rows;

  @override
  State<MenuSkeletonList> createState() => _MenuSkeletonListState();
}

class _MenuSkeletonListState extends State<MenuSkeletonList>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    // กะพริบไปกลับช้า ๆ เพื่อบอกว่ายังทำงานอยู่ ไม่ใช่จอค้าง
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(
        AppSpace.lg,
        AppSpace.lg,
        AppSpace.lg,
        AppSpace.xl,
      ),
      itemCount: widget.rows,
      itemBuilder: (BuildContext context, int index) {
        return FadeTransition(
          opacity: Tween<double>(begin: 0.45, end: 1).animate(_controller),
          child: const _SkeletonRow(),
        );
      },
    );
  }
}

class _SkeletonRow extends StatelessWidget {
  const _SkeletonRow();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpace.md),
      height: 108,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpace.radiusCard),
        boxShadow: AppSpace.cardShadow,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            width: 108,
            decoration: const BoxDecoration(
              color: AppColors.brandSoft,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(AppSpace.radiusCard),
                bottomLeft: Radius.circular(AppSpace.radiusCard),
              ),
            ),
          ),
          const Expanded(
            child: Padding(
              padding: EdgeInsets.all(AppSpace.md),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _Bar(widthFactor: 0.72),
                  SizedBox(height: AppSpace.sm),
                  _Bar(widthFactor: 0.34),
                ],
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(right: AppSpace.md),
            child: Center(
              child: SizedBox(
                width: 44,
                height: 44,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: AppColors.brandSoft,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// แถบเทาแทนบรรทัดข้อความหนึ่งบรรทัด
class _Bar extends StatelessWidget {
  const _Bar({required this.widthFactor});

  final double widthFactor;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      alignment: Alignment.centerLeft,
      widthFactor: widthFactor,
      child: Container(
        height: 14,
        decoration: BoxDecoration(
          color: AppColors.line,
          borderRadius: BorderRadius.circular(999),
        ),
      ),
    );
  }
}
