import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ResidentRecord extends StatefulWidget {
  @override
  _ResidentRecordState createState() => _ResidentRecordState();
}

class _ResidentRecordState extends State<ResidentRecord> {
  // TextController'lar
  final TextEditingController binaNoController = TextEditingController();
  final TextEditingController daireNoController = TextEditingController();
  final TextEditingController sifreController = TextEditingController();

  bool _isPasswordVisible = false; // Şifre görünürlüğünü kontrol eden değişken

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

            // Kaydol Butonu
            ElevatedButton(
              onPressed: () async {
                String binaNo = binaNoController.text;
                String daireNo = daireNoController.text;
                String sifre = sifreController.text;

                // Kontrol: Eğer herhangi bir alan boşsa kullanıcıya uyarı mesajı göster
                if (binaNo.isEmpty || daireNo.isEmpty || sifre.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Lütfen tüm alanları doldurun!')),
                  );
                  return;
                }

                // Firestore'da yönetici tarafından bina kayıtlı mı kontrol et
                QuerySnapshot managerSnapshot = await FirebaseFirestore.instance
                    .collection('managers')
                    .where('binaNo', isEqualTo: binaNo)
                    .get();

                if (managerSnapshot.docs.isEmpty) {
                  // Eğer bina yönetici tarafından kayıtlı değilse uyarı ver
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Bu bina yönetici tarafından kayıtlı değil!')),
                  );
                  return;
                }

                // Firestore'da aynı daire numarasıyla kayıtlı bir sakini kontrol et
                QuerySnapshot residentSnapshot = await FirebaseFirestore.instance
                    .collection('residents')
                    .where('binaNo', isEqualTo: binaNo)
                    .where('daireNo', isEqualTo: daireNo)
                    .get();

                if (residentSnapshot.docs.isNotEmpty) {
                  // Eğer aynı daire numarasıyla bir kayıt varsa uyarı ver
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Bu daire zaten kayıtlı!')),
                  );
                  return;
                }

                // Firestore'a yeni sakini ekle
                await FirebaseFirestore.instance.collection('residents').add({
                  'binaNo': binaNo,
                  'daireNo': daireNo,
                  'sifre': sifre,
                });

                // Kayıt başarılı mesajı
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Kayıt başarılı!')),
                );

                // Kayıt sonrası giriş ekranına dön
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
