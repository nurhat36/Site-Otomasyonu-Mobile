import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  static Database? _database;

  factory DBHelper() {
    return _instance;
  }

  DBHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  // Veritabanını başlatma fonksiyonu
  Future<Database> _initDatabase() async {
    String path = await getDatabasesPath();
    String dbPath = join(path, 'app_database.db');

    // Eğer veritabanı daha önce varsa silmeden açma
    return await openDatabase(
      dbPath,
      version: 2, // Veritabanı sürümünü arttırıyoruz
      onCreate: _onCreate,
      onUpgrade: _onUpgrade, // Veritabanı sürüm yükseltme işlemi
    );
  }

  // Veritabanı oluşturma fonksiyonu
  Future<void> _onCreate(Database db, int version) async {
    await db.execute(''' 
      CREATE TABLE items (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        binaNo INTEGER NOT NULL,
        daireSayisi INTEGER DEFAULT 0,
        binaSifresi TEXT NOT NULL
      )
    ''');

    // Örnek veri ekleyelim
    await db.insert('items', {
      'binaNo': 1,
      'daireSayisi': 10,
      'binaSifresi': '#123#',
    });
    await db.insert('items', {
      'binaNo': 2,
      'daireSayisi': 20,
      'binaSifresi': '#456#',
    });
    await db.insert('items', {
      'binaNo': 3,
      'daireSayisi': 30,
      'binaSifresi': '#789#',
    });

    // Tabloyu konsola yazdıralım
    await printItems();
  }

  // Veritabanındaki verileri konsola yazdırma
  Future<void> printItems() async {
    final db = await database;
    List<Map<String, dynamic>> items = await db.query('items');

    for (var item in items) {
      print(
          'ID: ${item['id']}, Bina No: ${item['binaNo']}, Daire Sayisi: ${item['daireSayisi']}, Bina Sifresi: ${item['binaSifresi']}');
    }
  }

  // Veritabanı sürüm yükseltme fonksiyonu
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Veritabanı yükseltiliyor
      await db.execute('''
        ALTER TABLE items ADD COLUMN binaNo INTEGER DEFAULT 0
      ''');
      await db.execute('''
        ALTER TABLE items ADD COLUMN daireSayisi INTEGER DEFAULT 0
      ''');
      await db.execute('''
        ALTER TABLE items ADD COLUMN binaSifresi TEXT DEFAULT ''
      ''');
    }
  }

  // Yeni bir item eklemek için fonksiyon
  Future<int> insertItem(Map<String, dynamic> data) async {
    final db = await database;
    return await db.insert('items', data);
  }

  // Veritabanındaki tüm item'ları almak için fonksiyon
  Future<List<Map<String, dynamic>>> getItems() async {
    final db = await database;
    return await db.query('items');
  }

  // Belirli bir item'ı güncellemek için fonksiyon
  Future<int> updateItem(int id, Map<String, dynamic> data) async {
    final db = await database;
    return await db.update(
      'items',
      data,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Belirli bir item'ı silmek için fonksiyon
  Future<int> deleteItem(int id) async {
    final db = await database;
    return await db.delete(
      'items',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Veritabanı bağlantısını kapatma fonksiyonu
  Future<void> close() async {
    final db = await database;
    await db.close();
    _database = null;
  }

  // Kullanıcı ekleme fonksiyonu (örnek olarak)
  addUser(String uid, String text) {
    // Implement your logic here
  }

  // Kullanıcıya ait bilgileri almak için fonksiyon
  getResidentInfo(String uid) {
    // Implement your logic here
  }

  // Bina detaylarını almak için fonksiyon
  getBuildingDetails(String binaNo) {
    // Implement your logic here
  }

  // Yöneticiyi almak için fonksiyon (binaNo ve binaSifresi ile)
  Future<Map<String, dynamic>?> getManagers(String binaNo, String binaSifresi) async {
    final db = await database;
    final res = await db.query(
        'items',
        where: 'binaNo = ? AND binaSifresi = ?',
        whereArgs: [binaNo, binaSifresi]
    );
    return res.isNotEmpty ? res.first : null;  // Veritabanında kayıt varsa ilkini döndür
  }

}
