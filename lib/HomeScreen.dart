import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'LoginScreen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final User? user = _auth.currentUser;

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
                    user?.email ?? 'Kullanıcı',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.attach_money),
              title: Text('Gelir'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => GelirScreen()));
              },
            ),
            ListTile(
              leading: Icon(Icons.money_off),
              title: Text('Gider'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => GiderScreen()));
              },
            ),
            ListTile(
              leading: Icon(Icons.payment),
              title: Text('Aidat'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => AidatScreen()));
              },
            ),
            ListTile(
              leading: Icon(Icons.report_problem),
              title: Text('Şikayet'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => SikayetScreen()));
              },
            ),
            ListTile(
              leading: Icon(Icons.info),
              title: Text('Bina Hakkında'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => BinaHakkindaScreen()));
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
        child: Text('Hoş geldiniz, ${user?.email}!'),
      ),
    );
  }
}

// GELİR SAYFASI
class GelirScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Gelir')),
      body: Center(child: Text('Gelir bilgileri buraya gelecek')),
    );
  }
}

// GİDER SAYFASI
class GiderScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Gider')),
      body: Center(child: Text('Gider bilgileri buraya gelecek')),
    );
  }
}

// AİDAT SAYFASI
class AidatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Aidat')),
      body: Center(child: Text('Aidat bilgileri buraya gelecek')),
    );
  }
}

// ŞİKAYET SAYFASI
class SikayetScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Şikayet')),
      body: Center(child: Text('Şikayet ekranı buraya gelecek')),
    );
  }
}

// BİNA HAKKINDA SAYFASI
class BinaHakkindaScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Bina Hakkında')),
      body: Center(child: Text('Bina bilgileri buraya gelecek')),
    );
  }
}
