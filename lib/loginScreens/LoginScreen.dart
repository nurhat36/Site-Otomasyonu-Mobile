import 'package:flutter/material.dart';
import 'package:site_otomasyonu2/managers/HomeScreen.dart';
import 'package:site_otomasyonu2/loginScreens/UserType.dart';
import '../Sqflıte/dbHalper.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;
  String _errorMessage = '';

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      // Kullanıcıyı veritabanında ara
      final db = DBHelper();
      List<Map<String, dynamic>> users = await db.getItems(); // Burada kullanıcılar sorgulanacak.

      bool isUserFound = false;
      for (var user in users) {
        if (user['email'] == _emailController.text.trim() && user['password'] == _passwordController.text.trim()) {
          isUserFound = true;
          break;
        }
      }

      if (!isUserFound) {
        setState(() {
          _errorMessage = 'Kullanıcı bulunamadı veya şifre yanlış';
        });
      } else {
        // Giriş başarılıysa, ana ekranı göster
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen(binaNo: '', daireSayisi: '',)), // Başka bir ekran yönlendirme yapılabilir
        );
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Giriş Yap')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'E-posta',
                errorText: _errorMessage.isNotEmpty ? _errorMessage : null,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Şifre',
              ),
            ),
            const SizedBox(height: 16),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
              onPressed: _login,
              child: const Text('Giriş Yap'),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                // Kayıt ekranına yönlendirme
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => UserType()),
                );
              },
              child: const Text('Hesabınız yok mu? Kayıt olun.'),
            ),
          ],
        ),
      ),
    );
  }
}
