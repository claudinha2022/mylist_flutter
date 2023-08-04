import 'package:flutter/material.dart';
import 'package:mylist/utils/database.dart';
import 'package:sembast/sembast.dart';
import 'carrinho.dart';
import 'interface/product.dart';

class ProdutosScreen extends StatefulWidget {
  @override
  _ProdutosScreenState createState() => _ProdutosScreenState();
}


class _ProdutosScreenState extends State<ProdutosScreen> {
  final List<Product> products = [];
  final List<Product> cartItems = [];
  final _productController = TextEditingController();
  final _priceController = TextEditingController();

  final _productsStore = intMapStoreFactory.store('products');

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  @override
  void dispose() {
    _productController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _loadProducts() async {
    final database = await openDatabase();
    final records = await _productsStore.find(database);
    final products = records.map((record) {
      return Product.fromMap(record.value);
    }).toList();
    await database.close();

    setState(() {
      this.products.addAll(products);
    });
  }

  void _addToCartHandler(Product product) {
    setState(() {
      cartItems.add(product);
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CarrinhoScreen(selectedProducts: cartItems, cartItems: [],),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Produtos'),
        backgroundColor: Color.fromARGB(255, 25, 143, 68),
      ),
      body: Container(
        color: Color.fromARGB(255, 25, 143, 68),
        child: ListView.builder(
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return Card(
              color: Colors.white,
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: ListTile(
                title: Text(
                  product.name,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  'Price: \$${product.price.toStringAsFixed(2)}',
                  style: TextStyle(color: Colors.black),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit, color: Colors.amber),
                      onPressed: () {
                        _showEditDialog(context, product, index);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        _showDeleteDialog(context, product);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.shopping_cart, color: Colors.blue),
                      onPressed: () {
                        _addToCartHandler(product);
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddProductDialog(context);
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _showEditDialog(BuildContext context, Product product, int index) {
    // Implementar o diálogo de edição aqui
  }

  void _showDeleteDialog(BuildContext context, Product product) {
    // Implementar o diálogo de exclusão aqui
  }

  Future<void> _showAddProductDialog(BuildContext context) async {
    String newProductName = '';
    double newProductPrice = 0.0;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Adicionar novo ítem'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _productController,
                onChanged: (value) {
                  newProductName = value;
                },
                decoration: InputDecoration(labelText: 'Descrição'),
              ),
              TextField(
                controller: _priceController,
                onChanged: (value) {
                  newProductPrice = double.tryParse(value) ?? 0.0;
                },
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Valor'),
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
              onPressed: () async {
                // Implementar funcionalidade de adicionar produto aqui
                if (newProductName.isNotEmpty && newProductPrice > 0.0) {
                  final newProduct = Product(
                    id: DateTime.now().millisecondsSinceEpoch, // Gerar id único
                    name: newProductName,
                    price: newProductPrice,
                  );
                  setState(() {
                    products.add(newProduct);
                  });
                  await saveProduct(
                      newProduct); // Salvar o novo produto no banco de dados local
                  _addToCartHandler(
                      newProduct); // Adicionar o novo produto ao carrinho
                }
                Navigator.pop(context);
              },
              child: Text('Gravar'),
            ),
          ],
        );
      },
    );
  }
}
