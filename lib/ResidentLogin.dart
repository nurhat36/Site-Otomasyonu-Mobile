import 'package:flutter/material.dart';
import 'ResidentRecord.dart'; // Bina sakini kayıt ekranı

class ResidentLogin extends StatelessWidget {
  final TextEditingController binaNoController = TextEditingController();
  final TextEditingController daireNoController = TextEditingController();
  final TextEditingController sifreController = TextEditingController();

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
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Şifre',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),

            // Giriş Yap ve Kayıt Ol Butonları
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    String binaNo = binaNoController.text;
                    String daireNo = daireNoController.text;
                    String sifre = sifreController.text;

                    if (binaNo.isEmpty || daireNo.isEmpty || sifre.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Lütfen tüm alanları doldurun!')),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Giriş başarılı!')),
                      );
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
