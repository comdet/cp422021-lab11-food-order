// ============================================================================
// restaurant.dart — รูปข้อมูลของร้านหนึ่งร้านในแอปส่งอาหาร
//
// แอปนี้เป็นแอปส่งอาหาร ไม่ใช่แอปของร้านใดร้านหนึ่ง หน้าแรกจึงไล่รายชื่อร้าน
// ที่รับส่งในพื้นที่ แล้วผู้ใช้เลือกร้านก่อนจึงจะเห็นเมนูของร้านนั้น
//
// ── ส่วนที่ให้มาแล้ว (ไม่ต้องแก้) ────────────────────────────────────────────
//   - ฟิลด์ทั้งหมดของร้าน และ Restaurant.fromMap()
//
// ไฟล์นี้ไม่มีจุดที่ต้องเติม
// ============================================================================

class Restaurant {
  const Restaurant({
    required this.id,
    required this.name,
    required this.foodTypes,
    required this.rating,
    required this.ratingCount,
    required this.deliveryMinutes,
    required this.distanceKm,
    required this.area,
    required this.imagePath,
    this.isOpen = true,
    this.freeDelivery = false,
  });

  final String id;
  final String name;

  /// ประเภทอาหารของร้าน เช่น ตามสั่ง · ก๋วยเตี๋ยว · ปิ้งย่าง
  final List<String> foodTypes;

  final double rating;
  final int ratingCount;

  /// เวลาส่งโดยประมาณ หน่วยเป็นนาที
  final int deliveryMinutes;

  /// ระยะทางจากที่อยู่ปลายทาง หน่วยเป็นกิโลเมตร
  final double distanceKm;

  /// อำเภอหรือย่านของร้าน
  final String area;

  final String imagePath;

  final bool isOpen;
  final bool freeDelivery;

  factory Restaurant.fromMap(String id, Map<String, dynamic> data) {
    return Restaurant(
      id: id,
      name: (data['name'] as String?) ?? '',
      foodTypes:
          (data['foodTypes'] as List<dynamic>?)
              ?.map((dynamic e) => '$e')
              .toList() ??
          const <String>[],
      rating: (data['rating'] as num?)?.toDouble() ?? 0,
      ratingCount: (data['ratingCount'] as num?)?.toInt() ?? 0,
      deliveryMinutes: (data['deliveryMinutes'] as num?)?.toInt() ?? 0,
      distanceKm: (data['distanceKm'] as num?)?.toDouble() ?? 0,
      area: (data['area'] as String?) ?? '',
      imagePath: (data['imagePath'] as String?) ?? '',
      isOpen: (data['isOpen'] as bool?) ?? true,
      freeDelivery: (data['freeDelivery'] as bool?) ?? false,
    );
  }
}
