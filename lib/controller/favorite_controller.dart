import 'package:get/get.dart';
import 'package:restaurant_app_api/model/restaurant_list.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class FavoriteController extends GetxController {
  final DatabaseHelper dbHelper = DatabaseHelper();

  RxList<Restaurant> favoriteRestaurants = RxList<Restaurant>();

  @override
  void onInit() {
    super.onInit();
    loadFavoriteRestaurants();
  }

  Future<void> addFavoriteRestaurant(Restaurant restaurant) async {
    if (!isRestaurantFavorite(restaurant.id)) {
      favoriteRestaurants.add(restaurant);
      update();
      await dbHelper.insertFavoriteRestaurant(restaurant);
    }
  }

  Future<void> removeFavoriteRestaurant(String restaurantId) async {
    favoriteRestaurants
        .removeWhere((restaurant) => restaurant.id == restaurantId);
    update();
    await dbHelper.deleteFavoriteRestaurant(restaurantId);
  }

  bool isRestaurantFavorite(String restaurantId) {
    return favoriteRestaurants
        .any((restaurant) => restaurant.id == restaurantId);
  }

  Future<void> loadFavoriteRestaurants() async {
    final restaurants = await dbHelper.getFavoriteRestaurants();
    favoriteRestaurants.assignAll(restaurants);
  }
}

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper.internal();
  factory DatabaseHelper() => _instance;

  static Database? _database;

  DatabaseHelper.internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    String path = join(await getDatabasesPath(), 'restaurant.db');
    var database = await openDatabase(
      path,
      version: 6,
      onCreate: _createDatabase,
      onUpgrade: _onUpgrade,
    );
    return database;
  }

  void _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE favorite_restaurants (
        id TEXT PRIMARY KEY,
        name TEXT,
        address TEXT,
        description TEXT,
        pictureId TEXT,
        city TEXT,
        rating REAL
       
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < newVersion) {
      if (!(await columnExists(db, 'favorite_restaurants', 'pictureId'))) {
        await db.execute(
            'ALTER TABLE favorite_restaurants ADD COLUMN pictureId TEXT');
      }

      if (!(await columnExists(db, 'favorite_restaurants', 'city'))) {
        await db
            .execute('ALTER TABLE favorite_restaurants ADD COLUMN city TEXT');
      }

      if (!(await columnExists(db, 'favorite_restaurants', 'rating'))) {
        await db
            .execute('ALTER TABLE favorite_restaurants ADD COLUMN rating REAL');
      }
    }
  }

  Future<bool> columnExists(Database db, String table, String column) async {
    List<Map<String, dynamic>> columns = await db.rawQuery(
      "PRAGMA table_info($table)",
    );

    return columns.any((Map<String, dynamic> row) => row['name'] == column);
  }

  Future<int> insertFavoriteRestaurant(Restaurant restaurant) async {
    final db = await database;
    final Map<String, dynamic> restaurantMap = restaurant.toJson();

    restaurantMap['rating'] = restaurantMap['rating'] as double;
    return await db.insert('favorite_restaurants', restaurantMap,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<int> deleteFavoriteRestaurant(String restaurantId) async {
    final db = await database;

    return await db.delete(
      'favorite_restaurants',
      where: 'id = ?',
      whereArgs: [restaurantId],
    );
  }

  Future<List<Restaurant>> getFavoriteRestaurants() async {
    final db = await database;
    final List<Map<String, dynamic>> maps =
        await db.query('favorite_restaurants');
    return List.generate(maps.length, (i) {
      return Restaurant.fromJson(maps[i]);
    });
  }
}
