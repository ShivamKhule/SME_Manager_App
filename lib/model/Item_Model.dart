class Item {
  String name;
  double amount;
  double paid;
  double totalAmount;
  String date;

  Item({
    required this.name,
    required this.amount,
    required this.paid,
    required this.totalAmount,
    required this.date,
  });

  // Factory constructor for creating an Item object from Firestore data
  factory Item.fromFirestore(Map<String, dynamic> data) {
    return Item(
      name: data['name'] ?? '',
      amount: (data['amount'] ?? 0).toDouble(),
      paid: (data['paid'] ?? 0).toDouble(),
      totalAmount: (data['totalAmount'] ?? 0).toDouble(),
      date: data['date'] ?? '',
    );
  }

  // Method to convert an Item object to a Map for Firestore storage
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'amount': amount,
      'paid': paid,
      'totalAmount': totalAmount,
      'date': date,
    };
  }
}



/*class Item {
  final String name;
  final int amount;
  final String date;
  final int paid;
  final int totalAmount;

  Item({
    required this.name,
    required this.amount,
    required this.date,
    required this.paid,
    required this.totalAmount,
  });

  // Factory method to create an Item from a Firestore document
  factory Item.fromFirestore(Map<String, dynamic> data) {
    return Item(
      name: data['name'],
      amount: data['amount'],
      date: data['date'],
      paid: data['paid'],
      totalAmount: data['totalAmount'],
    );
  }

  @override
  String toString() {
    return 'Item(name: $name, amount: $amount, date: $date, paid: $paid, totalAmount: $totalAmount)';
  }
}
*/