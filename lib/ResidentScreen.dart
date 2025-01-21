import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'LoginScreen.dart';

class ResidentScreen extends StatefulWidget {
  const ResidentScreen({super.key});

  @override
  _ResidentScreenState createState() => _ResidentScreenState();
}

class _ResidentScreenState extends State<ResidentScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? user;
  String binaNo = "Yükleniyor...";
  String daireNo = "Yükleniyor...";
  String daireSayisi = "Yükleniyor...";

  @override
  void initState() {
    super.initState();
    user = _auth.currentUser;
    _getResidentBilgileri();
  }

  Future<void> _getResidentBilgileri() async {
    if (user != null) {
      DocumentSnapshot<Map<String, dynamic>> doc =
      await _firestore.collection("sakinler").doc(user!.uid).get();

      if (doc.exists) {
        setState(() {
          binaNo = doc.data()?["binaNo"] ?? "Bilinmiyor";
          daireNo = doc.data()?["daireNo"] ?? "Bilinmiyor";
        });
      }

      DocumentSnapshot<Map<String, dynamic>> binaDoc =
      await _firestore.collection("binalar").doc(binaNo).get();

      if (binaDoc.exists) {
        setState(() {
          daireSayisi = binaDoc.data()?["daireSayisi"]?.toString() ?? "Bilinmiyor";
        });
      }
    }
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
                    "Bina Sakini", // Yönetici yerine Bina Sakini yazdık
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
                    builder: (context) => HesapBilgileriScreen(
                      userEmail: user?.email ?? "Bilinmiyor",
                      binaNo: binaNo,
                      daireNo: daireNo,
                    ),
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
        child: Text('Hoş geldiniz, Bina Sakini!'),
      ),
    );
  }
}

// ✅ Hesap Bilgileri Sayfası
class HesapBilgileriScreen extends StatelessWidget {
  final String userEmail;
  final String binaNo;
  final String daireNo;

  HesapBilgileriScreen({
    required this.userEmail,
    required this.binaNo,
    required this.daireNo,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Hesap Bilgileri')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('E-mail: $userEmail', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('Bina No: $binaNo', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('Daire No: $daireNo', style: TextStyle(fontSize: 18)),
          ],
        ),
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

  BinaHakkindaScreen({required this.binaNo, required this.daireSayisi});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Bina Hakkında')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Bina Numarası: $binaNo', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('Daire Sayısı: $daireSayisi', style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
