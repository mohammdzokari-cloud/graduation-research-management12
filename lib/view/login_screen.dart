import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constants/app_constants.dart';

// ============================================================
// [تعليق مؤقت] عند تفعيل Supabase، أضف هذا الاستيراد:
// import 'package:supabase_flutter/supabase_flutter.dart';
// ============================================================

/// واجهة تسجيل الدخول — رئيس القسم
/// ─────────────────────────────────────────────────────────────
/// بيانات الدخول الوهمية الحالية (مؤقتة):
///   اسم المستخدم : head
///   كلمة المرور  : 12345
/// ─────────────────────────────────────────────────────────────
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // ── Controllers ──────────────────────────────────────────────
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // ── State ─────────────────────────────────────────────────────
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // ════════════════════════════════════════════════════════════
  //  دالة تسجيل الدخول
  // ════════════════════════════════════════════════════════════
  Future<void> _login() async {
    // التحقق من صحة النموذج
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // ──────────────────────────────────────────────────────────
      // [تعليق مؤقت] كود Supabase Auth — فعّله لاحقاً وأزل
      // كود البيانات الوهمية تحته عند التفعيل
      //
      // final response = await Supabase.instance.client.auth.signInWithPassword(
      //   email: _usernameController.text.trim(),
      //   password: _passwordController.text,
      // );
      //
      // if (response.user == null) {
      //   throw Exception('اسم المستخدم أو كلمة المرور غير صحيحة');
      // }
      //
      // // جلب بيانات المستخدم من جدول profiles أو department_heads
      // final userData = await Supabase.instance.client
      //     .from('department_heads')
      //     .select()
      //     .eq('user_id', response.user!.id)
      //     .single();
      //
      // Get.offAllNamed('/department_head/dashboard',
      //     arguments: {'departmentId': userData['department_id']});
      // ──────────────────────────────────────────────────────────

      // ── بيانات وهمية مؤقتة ────────────────────────────────────
      // اسم المستخدم: head  |  كلمة المرور: 12345
      await Future.delayed(const Duration(milliseconds: 800)); // محاكاة تأخير الشبكة

      final username = _usernameController.text.trim();
      final password = _passwordController.text;

      if (username == 'head' && password == '12345') {
        // نجاح تسجيل الدخول — الانتقال للصفحة الرئيسية
        Get.offAllNamed(
          '/department_head/dashboard',
          arguments: {'departmentId': 'dept001'},
        );
      } else {
        // بيانات خاطئة
        _showErrorSnackbar('اسم المستخدم أو كلمة المرور غير صحيحة');
      }
      // ──────────────────────────────────────────────────────────
    } catch (e) {
      _showErrorSnackbar('حدث خطأ أثناء تسجيل الدخول: ${e.toString()}');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showErrorSnackbar(String message) {
    Get.snackbar(
      'خطأ',
      message,
      backgroundColor: AppConstants.errorColor,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.all(16),
      borderRadius: AppConstants.borderRadiusMedium,
      icon: const Icon(Icons.error_outline, color: Colors.white),
      duration: const Duration(seconds: 3),
    );
  }

  // ════════════════════════════════════════════════════════════
  //  البناء
  // ════════════════════════════════════════════════════════════
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEEEEF8),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.paddingLarge,
              vertical: AppConstants.paddingExtraLarge,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // ── بطاقة تسجيل الدخول ────────────────────────
                _buildLoginCard(),
                const SizedBox(height: AppConstants.paddingLarge),

                // ── نص الدعم الفني ─────────────────────────────
                _buildSupportText(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── بطاقة تسجيل الدخول ──────────────────────────────────────
  Widget _buildLoginCard() {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 420),
      padding: const EdgeInsets.all(AppConstants.paddingExtraLarge),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge * 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(18),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── الشعار ─────────────────────────────────────────
            _buildLogo(),
            const SizedBox(height: AppConstants.paddingLarge),

            // ── العنوان الرئيسي ─────────────────────────────────
            _buildTitle(),
            const SizedBox(height: AppConstants.paddingExtraLarge),

            // ── حقل اسم المستخدم ────────────────────────────────
            _buildUsernameField(),
            const SizedBox(height: AppConstants.paddingMedium),

            // ── حقل كلمة المرور ─────────────────────────────────
            _buildPasswordField(),
            const SizedBox(height: AppConstants.paddingExtraLarge),

            // ── زر تسجيل الدخول ─────────────────────────────────
            _buildLoginButton(),
          ],
        ),
      ),
    );
  }

  // ── الشعار ──────────────────────────────────────────────────
  Widget _buildLogo() {
    return Container(
      width: 110,
      height: 110,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: AppConstants.primaryColor.withAlpha(40),
            blurRadius: 16,
            spreadRadius: 2,
          ),
        ],
      ),
      child: ClipOval(
        child: Image.asset(
          'assets/images/university_logo.png',
          fit: BoxFit.contain,
          // إذا تعذّر تحميل الشعار، اعرض أيقونة بديلة
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: AppConstants.primaryColor.withAlpha(20),
              child: const Icon(
                Icons.school,
                size: 60,
                color: AppConstants.primaryColor,
              ),
            );
          },
        ),
      ),
    );
  }

  // ── العنوان ──────────────────────────────────────────────────
  Widget _buildTitle() {
    return Column(
      children: [
        const Text(
          'نظام إدارة بحوث التخرج',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppConstants.secondaryColor,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'تسجيل الدخول إلى حسابك',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  // ── حقل اسم المستخدم ────────────────────────────────────────
  Widget _buildUsernameField() {
    return TextFormField(
      controller: _usernameController,
      textDirection: TextDirection.rtl,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        labelText: 'أدخل اسم المستخدم',
        hintText: 'أدخل اسم المستخدم',
        suffixIcon: const Icon(
          Icons.person,
          color: AppConstants.primaryColor,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
          borderSide: const BorderSide(
            color: AppConstants.primaryColor,
            width: 2,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppConstants.paddingMedium,
          vertical: AppConstants.paddingMedium,
        ),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'يرجى إدخال اسم المستخدم';
        }
        return null;
      },
    );
  }

  // ── حقل كلمة المرور ─────────────────────────────────────────
  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      textDirection: TextDirection.rtl,
      obscureText: !_isPasswordVisible,
      textInputAction: TextInputAction.done,
      onFieldSubmitted: (_) => _login(),
      decoration: InputDecoration(
        labelText: 'أدخل كلمة المرور',
        hintText: 'أدخل كلمة المرور',
        suffixIcon: GestureDetector(
          onTap: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
          child: Icon(
            _isPasswordVisible ? Icons.lock_open : Icons.lock,
            color: AppConstants.primaryColor,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
          borderSide: const BorderSide(
            color: AppConstants.primaryColor,
            width: 2,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppConstants.paddingMedium,
          vertical: AppConstants.paddingMedium,
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'يرجى إدخال كلمة المرور';
        }
        if (value.length < 5) {
          return 'كلمة المرور يجب أن تكون 5 أحرف على الأقل';
        }
        return null;
      },
    );
  }

  // ── زر تسجيل الدخول ─────────────────────────────────────────
  Widget _buildLoginButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton.icon(
        onPressed: _isLoading ? null : _login,
        icon: _isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : const Icon(Icons.login, color: Colors.white),
        label: Text(
          _isLoading ? 'جاري التحقق...' : 'تسجيل الدخول',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppConstants.primaryColor,
          disabledBackgroundColor: AppConstants.primaryColor.withAlpha(150),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
          ),
          elevation: 2,
        ),
      ),
    );
  }

  // ── نص الدعم الفني ──────────────────────────────────────────
  Widget _buildSupportText() {
    return Text(
      'للحصول على المساعدة : يرجى التواصل مع الدعم الفني',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 12,
        color: Colors.grey[500],
      ),
    );
  }
}
