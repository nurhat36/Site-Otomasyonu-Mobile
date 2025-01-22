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
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? user;

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GelirScreen(
                      binaNo: widget.binaNo,
                      daireSayisi: widget.daireSayisi,
                    ),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.money_off),
              title: Text('Gider'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GiderScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.payment),
              title: Text('Aidat'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AidatScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.report_problem),
              title: Text('Şikayet'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SikayetScreen()),
                );
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
                      binaNo: widget.binaNo,
                      daireSayisi: widget.daireSayisi,
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

class GelirScreen extends StatelessWidget {
  final String binaNo;
  final String daireSayisi;

  const GelirScreen({
    super.key,
    required this.binaNo,
    required this.daireSayisi,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Gelir')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('gelirler')
            .where('binaNo', isEqualTo: binaNo)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('Bu bina için kayıtlı gelir bulunmamaktadır.'));
          }

          final gelirler = snapshot.data!.docs;

          return ListView.builder(
            itemCount: gelirler.length,
            itemBuilder: (context, index) {
              final gelir = gelirler[index];
              final miktar = gelir['miktar'];
              final daireNo = gelir['daireNo'];
              final tarih = (gelir['tarih'] as Timestamp).toDate();

              return Card(
                margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: ListTile(
                  title: Text('Daire No: $daireNo'),
                  subtitle: Text('Tarih: ${tarih.toLocal()}'),
                  trailing: Text('Miktar: ₺$miktar'),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => GelirEkleScreen(
                binaNo: binaNo,
                daireSayisi: daireSayisi,
              ),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}


class GelirEkleScreen extends StatefulWidget {
  final String binaNo;
  final String daireSayisi;

  const GelirEkleScreen({
    super.key,
    required this.binaNo,
    required this.daireSayisi,
  });

  @override
  _GelirEkleScreenState createState() => _GelirEkleScreenState();
}

class _GelirEkleScreenState extends State<GelirEkleScreen> {
  final TextEditingController miktarController = TextEditingController();
  String? seciliDaire;
  List<String> daireler = [];

  @override
  void initState() {
    super.initState();
    _initializeDaireler();
  }

  void _initializeDaireler() {
    int daireSayisiInt = int.tryParse(widget.daireSayisi) ?? 0;
    daireler = List.generate(daireSayisiInt, (index) => (index + 1).toString());
  }

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
                  child: Text(daire),
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

                await FirebaseFirestore.instance.collection('gelirler').add({
                  'binaNo':widget.binaNo,
                  'miktar': miktarController.text,
                  'daireNo': seciliDaire,
                  'tarih': Timestamp.now(),
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Gelir başarıyla eklendi!')),
                );

                Navigator.pop(context);
              },
              child: Text('Onayla'),
            ),
          ],
        ),
      ),
    );
  }
}

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

class GiderScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Gider')),
      body: Center(child: Text('Gider bilgileri buraya gelecek')),
    );
  }
}

class AidatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Aidat')),
      body: Center(child: Text('Aidat bilgileri buraya gelecek')),
    );
  }
}

class SikayetScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Şikayet')),
      body: Center(child: Text('Şikayet ekranı buraya gelecek')),
    );
  }
}

class BinaHakkindaScreen extends StatelessWidget {
  final String binaNo;
  final String daireSayisi;

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
