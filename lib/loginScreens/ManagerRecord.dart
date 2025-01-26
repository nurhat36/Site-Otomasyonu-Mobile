import 'package:flutter/material.dart';

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
            TextField(
              controller: binaNoController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Bina No',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 12),
            TextField(
              controller: daireSayisiController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Daire Sayısı',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 12),
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
            ElevatedButton(
              onPressed: () async {
                // Kayıt işlemleri buraya gelecek
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
