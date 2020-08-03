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
        this.logo =
            'https://freeiconshop.com/wp-content/uploads/edd/apple-outline-filled.png';
}
