// ============================================================================
// food_order.dart — รูปข้อมูลของออเดอร์หนึ่งใบ และของรายการหนึ่งบรรทัดในออเดอร์
//
// ไฟล์นี้อยู่ในชั้น model เช่นเดียวกับ menu_item.dart
//
// ── ส่วนที่ให้มาแล้ว (ไม่ต้องแก้) ────────────────────────────────────────────
//   - OrderLine   หนึ่งบรรทัดในออเดอร์ = เมนูหนึ่งรายการ + จำนวน
//   - FoodOrder   ออเดอร์หนึ่งใบ = รายการทั้งหมด + ยอดรวม + เวลาที่สร้าง
//   - toMap()     แปลงออเดอร์เป็นรูป Map เพื่อส่งต่อให้ชั้นที่เขียนฐานข้อมูล
//
// ไฟล์นี้ไม่มีจุดที่ต้องเติม แต่ค่าที่ toMap() คืนออกมาเป็นเพียงจุดตั้งต้น
// งานข้อ ③ ของแล็บกำหนดให้คุณเป็นผู้ตัดสินเองว่าเอกสารออเดอร์ควรมีฟิลด์ใดบ้าง
// ถ้าคุณตัดสินว่าต้องมีฟิลด์อื่นเพิ่ม ให้แก้ toMap() ตามการตัดสินใจของคุณ
// ============================================================================
import 'menu_item.dart';

/// หนึ่งบรรทัดในออเดอร์ — เมนูหนึ่งรายการพร้อมจำนวนที่สั่ง
class OrderLine {
  const OrderLine({required this.item, required this.quantity});

  final MenuItem item;
  final int quantity;

  /// ราคารวมของบรรทัดนี้ = ราคาต่อรายการ คูณ จำนวน
  int get lineTotal => item.price * quantity;

  /// คืนบรรทัดใหม่ที่เปลี่ยนเฉพาะจำนวน โดยไม่แก้ค่าในบรรทัดเดิม
  OrderLine copyWithQuantity(int newQuantity) {
    return OrderLine(item: item, quantity: newQuantity);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'menuId': item.id,
      'name': item.name,
      'price': item.price,
      'quantity': quantity,
    };
  }
}

/// ออเดอร์หนึ่งใบที่พร้อมส่งออกจากแอป
class FoodOrder {
  const FoodOrder({
    required this.lines,
    required this.total,
    required this.createdAt,
  });

  final List<OrderLine> lines;

  /// ยอดรวมของทั้งออเดอร์ เป็นบาท
  final int total;

  /// เวลาที่ผู้ใช้กดสั่ง
  final DateTime createdAt;

  /// แปลงออเดอร์เป็นรูป Map
  ///
  /// ค่า createdAt ที่ใส่ลงไปยังเป็นค่าเวลาของภาษา Dart
  /// ผู้ทำงานข้อ ③ เป็นผู้ตัดสินว่าจะเก็บเวลาลงฐานข้อมูลในรูปแบบใด
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'items': lines.map((OrderLine line) => line.toMap()).toList(),
      'total': total,
      'createdAt': createdAt,
    };
  }
}
