// ============================================================================
// login_screen.dart — จอสมัครบัญชีและเข้าสู่ระบบ   ★ มีจุดที่ต้องเติม (งานข้อ ③)
//
// จอนี้เรียกใช้ฟังก์ชันใน lib/auth_service.dart เท่านั้น และไม่เรียกบริการ
// ยืนยันตัวตนตรง ๆ
//
// ตอนนี้จอนี้ยังว่าง **งานข้อ ③ คือสร้างจอนี้ให้เหมือนภาพเทียบ**
// reference-shots/login-phone.png แล้วต่อปุ่มเข้ากับสามฟังก์ชันที่ให้ไว้แล้ว
//
// ── ส่วนที่ให้มาแล้ว (ไม่ต้องเขียนเอง) ─────────────────────────────────────
//   - _formKey · _emailController · _passwordController   ตัวควบคุมฟอร์ม
//   - _busy · _message · _messageIsError                  สถานะที่จอต้องแสดง
//   - _signIn() · _register() · _signOut()                สามงานที่ปุ่มต้องเรียก
//     ทั้งสามตรวจฟอร์มให้เอง แล้วตั้งค่า _busy กับ _message ให้เอง
//
// ── สิ่งที่ภาพเทียบมี เรียงจากบนลงล่าง ──────────────────────────────────────
//   1. แถบหัวจอชื่อ "เข้าสู่ระบบ"                              ← ต้องเติม
//   2. หัวจอ: ไอคอนในกรอบมน · หัวข้อ · คำอธิบายหนึ่งบรรทัด      ← ต้องเติม
//   3. ช่องอีเมล และช่องรหัสผ่านที่ปิดบังตัวอักษร                ← ต้องเติม
//   4. ปุ่มหลัก "เข้าสู่ระบบ" · ปุ่มรอง "สมัครบัญชีใหม่" ·
//      ปุ่มข้อความ "ออกจากระบบ"                                ← ต้องเติม
//   5. วงกลมหมุนตอนกำลังทำงาน และกล่องข้อความผลลัพธ์
//      เขียวเมื่อสำเร็จ แดงเมื่อผิดพลาด                          ← ต้องเติม
//   6. หมายเหตุท้ายจอเรื่องห้ามใช้รหัสผ่านจริง                   ← ต้องเติม
//
// ★ ข้อกำหนดที่ต้องผ่าน
//   - ต้องตรวจฟอร์มก่อนส่ง: อีเมลว่างไม่ได้และต้องมีเครื่องหมาย @ · รหัสผ่านว่างไม่ได้
//   - สีและรูปแบบตัวอักษรต้องมาจาก theme.dart ห้ามใส่ค่าสีดิบลงในจอนี้
//   - ระหว่างกำลังทำงาน (_busy) ปุ่มทุกปุ่มต้องกดไม่ได้
// ============================================================================
import 'package:flutter/material.dart';

import '../auth_service.dart';
import '../theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  /// จริงระหว่างที่กำลังรอผลจาก auth_service — จอที่คุณสร้างต้องอ่านค่านี้
  // ignore: unused_field
  bool _busy = false;

  /// ข้อความที่แสดงใต้ปุ่ม — ข้อความจริงที่ auth_service ส่งกลับมา
  // ignore: unused_field
  String? _message;
  // ignore: unused_field
  bool _messageIsError = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// เรียกงานหนึ่งอย่างของ auth_service แล้วแสดงผลที่ได้
  Future<void> _run(
    Future<void> Function() action,
    String successMessage,
  ) async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    setState(() {
      _busy = true;
      _message = null;
    });
    try {
      await action();
      if (!mounted) {
        return;
      }
      setState(() {
        _message = successMessage;
        _messageIsError = false;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _message = '$error';
        _messageIsError = true;
      });
    } finally {
      if (mounted) {
        setState(() {
          _busy = false;
        });
      }
    }
  }

  // ignore: unused_element
  Future<void> _register() {
    return _run(
      () => AuthService.instance.registerWithEmail(
        _emailController.text.trim(),
        _passwordController.text,
      ),
      'สมัครบัญชีเรียบร้อย และเข้าสู่ระบบแล้ว',
    );
  }

  // ignore: unused_element
  Future<void> _signIn() {
    return _run(
      () => AuthService.instance.signInWithEmail(
        _emailController.text.trim(),
        _passwordController.text,
      ),
      'เข้าสู่ระบบเรียบร้อย',
    );
  }

  // ignore: unused_element
  Future<void> _signOut() async {
    setState(() {
      _busy = true;
      _message = null;
    });
    try {
      await AuthService.instance.signOut();
      if (!mounted) {
        return;
      }
      setState(() {
        _message = 'ออกจากระบบแล้ว';
        _messageIsError = false;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _message = '$error';
        _messageIsError = true;
      });
    } finally {
      if (mounted) {
        setState(() {
          _busy = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // ── ★ จุดที่ต้องเติม (งานข้อ ③) — สร้างจอเข้าสู่ระบบให้เหมือนภาพเทียบ ─────
    // ต้องทำ: แทนที่ทั้งฟังก์ชันนี้ด้วยจอจริง ให้ครบหกข้อตามที่เขียนไว้ในหัวไฟล์
    //   และหน้าตาตรงกับ reference-shots/login-phone.png
    //
    //   ปุ่มทั้งสามต้องเรียก _signIn() · _register() · _signOut() ที่ให้ไว้แล้ว
    //   ช่องกรอกต้องผูกกับ _emailController และ _passwordController
    //   ฟอร์มต้องครอบด้วย Form ที่ใช้ _formKey ไม่งั้นการตรวจฟอร์มจะไม่ทำงาน
    //
    //   คำใบ้เรื่องการวาง: เนื้อหายาวกว่าจอเมื่อแป้นพิมพ์ขึ้น จึงควรอยู่ในสิ่งที่เลื่อนได้
    return Scaffold(
      appBar: AppBar(title: const Text('เข้าสู่ระบบ')),
      body: _todoPanel(),
    );
  }

  /// แผงชั่วคราวที่บอกว่าจอนี้ยังไม่ได้ทำ — ลบทิ้งเมื่อทำงานข้อ ③ เสร็จ
  Widget _todoPanel() {
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
              decoration: const BoxDecoration(
                color: AppColors.brandSoft,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.lock_outline,
                size: 44,
                color: AppColors.brand,
              ),
            ),
            const SizedBox(height: AppSpace.lg),
            Text('จอเข้าสู่ระบบยังว่างอยู่', style: textTheme.titleLarge),
            const SizedBox(height: AppSpace.sm),
            Text(
              'งานข้อ ③ ของแล็บคือสร้างจอนี้ให้เหมือนภาพเทียบ '
              'แล้วต่อปุ่มเข้ากับสามฟังก์ชันที่ให้ไว้แล้วในไฟล์นี้ '
              'อ่านรายละเอียดที่หัวไฟล์ lib/screens/login_screen.dart',
              textAlign: TextAlign.center,
              style: textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
