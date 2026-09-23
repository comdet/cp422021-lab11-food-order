// ============================================================================
// shop_info.dart — ข้อมูลของร้านที่แสดงบนหัวหน้าแรก
//
// ข้อมูลชุดนี้ไม่ได้อยู่ในฐานข้อมูล เพราะแอปนี้เป็นแอปของร้านเดียว
// ร้านจึงเป็นค่าคงที่ของแอป ไม่ใช่ข้อมูลที่เปลี่ยนไปมาเหมือนรายการเมนู
//
// ── ส่วนที่ให้มาแล้ว (ไม่ต้องแก้ในแล็บนี้) ──────────────────────────────────
//   - ShopInfo.demo   ข้อมูลร้านตัวอย่าง
//
// ไฟล์นี้ไม่มีจุดที่ต้องเติม — แต่แก้ชื่อร้านกับภาพหัวร้านให้เป็นของตัวเองได้
// ============================================================================

class ShopInfo {
  const ShopInfo({
    required this.name,
    required this.tagline,
    required this.heroImage,
    required this.rating,
    required this.ratingCount,
    required this.deliveryMinutes,
    required this.isOpen,
  });

  /// ชื่อร้านที่แสดงบนหัวหน้าแรก
  final String name;

  /// คำอธิบายสั้นใต้ชื่อร้าน
  final String tagline;

  /// ภาพหัวร้าน ใช้ไฟล์ในโฟลเดอร์ assets
  final String heroImage;

  final double rating;
  final int ratingCount;
  final int deliveryMinutes;
  final bool isOpen;

  static const ShopInfo demo = ShopInfo(
    name: 'ครัวริมคลอง',
    tagline: 'อาหารตามสั่ง ส่งถึงหอ',
    heroImage: 'assets/images/pad-thai.jpg',
    rating: 4.6,
    ratingCount: 218,
    deliveryMinutes: 25,
    isOpen: true,
  );
}
