import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

///
/// main Tables (customers,products,categories,sales)
///

class SqlHelper {
  Database? db;

  Future<bool> createTables() async {
    try {
      var batch = db!.batch();

      batch.execute("""
      Create table If not exists categories(
      id integer primary key,
      name text not null,
      description text not null
      )""");
      batch.execute("""
      Create table If not exists products(
      id integer primary key,
      name text,
      description text,
      price double,
      stock integer,
      isAvaliable boolean,
      image text,
      categoryId integer,
      foreign key(categoryId) references categories(id)
      ON Delete restrict
      )""");
      batch.execute("""
      Create table If not exists clients(
      id integer primary key,
      name text,
      email text,
      phone text,
      address text
      )""");

      var result = await batch.commit();

      print('tables Created Successfully: $result');
      return true;
    } catch (e) {
      print('error in create tables $e');
      return false;
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
