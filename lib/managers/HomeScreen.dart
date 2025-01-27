import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../Sqflıte/dbHalper.dart';
import '../loginScreens/LoginScreen.dart';
import '../residents/ResidentScreen.dart'; // DBHelper sınıfını dahil ettik

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
  late DBHelper dbHelper; // DBHelper instance
  String binaNo = "Yükleniyor...";
  String daireSayisi = "Yükleniyor...";
  String userName = "Yönetici"; // Kullanıcı adı statik olarak belirlenmiş

  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper(); // DBHelper'ı başlatıyoruz
    _loadData();
  }

  // Firebase'ten gelen veriler yerine, veritabanından verileri alıyoruz
  void _loadData() async {
    var data = await dbHelper.getManagers(widget.binaNo, ""); // Bina verisini alıyoruz
    setState(() {
      binaNo = widget.binaNo;
      daireSayisi = widget.daireSayisi;
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
                    userName,
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Hesap Bilgileri'),
              onTap: () {
                // Hesap bilgilerine gitmek için navigasyon
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HesapBilgileriScreen(
                        userEmail: "Bilinmiyor", binaNo: '', daireNo: '',),
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
                  MaterialPageRoute(
                    builder: (context) => GiderScreen(
                      binaNo: widget.binaNo,
                    ),
                  ),
                );
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
                // Çıkış işlemi
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
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _getGelirler(binaNo), // Gelirleri veritabanından çekiyoruz
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
                child: Text('Bu bina için kayıtlı gelir bulunmamaktadır.'));
          }
          final gelirler = snapshot.data!;
          return ListView.builder(
            itemCount: gelirler.length,
            itemBuilder: (context, index) {
              final gelir = gelirler[index];
              final miktar = gelir['miktar'];
              final daireNo = gelir['daireNo'];
              final tarih = DateTime.parse(gelir['tarih']);
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

  // Gelirleri veritabanından alıyoruz
  Future<List<Map<String, dynamic>>> _getGelirler(String binaNo) async {
    final dbHelper = DBHelper();
    return await dbHelper.getItems(); // DBHelper'dan gelir verilerini alıyoruz
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

                // Veriyi veritabanına ekliyoruz
                final gelir = {
                  'binaNo': widget.binaNo,
                  'miktar': miktarController.text,
                  'daireNo': seciliDaire,
                  'tarih': DateTime.now().toIso8601String(), // Tarih formatı
                };

                final dbHelper = DBHelper();
                await dbHelper.insertItem(gelir); // Veriyi ekliyoruz

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
class GiderScreen extends StatefulWidget {
  final String binaNo;

  const GiderScreen({
    super.key,
    required this.binaNo,
  });

  @override
  _GiderScreenState createState() => _GiderScreenState(binaNo: binaNo);
}

class _GiderScreenState extends State<GiderScreen> {
  final TextEditingController kayitNoController = TextEditingController();
  final String binaNo;

  _GiderScreenState({
    required this.binaNo,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Gider')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _getGiderler(binaNo),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
                child: Text('Bu bina için kayıtlı gider bulunmamaktadır.'));
          }
          final giderler = snapshot.data!;
          return ListView.builder(
            itemCount: giderler.length,
            itemBuilder: (context, index) {
              final gider = giderler[index];
              final miktar = gider['miktar'];
              final kayitNo = gider['kayitNo'];
              final tarih = DateTime.parse(gider['tarih']);
              return Card(
                margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: ListTile(
                  title: Text('Kayıt No: $kayitNo'),
                  subtitle: Text('Tarih: ${tarih.toLocal()}'),
                  trailing: Text('Miktar: ₺$miktar'),
                ),
              );
            },
          );
        },
      ),
    );
  }

  // Giderleri veritabanından alıyoruz
  Future<List<Map<String, dynamic>>> _getGiderler(String binaNo) async {
    final dbHelper = DBHelper();
    return await dbHelper.getItems(); // DBHelper'dan gider verilerini alıyoruz
  }
}

void _showDekont(BuildContext context, String dekontUrl) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Dekont'),
        content: dekontUrl.isNotEmpty
            ? Image.network(dekontUrl)
            : Text('Dekont bulunamadı.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Kapat'),
          ),
        ],
      );
    },
  );
}


