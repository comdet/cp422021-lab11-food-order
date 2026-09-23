// ============================================================================
// my_orders_store.dart — ออเดอร์ที่ผู้ใช้สั่งไปแล้วในรอบการใช้งานนี้
//
// เก็บไว้ในหน่วยความจำของแอปเท่านั้น ปิดแอปแล้วหาย · เก็บไว้ให้จอ "ออเดอร์ของฉัน"
// มีของแสดงทันทีหลังกดสั่ง โดยไม่ต้องอ่านกลับจากฐานข้อมูล
//
// ── ส่วนที่ให้มาแล้ว (ไม่ต้องแก้ในแล็บนี้) ──────────────────────────────────
//   - myOrders   รายการออเดอร์ของรอบนี้ เรียงจากใหม่ไปเก่า
//
// ไฟล์นี้ไม่มีจุดที่ต้องเติม
//
// ★ การอ่านออเดอร์เก่ากลับมาจาก Cloud Firestore ไม่ใช่งานของแล็บนี้
//   งานข้อ ③ วัดแค่ว่าเอกสารออเดอร์เกิดขึ้นจริงในฐานข้อมูล
// ============================================================================
import 'package:flutter/foundation.dart';

import 'models/food_order.dart';

class MyOrdersStore extends ChangeNotifier {
  final List<FoodOrder> _orders = <FoodOrder>[];

  /// ออเดอร์ของรอบนี้ เรียงจากใหม่ไปเก่า
  List<FoodOrder> get orders => List<FoodOrder>.unmodifiable(_orders);

  bool get isEmpty => _orders.isEmpty;

  void add(FoodOrder order) {
    _orders.insert(0, order);
    notifyListeners();
  }
}

/// รายการออเดอร์ใบเดียวของแอป — ทุกจออ้างถึงตัวนี้
final MyOrdersStore myOrders = MyOrdersStore();
