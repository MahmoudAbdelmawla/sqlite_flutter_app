import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:sqlite_flutter_app/model/dish.dart';

class DBHelper{
  static late Database _database;
  static String _databaseName = 'dishesDb.db';
  static String _tableName = 'Dishes';

  static initDB() async{
    String databasePath = await getDatabasesPath();
    String path = join(databasePath,_databaseName);
    _database = await openDatabase(path,version: 1,onCreate: onCreate);
    return _database;
  }

  static void onCreate(Database database ,int version) async{
    await database.execute('CREATE TABLE $_tableName(name TEXT, description TEXT, price DOUBLE)');
  }

  Future<Database> get database async{
    if(_database == null){
      _database = await initDB();
    }
    return _database;
  }
  
  // Create Data
   Future<int> createDish(Dish dish) async{
    return await _database
        .rawInsert("INSERT INTO $_tableName(name, description, price) VALUES ('${dish.name}', '${dish.description}', '${dish.price}')");
  }

  // Update Data
  Future<int> updateDish(Dish dish) async{
    return await _database
        .rawInsert("UPDATE $_tableName SET description = '${dish.description}', price = '${dish.price}' WHERE name = '${dish.name}'");
  }

  // Read Data
  Future<Dish> readDish(String name)async{
    List dishes =  await _database.rawQuery("SELECT * FROM $_tableName WHERE name = '$name'");
    return Dish.fromMap(dishes[0]);
  }

  // Read All Data
  Future<List<Dish>> readAllDish()async{
    List<Map> list =  await _database.rawQuery("SELECT * FROM $_tableName");
    List<Dish> dishes = [];
    for (var dish in list) {
      dishes.add(Dish(name: dish['name'],description: dish['description'],price: dish['price']));
    }
    return dishes;
  }

  // Delete Data
  Future<int> deleteDish(String name) async{
    return await _database.rawInsert("DELETE FROM $_tableName WHERE name = '$name'");
  }

}