import 'package:easy_pos/helpers/sql_helper.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: () async {
        var sqlHelper = SqlHelper();
        await sqlHelper.initDb();

        if (sqlHelper.db == null) {
          print('Error: unable to open database');
          return;
        }

        await sqlHelper.createTables();
      }),
    );
  }
}
