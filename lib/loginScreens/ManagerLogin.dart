import 'package:flutter/material.dart';
import 'package:site_otomasyonu2/managers/HomeScreen.dart';
import '../Sqflıte/dbHalper.dart';// DBHelper sınıfını dahil ettik

import 'ManagerRecord.dart'; // Yönetici Kayıt Ekranı dosyasını ekledik

class ManagerLogin extends StatefulWidget {
  @override
  _ManagerLoginState createState() => _ManagerLoginState();
}

class _ManagerLoginState extends State<ManagerLogin> {
  final TextEditingController binaNoController = TextEditingController();
  final TextEditingController sifreController = TextEditingController();

  bool _isPasswordVisible = false; // Şifre görünürlüğünü kontrol eden değişken

  final DBHelper _dbHelper = DBHelper(); // DBHelper örneği

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Yönetici Girişi')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Bina No Alanı
            TextField(
              controller: binaNoController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Bina No',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 12),

            // Şifre Alanı
            TextField(
              controller: sifreController,
              obscureText: !_isPasswordVisible, // Şifre görünürlüğünü ayarla
              decoration: InputDecoration(
                labelText: 'Bina Şifresi',
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible; // Durumu değiştir
                    });
                  },
                ),
              ),
            ),
            SizedBox(height: 20),

            // Giriş ve Kayıt Butonları
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      String binaNo = binaNoController.text;
                      String binaSifresi = sifreController.text;

                      try {
                        // Veritabanında yöneticiyi arıyoruz
                        Map<String, dynamic>? manager = await _dbHelper.getManagers(binaNo, binaSifresi);

                        if (manager != null) {
                          // Giriş başarılı
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Giriş başarılı!')),
                          );

                          // Manager verisini alıyoruz
                          var managerData = manager;

                          // HomeScreen'e geçiş yap ve gerekli verileri aktar
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomeScreen(
                                binaNo: managerData['binaNo'].toString() ?? '', // Bina numarasını alıyoruz
                                daireSayisi: managerData['daireSayisi']?.toString() ?? '', // Daire sayısını alıyoruz
                              ),
                            ),
                          );
                        } else {
                          // Hatalı giriş
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Hatalı Bina No veya Şifre!')),
                          );
                        }
                      } catch (e) {
                        print('Bir hata oluştu: ${e.toString()}');
                        // Hata durumunda kullanıcıyı bilgilendir
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Bir hata oluştu: ${e.toString()}')),
                        );
                      }

                    },
                    child: Text('Giriş Yap'),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Yönetici Kayıt Ekranına Git
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ManagerRecord()),
                      );
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    child: Text('Kayıt Ol', style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
