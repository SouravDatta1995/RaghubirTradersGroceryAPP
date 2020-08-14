class RazorPayOptions {
  String id;
  String entity;
  double amount;
  double amountPaid;
  double amountDue;
  String currency;
  String receipt;
  String status;

  RazorPayOptions(
      {this.id,
      this.entity,
      this.amount,
      this.amountPaid,
      this.amountDue,
      this.currency,
      this.receipt,
      this.status});

  RazorPayOptions.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    entity = json['entity'];
    amount = double.parse(json['amount'].toString());
    amountPaid = double.parse(json['amount_paid'].toString());
    amountDue = double.parse(json['amount_due'].toString());
    currency = json['currency'];
    receipt = json['receipt'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['entity'] = this.entity;
    data['amount'] = this.amount;
    data['amount_paid'] = this.amountPaid;
    data['amount_due'] = this.amountDue;
    data['currency'] = this.currency;
    data['receipt'] = this.receipt;
    data['status'] = this.status;
    return data;
  }
}
