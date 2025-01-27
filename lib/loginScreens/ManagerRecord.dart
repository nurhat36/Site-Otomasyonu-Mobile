import 'package:flutter/material.dart';
import '../Sqflıte/dbHalper.dart';// DBHelper sınıfını dahil ettik

class ManagerRecord extends StatefulWidget {
  @override
  _ManagerRecordState createState() => _ManagerRecordState();
}

class _ManagerRecordState extends State<ManagerRecord> {
  final TextEditingController binaNoController = TextEditingController();
  final TextEditingController daireSayisiController = TextEditingController();
  final TextEditingController binaSifresiController = TextEditingController();

  bool _isPasswordVisible = false; // Şifre görünürlüğünü kontrol eden değişken

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

            // Şifre Alanı
            TextField(
              controller: binaSifresiController,
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

            // Kayıt Butonu
            ElevatedButton(
              onPressed: () async {
                String binaNo = binaNoController.text;
                String daireSayisi = daireSayisiController.text;
                String binaSifresi = binaSifresiController.text;

                // Alanlar boşsa uyarı göster
                if (binaNo.isEmpty || daireSayisi.isEmpty || binaSifresi.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Lütfen tüm alanları doldurun!')),
                  );
                  return;
                }

                // DBHelper instance'ı
                var dbHelper = DBHelper();

                // Veritabanına yeni yönetici ekle
                var data = {
                  'binaNo': binaNo,
                  'daireSayisi': daireSayisi,
                  'binaSifresi': binaSifresi,
                };

                try {
                  // Veritabanına ekleme işlemi
                  await dbHelper.insertItem(data);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Kayıt başarılı!')),
                  );

                  // Kayıttan sonra önceki ekrana dön
                  Navigator.pop(context);
                } catch (e) {
                  print('Bir hata oluştu: ${e.toString()}');
                  // Hata durumunda kullanıcıyı bilgilendir
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Bir hata oluştu: ${e.toString()}')),

                  );
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
