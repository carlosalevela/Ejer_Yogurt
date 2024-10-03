class Yogurt {
  int? id;
  String description;
  int quantity;
  int sold;

  Yogurt({
    this.id,
    required this.description,
    required this.quantity,
    this.sold = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'description': description,
      'quantity': quantity,
      'sold': sold,
    };
  }

  factory Yogurt.fromMap(Map<String, dynamic> map) {
    return Yogurt(
      id: map['id'],
      description: map['description'],
      quantity: map['quantity'],
      sold: map['sold'],
    );
  }
}
