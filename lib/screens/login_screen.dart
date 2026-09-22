// ============================================================================
// login_screen.dart — จอสมัครบัญชีและเข้าสู่ระบบด้วยอีเมลและรหัสผ่าน
//
// จอนี้เรียกใช้ฟังก์ชันใน lib/auth_service.dart เท่านั้น และไม่เรียกบริการ
// ยืนยันตัวตนตรง ๆ · เมื่อคุณทำงานข้อ ② เสร็จ จอนี้จะทำงานได้โดยไม่ต้องแก้
//
// ── ส่วนที่ให้มาแล้ว (ไม่ต้องแก้ในแล็บนี้) ──────────────────────────────────
//   - ช่องกรอกอีเมลและรหัสผ่าน พร้อมการตรวจว่ากรอกครบ
//   - ปุ่มสมัครบัญชีใหม่ · ปุ่มเข้าสู่ระบบ · ปุ่มออกจากระบบ
//   - การแสดงข้อความที่ auth_service โยนออกมา ทั้งกรณีสำเร็จและไม่สำเร็จ
//
// ไฟล์นี้ไม่มีจุดที่ต้องเติม
//
// ★ ก่อนทำงานข้อ ② เสร็จ ทุกปุ่มบนจอนี้จะขึ้นข้อความว่ายังทำงานข้อ ② ไม่เสร็จ
//   อาการนี้ถูกต้อง ไม่ใช่ข้อผิดพลาดของโครง
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

  /// จริงระหว่างที่กำลังรอผลจาก auth_service
  bool _busy = false;

  /// ข้อความที่แสดงใต้ปุ่ม — ข้อความจริงที่ auth_service ส่งกลับมา
  String? _message;
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

  Future<void> _register() {
    return _run(
      () => AuthService.instance.registerWithEmail(
        _emailController.text.trim(),
        _passwordController.text,
      ),
      'สมัครบัญชีเรียบร้อย และเข้าสู่ระบบแล้ว',
    );
  }

  Future<void> _signIn() {
    return _run(
      () => AuthService.instance.signInWithEmail(
        _emailController.text.trim(),
        _passwordController.text,
      ),
      'เข้าสู่ระบบเรียบร้อย',
    );
  }

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

  /// หัวจอ — บอกว่าจอนี้ทำอะไร และทำให้ครึ่งบนของจอไม่ว่างเปล่า
  Widget _header() {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: AppColors.brandSoft,
            borderRadius: BorderRadius.circular(AppSpace.radiusCard),
          ),
          child: const Icon(
            Icons.ramen_dining,
            size: 34,
            color: AppColors.brand,
          ),
        ),
        const SizedBox(height: AppSpace.lg),
        Text('เข้าสู่ระบบเพื่อสั่งอาหาร', style: textTheme.headlineSmall),
        const SizedBox(height: AppSpace.sm),
        Text(
          'ออเดอร์ที่สั่งจะถูกบันทึกไว้กับบัญชีนี้ ยังไม่มีบัญชีให้กดสมัครบัญชีใหม่ได้เลย',
          style: textTheme.bodySmall,
        ),
      ],
    );
  }

  /// กล่องข้อความผลลัพธ์ — สีเขียวเมื่อสำเร็จ สีแดงเมื่อผิดพลาด
  Widget _messageBox(String message) {
    final Color tone = _messageIsError ? AppColors.danger : AppColors.success;
    return Container(
      padding: const EdgeInsets.all(AppSpace.md),
      decoration: BoxDecoration(
        color: tone.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppSpace.radiusControl),
        border: Border.all(color: tone.withValues(alpha: 0.35)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(
            _messageIsError ? Icons.error_outline : Icons.check_circle_outline,
            size: 20,
            color: tone,
          ),
          const SizedBox(width: AppSpace.sm),
          Expanded(
            child: Text(
              message,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: tone),
            ),
          ),
        ],
      ),
    );
  }

  /// คำเตือนเรื่องรหัสผ่าน — อยู่ท้ายจอเพราะเป็นข้อมูลประกอบ ไม่ใช่ขั้นตอน
  Widget _note() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Icon(Icons.info_outline, size: 18, color: AppColors.textMuted),
        const SizedBox(width: AppSpace.sm),
        Expanded(
          child: Text(
            'บัญชีที่สมัครในแล็บนี้เป็นบัญชีทดสอบ อย่าใช้รหัสผ่านจริงที่ใช้ที่อื่น',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('เข้าสู่ระบบ')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          AppSpace.xl,
          AppSpace.xl,
          AppSpace.xl,
          AppSpace.xl,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              _header(),
              const SizedBox(height: AppSpace.xl),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'อีเมล',
                  border: OutlineInputBorder(),
                ),
                validator: (String? value) {
                  final String text = (value ?? '').trim();
                  if (text.isEmpty) {
                    return 'กรอกอีเมล';
                  }
                  if (!text.contains('@')) {
                    return 'อีเมลต้องมีเครื่องหมาย @';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppSpace.md),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'รหัสผ่าน',
                  border: OutlineInputBorder(),
                ),
                validator: (String? value) {
                  if ((value ?? '').isEmpty) {
                    return 'กรอกรหัสผ่าน';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppSpace.xl),
              FilledButton(
                onPressed: _busy ? null : _signIn,
                child: const Text('เข้าสู่ระบบ'),
              ),
              const SizedBox(height: AppSpace.md),
              OutlinedButton(
                onPressed: _busy ? null : _register,
                child: const Text('สมัครบัญชีใหม่'),
              ),
              const SizedBox(height: AppSpace.sm),
              TextButton(
                onPressed: _busy ? null : _signOut,
                child: const Text('ออกจากระบบ'),
              ),
              if (_busy) ...<Widget>[
                const SizedBox(height: AppSpace.lg),
                const Center(child: CircularProgressIndicator()),
              ],
              if (_message != null) ...<Widget>[
                const SizedBox(height: AppSpace.lg),
                _messageBox(_message!),
              ],
              const SizedBox(height: AppSpace.xl),
              _note(),
            ],
          ),
        ),
      ),
    );
  }
}
