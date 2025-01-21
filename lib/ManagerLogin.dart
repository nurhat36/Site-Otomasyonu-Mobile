import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:site_otomasyonu2/HomeScreen.dart';
import 'ManagerRecord.dart'; // Yönetici Kayıt Ekranı dosyasını ekledik

class ManagerLogin extends StatelessWidget {
  final TextEditingController binaNoController = TextEditingController();
  final TextEditingController sifreController = TextEditingController();

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
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Bina Şifresi',
                border: OutlineInputBorder(),
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

                      // Firestore'dan veriyi kontrol et
                      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
                          .collection('managers')
                          .where('binaNo', isEqualTo: binaNo)
                          .where('binaSifresi', isEqualTo: binaSifresi)
                          .get();

                      if (querySnapshot.docs.isNotEmpty) {
                        // Giriş başarılı
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Giriş başarılı!')),
                        );
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => HomeScreen()),
                        );
                        // Burada giriş sonrası yönlendirme yapılabilir
                      } else {
                        // Hatalı giriş
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Hatalı Bina No veya Şifre!')),
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
