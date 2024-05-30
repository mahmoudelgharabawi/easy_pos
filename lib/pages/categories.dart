import 'package:data_table_2/data_table_2.dart';
import 'package:easy_pos/helpers/sql_helper.dart';
import 'package:easy_pos/models/category.dart';
import 'package:easy_pos/pages/categories_ops.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  List<Category>? categories;

  @override
  void initState() {
    getCategories();
    super.initState();
  }

  void getCategories() async {
    try {
      var sqlHelper = GetIt.I.get<SqlHelper>();
      var data = await sqlHelper.db!.query('categories');

      if (data.isNotEmpty) {
        for (var item in data) {
          categories ??= [];
          categories?.add(Category.fromJson(item));
        }
      } else {
        categories = [];
      }
      setState(() {});
    } catch (e) {
      print('Error in get Categories $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (ctx) => CategoriesOpsPage()));
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Theme(
          data: Theme.of(context).copyWith(
            iconTheme: const IconThemeData(color: Colors.black, size: 26),
          ),
          child: PaginatedDataTable2(
            onPageChanged: (index) {
              // print
            },
            // availableRowsPerPage: const <int>[1],
            hidePaginator: false,
            empty: const Center(
              child: Text('No Data Found'),
            ),
            minWidth: 600,
            fit: FlexFit.tight,
            isHorizontalScrollBarVisible: true,
            rowsPerPage: 15,
            horizontalMargin: 20,
            checkboxHorizontalMargin: 12,
            columnSpacing: 20,
            wrapInCard: false,
            renderEmptyRowsInTheEnd: false,
            headingTextStyle:
                const TextStyle(color: Colors.white, fontSize: 18),
            headingRowColor:
                MaterialStatePropertyAll(Theme.of(context).primaryColor),
            border: TableBorder.all(color: Colors.black),
            columns: const [
              DataColumn(label: Text('Id')),
              DataColumn(label: Text('Name')),
              DataColumn(label: Text('Description')),
              DataColumn(label: Text('Actions')),
            ],
            source: DataSource(categories),
          ),
        ),
      ),
    );
  }
}

class DataSource extends DataTableSource {
  List<Category>? categories;
  DataSource(this.categories);
  @override
  DataRow? getRow(int index) {
    return DataRow2(cells: [
      DataCell(Text('${categories?[index].id}')),
      DataCell(Text('${categories?[index].name}')),
      DataCell(Text('${categories?[index].description}')),
      DataCell(Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(
              Icons.delete,
              color: Colors.red,
            ),
            onPressed: () {},
          ),
        ],
      )),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => categories?.length ?? 0;

  @override
  int get selectedRowCount => 0;
}
