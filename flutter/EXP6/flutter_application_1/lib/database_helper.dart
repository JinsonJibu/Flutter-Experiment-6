import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'product.dart';

class DatabaseHelper {
  static Database? _database;
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    String path = join(await getDatabasesPath(), 'inventory.db');
    print('Database Path: $path'); // Debug print
    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        print('Creating database table'); // Debug print
        await db.execute('''
          CREATE TABLE products(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            quantity INTEGER,
            price REAL
          )
        ''');
      },
    );
  }

  Future<void> insertProduct(Product product) async {
    try {
      final db = await database;
      await db.insert('products', product.toMap());
      print('Product inserted successfully: ${product.toMap()}'); // Debug print
    } catch (e) {
      print('Error inserting product: $e'); // Debug print
      rethrow;
    }
  }

  Future<List<Product>> getProducts() async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query('products');
      print('Retrieved ${maps.length} products'); // Debug print
      return List.generate(maps.length, (i) => Product.fromMap(maps[i]));
    } catch (e) {
      print('Error getting products: $e'); // Debug print
      return [];
    }
  }
}