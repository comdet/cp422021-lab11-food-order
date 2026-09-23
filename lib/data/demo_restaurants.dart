// ============================================================================
// demo_restaurants.dart — รายชื่อร้านที่แสดงบนหน้าแรกของแอปส่งอาหาร
//
// ★ รายชื่อร้านชุดนี้เขียนค้างไว้ในโค้ด และ **ไม่ใช่งานของแล็บนี้**
//   งานของคุณคือเมนูของร้าน ไม่ใช่รายชื่อร้าน · การย้ายรายชื่อร้านขึ้นฐานข้อมูล
//   เป็นเรื่องของสัปดาห์ถัดไปเมื่อเพิ่มบทบาทคนส่งอาหารเข้ามา
//
// ── ส่วนที่ให้มาแล้ว (ไม่ต้องแก้) ────────────────────────────────────────────
//   - demoRestaurants   รายชื่อร้าน 8 ร้าน
//
// ไฟล์นี้ไม่มีจุดที่ต้องเติม
// ============================================================================
import '../models/restaurant.dart';

/// รหัสของร้านที่ผู้ใช้เคยสั่ง เรียงจากที่สั่งล่าสุด
///
/// ★ ในแล็บนี้เป็นข้อมูลตัวอย่างที่เขียนค้างไว้ในโค้ด
///   การอ่านประวัติการสั่งจริงจากฐานข้อมูลเป็นเรื่องของสัปดาห์ถัดไป
const List<String> recentRestaurantIds = <String>[
  'phat-thai-jao-dang',
  'kuay-teow-mu-tun',
  'ping-yang-korat',
];

const List<Restaurant> demoRestaurants = <Restaurant>[
  Restaurant(
    id: 'ban-khao-kaeng',
    name: 'ร้านอาหารบ้านข้าวแกง',
    foodTypes: <String>['ตามสั่ง', 'ข้าวแกง'],
    rating: 4.5,
    ratingCount: 312,
    deliveryMinutes: 30,
    distanceKm: 2.4,
    area: 'เมืองขอนแก่น',
    imagePath: 'assets/images/pad-kraprao.jpg',
    freeDelivery: true,
  ),
  Restaurant(
    id: 'krua-jan-duan',
    name: 'ครัวจานด่วน',
    foodTypes: <String>['ตามสั่ง'],
    rating: 4.3,
    ratingCount: 188,
    deliveryMinutes: 25,
    distanceKm: 1.8,
    area: 'บ้านไผ่',
    imagePath: 'assets/images/pad-thai.jpg',
  ),
  Restaurant(
    id: 'ping-yang-korat',
    name: 'ปิ้งย่างโคราช',
    foodTypes: <String>['ปิ้งย่าง', 'อีสาน'],
    rating: 4.6,
    ratingCount: 421,
    deliveryMinutes: 35,
    distanceKm: 3.6,
    area: 'ชุมแพ',
    imagePath: 'assets/images/garlic-chicken.jpg',
  ),
  Restaurant(
    id: 'kuay-teow-mu-tun',
    name: 'ก๋วยเตี๋ยวหมูตุ๋น',
    foodTypes: <String>['ก๋วยเตี๋ยว'],
    rating: 4.2,
    ratingCount: 96,
    deliveryMinutes: 20,
    distanceKm: 1.2,
    area: 'หนองเรือ',
    imagePath: 'assets/images/tom-yum.jpg',
    freeDelivery: true,
  ),
  Restaurant(
    id: 'kaeng-keaw-wan',
    name: 'ครัวแกงไทยเจ้าเก่า',
    foodTypes: <String>['แกง', 'ตามสั่ง'],
    rating: 4.4,
    ratingCount: 143,
    deliveryMinutes: 30,
    distanceKm: 2.9,
    area: 'กระนวน',
    imagePath: 'assets/images/green-curry.jpg',
  ),
  Restaurant(
    id: 'phat-thai-jao-dang',
    name: 'ผัดไทยเจ้าดัง',
    foodTypes: <String>['ผัดไทย', 'เส้น'],
    rating: 4.7,
    ratingCount: 507,
    deliveryMinutes: 20,
    distanceKm: 0.9,
    area: 'น้ำพอง',
    imagePath: 'assets/images/crab-fried-rice.jpg',
    freeDelivery: true,
  ),
  Restaurant(
    id: 'cha-thai-yen',
    name: 'ชานมหน้ามอ',
    foodTypes: <String>['เครื่องดื่ม', 'ของหวาน'],
    rating: 4.8,
    ratingCount: 733,
    deliveryMinutes: 15,
    distanceKm: 0.6,
    area: 'เมืองขอนแก่น',
    imagePath: 'assets/images/thai-tea.jpg',
  ),
  Restaurant(
    id: 'khao-niao-mamuang',
    name: 'ของหวานป้าน้อย',
    foodTypes: <String>['ของหวาน'],
    rating: 4.1,
    ratingCount: 64,
    deliveryMinutes: 25,
    distanceKm: 2.1,
    area: 'เปือยน้อย',
    imagePath: 'assets/images/mango-sticky-rice.jpg',
    isOpen: false,
  ),
];
