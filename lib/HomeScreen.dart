import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'LoginScreen.dart';

class HomeScreen extends StatefulWidget {
  final String binaNo;
  final String daireSayisi;
  const HomeScreen({
    super.key,
    required this.binaNo,
    required this.daireSayisi,
  });

  @override
  _HomeScreenState createState() => _HomeScreenState(binaNo: binaNo,daireSayisi: daireSayisi,);
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? user;
  String binaNo = "Yükleniyor...";
  String daireSayisi = "Yükleniyor...";
  _HomeScreenState({
    required this.binaNo,
    required this.daireSayisi,
  });

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {

      } else {
        setState(() {
          this.user = user;
        });

      }
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ana Sayfa'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.account_circle, size: 60, color: Colors.white),
                  SizedBox(height: 10),
                  Text(
                    "Yönetici",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Hesap Bilgileri'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        HesapBilgileriScreen(userEmail: user?.email ?? "Bilinmiyor"),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.attach_money),
              title: Text('Gelir'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => GelirScreen()));
              },
            ),
            ListTile(
              leading: Icon(Icons.money_off),
              title: Text('Gider'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => GiderScreen()));
              },
            ),
            ListTile(
              leading: Icon(Icons.payment),
              title: Text('Aidat'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AidatScreen()));
              },
            ),
            ListTile(
              leading: Icon(Icons.report_problem),
              title: Text('Şikayet'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SikayetScreen()));
              },
            ),
            ListTile(
              leading: Icon(Icons.info),
              title: Text('Bina Hakkında'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BinaHakkindaScreen(
                      binaNo: binaNo,
                      daireSayisi: daireSayisi,
                    ),
                  ),
                );
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Çıkış Yap'),
              onTap: () async {
                await _auth.signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Text('Hoş geldiniz, Yönetici!'),
      ),
    );
  }
}

// ✅ Hesap Bilgileri Sayfası
class HesapBilgileriScreen extends StatelessWidget {
  final String userEmail;

  HesapBilgileriScreen({required this.userEmail});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Hesap Bilgileri')),
      body: Center(
        child: Text('Yönetici E-mail: $userEmail'),
      ),
    );
  }
}

// ✅ Gelir Sayfası
class GelirScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Gelir')),
      body: Center(child: Text('Gelir bilgileri buraya gelecek')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => GelirEkleScreen()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class GelirEkleScreen extends StatefulWidget {
  @override
  _GelirEkleScreenState createState() => _GelirEkleScreenState();
}

class _GelirEkleScreenState extends State<GelirEkleScreen> {
  final TextEditingController miktarController = TextEditingController();
  String? seciliDaire;
  List<String> daireler = ['101', '102', '103', '104']; // Firebase'den çekilecek

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Gelir Ekle')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: miktarController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Gelir Miktarı',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: seciliDaire,
              items: daireler.map((String daire) {
                return DropdownMenuItem<String>(
                  value: daire,
                  child: Text('Daire No: $daire'),
                );
              }).toList(),
              onChanged: (String? yeniDeger) {
                setState(() {
                  seciliDaire = yeniDeger;
                });
              },
              decoration: InputDecoration(
                labelText: 'Daire No',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (miktarController.text.isEmpty || seciliDaire == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Lütfen tüm alanları doldurun!')),
                  );
                  return;
                }

                // Firebase'e veri ekleme işlemi
                await FirebaseFirestore.instance.collection('gelirler').add({
                  'miktar': miktarController.text,
                  'daireNo': seciliDaire,
                  'tarih': Timestamp.now(),
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Gelir başarıyla eklendi!')),
                );

                Navigator.pop(context); // Ekranı kapat
              },
              child: Text('Onayla'),
            ),
          ],
        ),
      ),
    );
  }
}

// ✅ Gider Sayfası
class GiderScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Gider')),
      body: Center(child: Text('Gider bilgileri buraya gelecek')),
    );
  }
}

// ✅ Aidat Sayfası
class AidatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Aidat')),
      body: Center(child: Text('Aidat bilgileri buraya gelecek')),
    );
  }
}

// ✅ Şikayet Sayfası
class SikayetScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Şikayet')),
      body: Center(child: Text('Şikayet ekranı buraya gelecek')),
    );
  }
}

// ✅ Bina Hakkında Sayfası
class BinaHakkindaScreen extends StatelessWidget {
  final String binaNo;
  final String daireSayisi;

  // Constructor with required parameters
  const BinaHakkindaScreen({
    super.key,
    required this.binaNo,
    required this.daireSayisi,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bina Hakkında'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Bina Numarası: $binaNo',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              'Daire Sayısı: $daireSayisi',
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
