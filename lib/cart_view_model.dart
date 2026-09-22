// ============================================================================
// cart_view_model.dart — ตะกร้าของลูกค้า
//
// ตะกร้าถูกเก็บไว้นอกหน้าจอโดยตั้งใจ เพราะระบบปฏิบัติการสร้างหน้าจอขึ้นใหม่ได้เอง
// เมื่อผู้ใช้หมุนจอหรือสลับไปใช้แอปอื่น ข้อมูลที่เก็บไว้ในหน้าจอจะหายไปด้วย
//
// คลาสนี้สืบทอดจาก ChangeNotifier ซึ่งอยู่ใน package:flutter/foundation.dart
// จึงไม่ต้องติดตั้งแพ็กเกจเพิ่ม · จอที่ต้องการวาดใหม่เมื่อตะกร้าเปลี่ยนจะใช้
// ListenableBuilder ฟังการแจ้งเตือนจากคลาสนี้
//
// ── ส่วนที่ให้มาแล้ว (ไม่ต้องแก้) ────────────────────────────────────────────
//   - addOne() · removeOne() · clear()   แก้ของในตะกร้า
//   - totalQuantity · totalPrice         จำนวนรวมและยอดรวม
//   - buildOrder()                       รวบรวมของในตะกร้าเป็นออเดอร์หนึ่งใบ
//
// ไฟล์นี้ไม่มีจุดที่ต้องเติม
// ============================================================================
import 'package:flutter/foundation.dart';

import 'models/food_order.dart';
import 'models/menu_item.dart';

class CartViewModel extends ChangeNotifier {
  final List<OrderLine> _lines = <OrderLine>[];

  /// รายการในตะกร้า — คืนเป็นรายการที่แก้จากภายนอกไม่ได้
  /// การเปลี่ยนของในตะกร้าต้องผ่านฟังก์ชันของคลาสนี้เท่านั้น
  List<OrderLine> get lines => List<OrderLine>.unmodifiable(_lines);

  bool get isEmpty => _lines.isEmpty;

  /// จำนวนชิ้นรวมทุกรายการ ใช้แสดงบนปุ่มตะกร้า
  int get totalQuantity {
    return _lines.fold<int>(
      0,
      (int sum, OrderLine line) => sum + line.quantity,
    );
  }

  /// ยอดรวมเป็นบาท
  int get totalPrice {
    return _lines.fold<int>(
      0,
      (int sum, OrderLine line) => sum + line.lineTotal,
    );
  }

  /// เพิ่มเมนูหนึ่งรายการเข้าตะกร้า ถ้ามีรายการนั้นอยู่แล้วให้เพิ่มจำนวนแทน
  void addOne(MenuItem item) {
    final int index = _lines.indexWhere(
      (OrderLine line) => line.item.id == item.id,
    );
    if (index < 0) {
      _lines.add(OrderLine(item: item, quantity: 1));
    } else {
      _lines[index] = _lines[index].copyWithQuantity(
        _lines[index].quantity + 1,
      );
    }
    // ถ้าไม่เรียกบรรทัดนี้ จอที่ฟังอยู่จะไม่วาดใหม่
    notifyListeners();
  }

  /// ลดจำนวนของเมนูรายการหนึ่งลงหนึ่งชิ้น ถ้าเหลือศูนย์ให้เอาออกจากตะกร้า
  void removeOne(MenuItem item) {
    final int index = _lines.indexWhere(
      (OrderLine line) => line.item.id == item.id,
    );
    if (index < 0) {
      return;
    }
    final int nextQuantity = _lines[index].quantity - 1;
    if (nextQuantity < 1) {
      _lines.removeAt(index);
    } else {
      _lines[index] = _lines[index].copyWithQuantity(nextQuantity);
    }
    notifyListeners();
  }

  /// ล้างตะกร้า เรียกหลังส่งออเดอร์สำเร็จ
  void clear() {
    _lines.clear();
    notifyListeners();
  }

  /// รวบรวมของในตะกร้าเป็นออเดอร์หนึ่งใบเพื่อส่งให้ order_repository
  FoodOrder buildOrder() {
    return FoodOrder(
      lines: lines,
      total: totalPrice,
      createdAt: DateTime.now(),
    );
  }
}

/// ตะกร้าใบเดียวของแอป — ทุกจออ้างถึงตัวนี้
/// แอปนี้มีลูกค้าคนเดียวต่อเครื่อง จึงเก็บไว้เป็นตัวแปรระดับไฟล์
final CartViewModel cart = CartViewModel();
