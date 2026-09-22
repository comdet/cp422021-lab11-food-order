// ============================================================================
// demo_menu.dart — รายการเมนูตัวอย่างที่เขียนค้างไว้ในโค้ด
//
// ★ ไฟล์นี้คือแหล่งข้อมูลชั่วคราวของแอป มีไว้เพื่อให้โครงนี้รันขึ้นและเห็นหน้าจอ
//   ทำงานได้ตั้งแต่ก่อนต่อฐานข้อมูล
//
// เมื่อคุณทำงานข้อ ① เสร็จ จอเมนูจะไม่ได้ข้อมูลจากไฟล์นี้อีกต่อไป
// วิธีพิสูจน์ว่างานข้อ ① ผ่านจริงคือ แก้ชื่อหรือราคาของเมนูหนึ่งรายการในหน้าคอนโซล
// ของ Firebase แล้วจอต้องเปลี่ยนตาม ไม่ใช่เปลี่ยนตามไฟล์นี้
//
// ── ส่วนที่ให้มาแล้ว (ไม่ต้องแก้) ────────────────────────────────────────────
//   - demoMenu   รายการเมนูตัวอย่าง 8 รายการ พร้อมภาพในโฟลเดอร์ assets/images
//
// ไฟล์นี้ไม่มีจุดที่ต้องเติม — และไม่ต้องลบไฟล์นี้ทิ้งเมื่อทำงานข้อ ① เสร็จ
// เก็บไว้เทียบได้ว่าข้อมูลที่ขึ้นจอมาจากฐานข้อมูลจริงหรือยังมาจากโค้ด
// ============================================================================
import '../models/menu_item.dart';

const List<MenuItem> demoMenu = <MenuItem>[
  MenuItem(
    id: 'pad-thai',
    name: 'ผัดไทยกุ้งสด',
    price: 65,
    imagePath: 'assets/images/pad-thai.jpg',
  ),
  MenuItem(
    id: 'pad-kraprao',
    name: 'ข้าวกะเพราหมูสับไข่ดาว',
    price: 60,
    imagePath: 'assets/images/pad-kraprao.jpg',
  ),
  MenuItem(
    id: 'green-curry',
    name: 'แกงเขียวหวานไก่',
    price: 75,
    imagePath: 'assets/images/green-curry.jpg',
  ),
  MenuItem(
    id: 'tom-yum',
    name: 'ต้มยำกุ้งน้ำข้น',
    price: 140,
    imagePath: 'assets/images/tom-yum.jpg',
  ),
  MenuItem(
    id: 'crab-fried-rice',
    name: 'ข้าวผัดปู',
    price: 160,
    imagePath: 'assets/images/crab-fried-rice.jpg',
  ),
  MenuItem(
    id: 'garlic-chicken',
    name: 'ไก่ผัดกระเทียมพริกไทย',
    price: 65,
    imagePath: 'assets/images/garlic-chicken.jpg',
  ),
  MenuItem(
    id: 'thai-tea',
    name: 'ชาไทยเย็น',
    price: 35,
    imagePath: 'assets/images/thai-tea.jpg',
  ),
  MenuItem(
    id: 'mango-sticky-rice',
    name: 'ข้าวเหนียวมะม่วง',
    price: 85,
    imagePath: 'assets/images/mango-sticky-rice.jpg',
  ),
];
