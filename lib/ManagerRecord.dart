import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Bina Şifresi',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                String binaNo = binaNoController.text;
                String daireSayisi = daireSayisiController.text;
                String binaSifresi = binaSifresiController.text;

                if (binaNo.isEmpty || daireSayisi.isEmpty || binaSifresi.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Lütfen tüm alanları doldurun!')),
                  );
                  return;
                }

                // Firestore'da aynı bina numarasıyla bir yönetici kayıtlı mı kontrol et
                QuerySnapshot managerSnapshot = await FirebaseFirestore.instance
                    .collection('managers')
                    .where('binaNo', isEqualTo: binaNo)
                    .get();

                if (managerSnapshot.docs.isNotEmpty) {
                  // Eğer aynı bina numarasıyla bir kayıt varsa uyarı ver
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Bu bina zaten kayıtlı!')),
                  );
                  return;
                }

                // Firestore'a yeni yönetici ekle
                await FirebaseFirestore.instance.collection('managers').add({
                  'binaNo': binaNo,
                  'daireSayisi': daireSayisi,
                  'binaSifresi': binaSifresi,
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Kayıt başarılı!')),
                );
                Navigator.pop(context);
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
