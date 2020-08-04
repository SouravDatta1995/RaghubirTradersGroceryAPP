class Product {
  final String name, logo;
  final double price;
  final int productId;

  Product({
    this.productId,
    this.name,
    this.logo,
    this.price,
  });

  Product.fromJson(Map<String, dynamic> json)
      : this.productId = json['productId'],
        this.name = json['Name'],
        this.price = json['BasePrice'],
        this.logo = json['Image'] ??
            'https://freeiconshop.com/wp-content/uploads/edd/apple-outline-filled.png';

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['productId'] = this.productId;
    data['BasePrice'] = this.price;
    data['Name'] = this.name;
    return data;
  }
}