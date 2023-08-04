class Cart {
  String name;
  int quantity;
  bool isPurchased;

  Cart({required this.name, required this.quantity, required this.isPurchased});

  void edit(String newName, int newQuantity) {
    name = newName;
    quantity = newQuantity;
  }
}

void delete() {
  // Add any additional logic before removing the item (not needed for this example).
}

// void markAsPurchased() {
//  var isPurchased = true;
//}

//void markAsNotPurchased() {
//  var isPurchased = false;
//}