@override
  Widget build(BuildContext context) {
    var binaNo;
    return Scaffold(
      appBar: AppBar(title: Text('Gider')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('giderler')
            .where('binaNo', isEqualTo: binaNo)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
                child: Text('Bu bina için kayıtlı gelir bulunmamaktadır.'));
          }
          final gelirler = snapshot.data!.docs;
          return ListView.builder(
            itemCount: gelirler.length,
            itemBuilder: (context, index) {
              final gelir = gelirler[index];
              final miktar = gelir['miktar'];
              final tur = gelir['tur'];

              final tarih = (gelir['tarih'] as Timestamp).toDate();
              return Card(
                margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: ListTile(
                  title: Text('Gider Türü: $tur'),
                  subtitle: Text('Tarih: ${tarih.toLocal()}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('₺$miktar'),
                      SizedBox(width: 8), // Buton ile metin arasında boşluk
                      IconButton(
                        icon: Icon(Icons.receipt_long),
                        tooltip: 'Dekont Görüntüle',
                        onPressed: () {
                          _showDekont(context, gelir['dekontUrl']);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          var binaNo;
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => GiderEkleScreen(
                        binaNo: binaNo,
                      )));
        },
        child: Icon(Icons.add_rounded),
      ),
    );
  }


class GiderEkleScreen extends StatefulWidget {
  final String binaNo;

  const GiderEkleScreen({
    super.key,
    required this.binaNo,
  });

  @override
  _GiderEkleScreenState createState() => _GiderEkleScreenState();
}

class _GiderEkleScreenState extends State<GiderEkleScreen> {
  final TextEditingController miktarController = TextEditingController();
  final TextEditingController digerAciklamaController = TextEditingController();
  String? seciliTur;
  String? dekontUrl;

  List<Map<String, dynamic>> giderTurleri = [
    {'isim': 'Elektrik', 'icon': Icons.flash_on},
    {'isim': 'Su', 'icon': Icons.water_drop},
    {'isim': 'Doğalgaz', 'icon': Icons.local_fire_department},
    {'isim': 'Bahçıvan', 'icon': Icons.grass},
    {'isim': 'Asansör Bakımı', 'icon': Icons.elevator},
    {'isim': 'Diğer', 'icon': Icons.more_horiz},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Gider Ekle')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              value: seciliTur,
              items: giderTurleri.map((tur) {
                return DropdownMenuItem<String>(
                  value: tur['isim'],
                  child: Row(
                    children: [
                      Icon(tur['icon']),
                      SizedBox(width: 10),
                      Text(tur['isim']),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (String? yeniDeger) {
                setState(() {
                  seciliTur = yeniDeger;
                });
              },
              decoration: InputDecoration(
                  labelText: 'Gider Türü', border: OutlineInputBorder()),
            ),
            if (seciliTur == 'Diğer')
              TextField(
                controller: digerAciklamaController,
                decoration: InputDecoration(
                    labelText: 'Açıklama', border: OutlineInputBorder()),
              ),
            SizedBox(height: 12),
            TextField(
              controller: miktarController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  labelText: 'Gider Miktarı', border: OutlineInputBorder()),
            ),
            SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DekontYukleScreen(),
                  ),
                ).then((value) {
                  if (value != null) setState(() => dekontUrl = value);
                });
              },
              child: Text('Dekont Yükle'),
            ),
            if (dekontUrl != null)
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              DekontGoruntuleScreen(kayitNo: dekontUrl!)));
                },
                child: Text('Dekont Görüntüle'),
              ),
            SizedBox(height: 12),
            ElevatedButton(
              onPressed: () async {
                await FirebaseFirestore.instance.collection('giderler').add({
                  'tur': seciliTur == 'Diğer'
                      ? digerAciklamaController.text
                      : seciliTur,
                  'miktar': miktarController.text,
                  'dekontUrl': dekontUrl,
                  'tarih': Timestamp.now(),
                  'binaNo': widget.binaNo,
                });
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

class DekontYukleScreen extends StatefulWidget {
  @override
  _DekontYukleScreenState createState() => _DekontYukleScreenState();
}

class _DekontYukleScreenState extends State<DekontYukleScreen> {
  File? _image;
  final ImagePicker _imagePicker = ImagePicker(); // Unique naming

  Future<bool> requestStoragePermission() async {
    // Depolama izni iste
    PermissionStatus status = await Permission.storage.request();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Depolama izni istedikte olmadı')),
    );

    // İzin verildiyse true, değilse false döndür
    if (status == PermissionStatus.granted) {
      return true;
    } else {
      // İzin reddedildiyse kullanıcıya bildir
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Depolama izni gereklidir.')),
      );
      return false;
    }
  }


  Future<void> _uploadImage() async {
    try {
      bool hasPermission = await requestStoragePermission();
      if (!hasPermission) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Depolama izni verilmedi!')),
        );
        return;
      }

      final pickedFile = await _imagePicker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        final imageFile = File(pickedFile.path);
        final fileName = DateTime.now().millisecondsSinceEpoch.toString();
        final storageRef = FirebaseStorage.instance.ref().child("dekontlar/$fileName");
        final metadata = SettableMetadata(contentType: 'image/jpeg');

        final uploadTask = storageRef.putFile(imageFile, metadata);
        final taskSnapshot = await uploadTask.whenComplete(() => {});

        if (taskSnapshot.state == TaskState.success) {
          final downloadUrl = await storageRef.getDownloadURL();
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DekontGoruntuleScreen(kayitNo: downloadUrl)),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Dekont yükleme başarısız oldu!')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Herhangi bir dosya seçilmedi.')),
        );
      }
    } catch (e) {
      print('An error occurred: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Dekont yükleme sırasında hata oluştu: $e'),
        ),
      );
    }
  }

// Widget build method (assuming you have a button to call _uploadImage)
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Dekont Yükle')),
      body: Center(
        child: ElevatedButton(
          onPressed: _uploadImage,
          child: Text('Fotoğraf Seç'),
        ),
      ),
    );
  }
}

class DekontGoruntuleScreen extends StatelessWidget {
  final String kayitNo;

  DekontGoruntuleScreen({required this.kayitNo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Dekont Görüntüle')),
      body: Center(
        child: kayitNo.isNotEmpty
            ? Image.network(kayitNo)
            : const Text('Dekont görüntülenemedi.'),
      ),
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
        title: Text('Bina Hakkında'),
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
