import 'package:easy_pos/helpers/sql_helper.dart';
import 'package:easy_pos/models/order.dart';
import 'package:easy_pos/models/order_item.dart';
import 'package:easy_pos/models/product.dart';
import 'package:easy_pos/widgets/app_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:sqflite/sqflite.dart';

class SaleOpsPage extends StatefulWidget {
  final Order? order;
  const SaleOpsPage({this.order, super.key});

  @override
  State<SaleOpsPage> createState() => _NewSalePageState();
}

class _NewSalePageState extends State<SaleOpsPage> {
  List<Product>? products;
  List<OrderItem>? selectedOrderItems;
  void getProducts() async {
    try {
      var sqlHelper = GetIt.I.get<SqlHelper>();
      var data = await sqlHelper.db!.rawQuery("""
  Select P.*,C.name as categoryName,C.description as categoryDescription from products P
  Inner JOIN categories C
  On P.categoryId = C.id
  """);

      if (data.isNotEmpty) {
        products = [];
        for (var item in data) {
          products?.add(Product.fromJson(item));
        }
      } else {
        products = [];
      }
    } catch (e) {
      products = [];
      print('Error in get Products $e');
    }
    setState(() {});
  }

  String? orderLabel;
  @override
  void initState() {
    initPage();
    super.initState();
  }

  void initPage() {
    getProducts();
    orderLabel = widget.order == null
        ? '#OR${DateTime.now().millisecondsSinceEpoch}'
        : widget.order?.label;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.order == null ? 'Add New Sale' : 'Update Sale'),
      ),
      body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Label : $orderLabel',
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16.0,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          color: Colors.red,
                          child: Text('TODO : add client drop here'),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            IconButton(
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (ctx) {
                                        return StatefulBuilder(
                                            builder: (context, setStateEx) {
                                          return Dialog(
                                            child: (products?.isEmpty ?? false)
                                                ? const Center(
                                                    child:
                                                        Text('No Data Found'))
                                                : Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Column(
                                                      children: [
                                                        Expanded(
                                                          child: ListView(
                                                            children: [
                                                              for (var product
                                                                  in products!)
                                                                ListTile(
                                                                  subtitle: getOrderItem(
                                                                              product.id!) !=
                                                                          null
                                                                      ? Row(
                                                                          children: [
                                                                            IconButton(
                                                                                onPressed: () {
                                                                                  if (getOrderItem(product.id!)!.productCount == 0) return;
                                                                                  getOrderItem(product.id!)!.productCount = getOrderItem(product.id!)!.productCount! - 1;

                                                                                  setStateEx(() {});
                                                                                },
                                                                                icon: const Icon(Icons.remove)),
                                                                            Text('${getOrderItem(product.id!)?.productCount}'),
                                                                            IconButton(
                                                                                onPressed: () {
                                                                                  if (getOrderItem(product.id!)!.productCount == getOrderItem(product.id!)!.product!.stock) return;
                                                                                  getOrderItem(product.id!)!.productCount = getOrderItem(product.id!)!.productCount! + 1;

                                                                                  setStateEx(() {});
                                                                                },
                                                                                icon: const Icon(Icons.add)),
                                                                          ],
                                                                        )
                                                                      : SizedBox(),
                                                                  leading: Image
                                                                      .network(
                                                                          product.image ??
                                                                              ''),
                                                                  title: Text(product
                                                                          .name ??
                                                                      'No name'),
                                                                  trailing:
                                                                      IconButton(
                                                                          onPressed:
                                                                              () {
                                                                            if (getOrderItem(product.id!) !=
                                                                                null) {
                                                                              onRemoveOrderItem(product.id!);
                                                                            } else {
                                                                              onAddOrderItem(product);
                                                                            }
                                                                            setStateEx(() {});
                                                                          },
                                                                          icon: getOrderItem(product.id!) == null
                                                                              ? const Icon(Icons.add)
                                                                              : const Icon(Icons.delete)),
                                                                )
                                                            ],
                                                          ),
                                                        ),
                                                        AppElevatedButton(
                                                            label: 'Back',
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            })
                                                      ],
                                                    ),
                                                  ),
                                          );
                                        });
                                      });
                                  setState(() {});
                                },
                                icon: const Icon(
                                  Icons.add,
                                  color: Colors.black,
                                )),
                            const Text(
                              'Add Products',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 16.0,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        const Text('Order Items',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 16.0,
                            )),
                        for (var orderItem in selectedOrderItems ?? [])
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: ListTile(
                              leading:
                                  Image.network(orderItem.product.image ?? ''),
                              title: Text(
                                  '${orderItem.product.name ?? 'No name'},${orderItem.productCount}X'),
                              trailing: Text(
                                  '${orderItem.productCount * orderItem.product.price}'),
                            ),
                          ),
                        Container(
                          color: Colors.red,
                          child: Text('TODO : add discount textfield'),
                        ),
                        Text(
                          'Total Price:${calculateTotalPrice}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                AppElevatedButton(
                    label: 'Add Order',
                    onPressed: () async {
                      await onSetOrder();
                    })
              ],
            ),
          )),
    );
  }

  Future<void> onSetOrder() async {
    try {
      if (selectedOrderItems == null ||
          (selectedOrderItems?.isEmpty ?? false)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text(
              'You Must Add Order Items First',
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
        return;
      }

      var sqlHelper = GetIt.I.get<SqlHelper>();

      var orderId = await sqlHelper.db!
          .insert('orders', conflictAlgorithm: ConflictAlgorithm.replace, {
        'label': orderLabel,
        'totalPrice': calculateTotalPrice,
        'discount': 0,
        'clientId': 1
      });

      var batch = sqlHelper.db!.batch();
      for (var orderItem in selectedOrderItems!) {
        batch.insert('orderProductItems', {
          'orderId': orderId,
          'productId': orderItem.productId,
          'productCount': orderItem.productCount,
        });
      }
      var result = await batch.commit();

      print('>>>>>>>> orderProductItems${result}');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green,
          content: Text(
            'Order Created Successfully',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            'Error : $e',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }
  }

  OrderItem? getOrderItem(int productId) {
    for (var orderItem in selectedOrderItems ?? []) {
      if (orderItem.productId == productId) {
        return orderItem;
      }
    }
    return null;
  }

  double? get calculateTotalPrice {
    var totalPrice = 0.0;
    for (var orderItem in selectedOrderItems ?? []) {
      totalPrice = totalPrice +
          (orderItem?.productCount ?? 0) * (orderItem?.product?.price ?? 0);
    }
    return totalPrice;
  }

  void onRemoveOrderItem(int productId) {
    for (var i = 0; i < (selectedOrderItems?.length ?? 0); i++) {
      if (selectedOrderItems![i].productId == productId) {
        selectedOrderItems!.removeAt(i);
      }
    }
  }

  void onAddOrderItem(Product product) {
    var orderItem = OrderItem();
    orderItem.product = product;
    orderItem.productCount = 1;
    orderItem.productId = product.id;
    selectedOrderItems ??= [];
    selectedOrderItems!.add(orderItem);
    setState(() {});
  }
}
