class Product {
  int? id;
  String? name;
  String? description;
  double? price;
  int? stock;
  bool? isAvaliable;
  String? image;
  int? categoryId;
  String? categoryName;
  String? categoryDescription;

  Product();

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    price = json['price'];
    stock = json['stock'];
    isAvaliable = json['isAvaliable'] == 1 ? true : false;
    image = json['image'];
    categoryId = json['categoryId'];
    categoryName = json['categoryName'];
    categoryDescription = json['categoryDescription'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'stock': stock,
      'isAvaliable': isAvaliable,
      'image': image,
      'categoryId': categoryId,
      'categoryName': categoryName,
      'categoryDescription': categoryDescription
    };
  }
}
