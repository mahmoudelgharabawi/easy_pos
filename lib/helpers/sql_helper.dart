import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

///
/// main Tables (customers,products,categories,sales)
///

class SqlHelper {
  Database? db;

  SqlHelper() {
    initDb();
  }

  void createTables() async {
    await db!.execute("""
  Create table if not exists products(
  id integer primary key,
  name text not null,
  description text not null,
  price real not null,
  stock integer not null,
  categoryId integer not null,
)""");
  }

  void initDb() async {
    try {
      if (kIsWeb) {
        var factory = databaseFactoryFfiWeb;
        db = await factory.openDatabase('pos.db');
      } else {
        db = await openDatabase(
          'pos.db',
          version: 1,
          onCreate: (db, version) {
            print('=================== Db Created');
          },
        );
      }
    } catch (e) {
      print('error in create db : ${e}');
    }
  }
}
