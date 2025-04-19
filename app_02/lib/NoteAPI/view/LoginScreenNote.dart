import 'package:app_02/NoteAPI/API/AccountNoteAPIService.dart';
import 'package:app_02/main.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/AccountNote.dart';
import 'NoteListScreenAPI.dart';
import 'NoteRegisterScreen.dart';

class LoginScreenNote extends StatefulWidget {
  const LoginScreenNote({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreenNote> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        final account = await AccountNoteAPIService.instance.login(
          _usernameController.text.trim(),
          _passwordController.text.trim(),
        );

        setState(() => _isLoading = false);

        if (account != null) {
          final prefs = await SharedPreferences.getInstance();

          // ✅ Lưu thông tin tài khoản
          await prefs.setInt('userId', account.userId);
          await prefs.setInt('accountId', account.id!);
          await prefs.setString('username', account.username);
          await prefs.setBool('isLoggedIn', true);

          if (!mounted) return;

          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => NoteListScreenAPI(onLogout: _logout),
            ),
          );
        } else {
          _showErrorDialog(
            'Đăng nhập thất bại',
            'Tên đăng nhập hoặc mật khẩu không đúng hoặc tài khoản không hoạt động.',
          );
        }
      } catch (e) {
        setState(() => _isLoading = false);
        _showErrorDialog('Lỗi đăng nhập', 'Đã xảy ra lỗi: $e');
      }
    }
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    if (mounted) {
      runApp(const MyApp()); // 🔁 Reset toàn bộ ứng dụng
    }
  }

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Đóng'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Đăng nhập Note-API')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.account_circle,
                  size: 80, color: Theme.of(context).primaryColor),
              const SizedBox(height: 40),

              // Tên đăng nhập
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Tên đăng nhập',
                  prefixIcon: const Icon(Icons.person),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                validator: (value) =>
                value!.isEmpty ? 'Vui lòng nhập tên đăng nhập' : null,
              ),

              const SizedBox(height: 20),

              // Mật khẩu
              TextFormField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: 'Mật khẩu',
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(_obscurePassword
                        ? Icons.visibility
                        : Icons.visibility_off),
                    onPressed: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                validator: (value) =>
                value!.isEmpty ? 'Vui lòng nhập mật khẩu' : null,
              ),

              const SizedBox(height: 30),

              // Nút đăng nhập
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _login,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                    'ĐĂNG NHẬP',
                    style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              const SizedBox(height: 20),
              TextButton(
                onPressed: () {},
                child: const Text('Quên mật khẩu?'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const NoteRegisterScreen()),
                  );
                },
                child: const Text("Bạn chưa có tài khoản? Đăng ký"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
