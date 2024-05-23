import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

///
/// main Tables (customers,products,categories,sales)
///

class SqlHelper {
  Database? db;

  Future<void> createTables() async {
    try {
      await db!.execute("""
      Create table categories(
      id integer primary key,
      name text,
      description text
      )""");
      print('create producst table');
    } catch (e, s) {
      print('error in create categories table $e');
      print('syatck trace $s');
    }
  }

  Future<void> initDb() async {
    try {
      if (kIsWeb) {
        var factory = databaseFactoryFfiWeb;
        db = await factory.openDatabase('pos.db');
        print('=================== Db Created');
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
