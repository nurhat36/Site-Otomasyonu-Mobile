import 'package:flutter/material.dart';

class ManagerRecord extends StatelessWidget {
  final TextEditingController binaNoController = TextEditingController();
  final TextEditingController daireSayisiController = TextEditingController();
  final TextEditingController binaSifresiController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Yönetici Kaydı')),
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

            // Daire Sayısı Alanı
            TextField(
              controller: daireSayisiController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Daire Sayısı',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 12),

            // Bina Şifresi Alanı
            TextField(
              controller: binaSifresiController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Bina Şifresi',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),

            // Kaydol Butonu
            ElevatedButton(
              onPressed: () {
                String binaNo = binaNoController.text;
                String daireSayisi = daireSayisiController.text;
                String binaSifresi = binaSifresiController.text;

                if (binaNo.isEmpty || daireSayisi.isEmpty || binaSifresi.isEmpty) {
                  // Eğer alanlar boşsa hata mesajı göster
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Lütfen tüm alanları doldurun!')),
                  );
                } else {
                  // Kayıt başarılıysa mesaj göster
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Kayıt başarılı!')),
                  );
                  Navigator.pop(context); // Kayıt sonrası giriş ekranına dön
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
