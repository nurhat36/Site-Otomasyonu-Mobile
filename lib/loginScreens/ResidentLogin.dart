import 'package:flutter/material.dart';
import '../Sqflıte/dbHalper.dart';// DBHelper sınıfını dahil ettik
import 'ResidentRecord.dart'; // Bina sakini kayıt ekranı
import '../residents/ResidentScreen.dart';

class ResidentLogin extends StatefulWidget {
  @override
  _ResidentLoginState createState() => _ResidentLoginState();
}

class _ResidentLoginState extends State<ResidentLogin> {
  final TextEditingController binaNoController = TextEditingController();
  final TextEditingController daireNoController = TextEditingController();
  final TextEditingController sifreController = TextEditingController();

  bool _isPasswordVisible = false; // Şifre görünürlüğünü kontrol eden değişken

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Bina Sakini Giriş')),
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

            // Daire No Alanı
            TextField(
              controller: daireNoController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Daire No',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 12),

            // Şifre Alanı
            TextField(
              controller: sifreController,
              obscureText: !_isPasswordVisible, // Şifre görünürlüğünü ayarla
              decoration: InputDecoration(
                labelText: 'Şifre',
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

            // Giriş Yap ve Kayıt Ol Butonları
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    String binaNo = binaNoController.text;
                    String daireNo = daireNoController.text;
                    String sifre = sifreController.text;

                    if (binaNo.isEmpty || daireNo.isEmpty || sifre.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Lütfen tüm alanları doldurun!')),
                      );
                    } else {
                      // SQLite üzerinden sorgulama
                      var result = await DBHelper().getItems();
                      var matchingUser = result.firstWhere(
                            (item) => item['binaNo'] == binaNo &&
                            item['daireNo'] == daireNo &&
                            item['sifre'] == sifre,
                          orElse: () => {} // Eğer eşleşme bulunmazsa, boş bir map döndürüyoruz
                      );

                      if (matchingUser != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Giriş başarılı!')),
                        );
                        // Giriş başarılı işlemleri burada yapılabilir
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => ResidentScreen()),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Bilgiler yanlış veya kullanıcı bulunamadı!')),
                        );
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  child: Text('Giriş Yap', style: TextStyle(color: Colors.white)),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ResidentRecord()), // Kayıt ekranına yönlendir
                    );
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  child: Text('Kayıt Ol', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
