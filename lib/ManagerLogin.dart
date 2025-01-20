import 'package:flutter/material.dart';
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
                    onPressed: () {
                      print("Giriş Yapıldı: ${binaNoController.text}");
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
