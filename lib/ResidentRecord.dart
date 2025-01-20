import 'package:flutter/material.dart';

class ResidentRecord extends StatelessWidget {
  // TextController'lar
  final TextEditingController binaNoController = TextEditingController();
  final TextEditingController daireNoController = TextEditingController();
  final TextEditingController sifreController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Bina Sakini Kaydı')),
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

            // Kaydol Butonu
            ElevatedButton(
              onPressed: () {
                String binaNo = binaNoController.text;
                String daireNo = daireNoController.text;
                String sifre = sifreController.text;

                // Kontrol: Eğer herhangi bir alan boşsa kullanıcıya uyarı mesajı göster
                if (binaNo.isEmpty || daireNo.isEmpty || sifre.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Lütfen tüm alanları doldurun!')),
                  );
                } else {
                  // Kayıt başarılı mesajı
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Kayıt başarılı!')),
                  );
                  // Kayıt sonrası giriş ekranına dön
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: Text('Kaydol', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
