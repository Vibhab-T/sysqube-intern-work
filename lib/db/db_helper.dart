import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sysqube_intern/data/models/book_model.dart';
import 'package:sysqube_intern/utils/constants.dart';

/*
MAIN JOB = create the db, create tables, CRUD on faves tables

jastai express ma DbCon schema banayera, chahiney methods haru lekhinthyo, testai nai ho
call these methods anywhere in the app when needed
*/

class DbHelper {
  static final DbHelper instance = DbHelper._init();
  static Database? _database;

  DbHelper._init();

  // database getter function
  // lazy loading the database i.e chaiyeko bela matra load garne, aru bela chaihindaina
  // ensures db only opened once
  Future<Database> get database async{
    if(_database != null) return _database!; 

    //opens db on first access 
    _database = await _initDB(AppConstants.databaseName);
    return _database!;
  }

  // create or open the SQLite database
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath(); //os specific
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: AppConstants.databaseVersion,
      onCreate: _createDB,
    );

    //if not exists then onCreate callback will be called which will then create the database and the table
    //version for migration purposes matra, may not be neccessary here
  }

  // create the database
  // will be hit once only on first app launch or after uninstall
  Future _createDB(Database db, int version) async {
    await db.execute('''
        CREATE TABLE ${AppConstants.favouritesTable} (
          id TEXT PRIMARY KEY,
          title TEXT NOT NULL,
          authors TEXT NOT NULL,
          publishedDate TEXT,
          description TEXT,
          thumbnail TEXT,
          previewLink TEXT
        )
      ''');
  }

  Future<int> addFavourite(Book book) async {
    final db = await database;
    return await db.insert(
      AppConstants.favouritesTable,
      book.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace // if same existrs, replace it
    );
  }

  Future<List<Book>> getFavourites() async {
    final db = await database;
    final result = await db.query(AppConstants.favouritesTable); // SELECT * FROM favouritesTable;
    return result.map((json) => Book.fromMap(json)).toList();
  }

  Future<bool> isFavourite(String id) async {
    final db = await database;
    final result = await db.query( //SELECT * FROM favouritesTable WHERE id=id;
      AppConstants.favouritesTable,
      where: 'id = ?',
      whereArgs: [id] // no sql injhection
    );

    return result.isNotEmpty;
  }

  Future<int> removeFavourite(String id) async {
    final db = await database;
    return await db.delete( //DELETE
      AppConstants.favouritesTable,
      where: 'id = ?',
      whereArgs: [id]
    );
  }

  Future close() async {
    final db = await database;
    db.close();
  }
}

/*
HOW WORKS?:

1. Adding to fave
ui -> controller -> DbHelper -> SQLite
Book object -> toMap()

2. Reading from face
SQLite -> DbHelper -> Controller -> ui
Map -> fromMap() -> Book object

UI speak book object
DB speak Map
This class translator
*/