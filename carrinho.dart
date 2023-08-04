import 'package:flutter/material.dart';
import 'package:mylist/interface/cart.dart';
import 'interface/product.dart';




class CarrinhoScreen extends StatefulWidget {
  final List<Product> selectedProducts;

  CarrinhoScreen({required this.selectedProducts, required List cartItems});

  @override
  _CarrinhoScreenState createState() => _CarrinhoScreenState();
}

class _CarrinhoScreenState extends State<CarrinhoScreen> {
  final List<Cart> cartItems = [];

  @override
  void initState() {
    super.initState();
    _addSelectedProductsToCart();
  }

  void _addSelectedProductsToCart() {
    // Convert selected products to Cart items and add to the cartItems list
    for (var product in widget.selectedProducts) {
      final cartItem = Cart(
        name: product.name,
        quantity: 1, // You can set a default quantity here if needed
        isPurchased: false, // Assuming the initial state is not purchased
      );
      cartItems.add(cartItem);
    }
  }

  void _editarItem(BuildContext context, Cart product, int index) {
    String newName = product.name;
    int newQuantity = product.quantity;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Editar Item'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) {
                  newName = value;
                },
                decoration: InputDecoration(labelText: 'Nome do item'),
                controller: TextEditingController(text: product.name),
              ),
              SizedBox(height: 16),
              TextField(
                onChanged: (value) {
                  newQuantity = int.tryParse(value) ?? 1;
                },
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Quantidade'),
                controller:
                    TextEditingController(text: product.quantity.toString()),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  cartItems[index].edit(newName, newQuantity);
                  Navigator.pop(context);
                });
              },
              child: Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  void _excluirItem(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Excluir Item'),
          content: Text('Deseja realmente excluir ${cartItems[index].name}?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  cartItems.removeAt(index);
                  Navigator.pop(context);
                });
              },
              child: Text('Excluir'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Compras'),
        backgroundColor: Colors.green,
      ),
      body: Container(
        color: Color.fromARGB(
            255, 25, 143, 68), // Set the background color of the body
        child: ListView.builder(
          itemCount: cartItems.length,
          itemBuilder: (context, index) {
           
            return Card(
              elevation:
                  3, // Add some elevation to the card for a raised effect
              child: ListTile(
                title: Text(cartItems[index].name,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    decoration: cartItems[index].isPurchased
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                  ),
                ),
                subtitle: Text(
                  'Quantidade: ${cartItems[index].quantity}',
                  style: TextStyle(fontSize: 16),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.remove, color: Colors.red),
                      onPressed: () {
                        setState(() {
                          if (cartItems[index].quantity > 1) {
                            cartItems[index].quantity--;
                          }
                        });
                      },
                    ),
                    Text(
                      cartItems[index].quantity.toString(),
                      style: TextStyle(fontSize: 18),
                    ),
                    IconButton(
                      icon: Icon(Icons.add, color: Colors.green),
                      onPressed: () {
                        setState(() {
                          cartItems[index].quantity++;
                        });
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.edit, color: Colors.blue),
                      onPressed: () {
                        _editarItem(context, cartItems[index], index);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        _excluirItem(context, index);
                      },
                    ),
                    IconButton(
                      icon: Icon(
                        cartItems[index].isPurchased
                            ? Icons.check_box
                            : Icons.check_box_outline_blank,
                        color: cartItems[index].isPurchased
                            ? Colors.green
                            : Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          cartItems[index].isPurchased =
                              !cartItems[index].isPurchased;
                        });
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: Stack(
        alignment: Alignment.bottomRight,
        children: [
          FloatingActionButton(
            onPressed: () {
              _adicionarItem();
            },
            child: Icon(Icons.add),
            backgroundColor: Colors.blue,
          ),
        ],
      ),
    );
  }
}

class _adicionarItem {
}
