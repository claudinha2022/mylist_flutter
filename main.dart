import 'package:flutter/material.dart';
import 'carrinho.dart';
import 'produtos.dart';
import 'dart:ui';

void main() async {
  runApp(MyListApp());
}

class MyListApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyListScreen(),
      routes: {
        '/carrinho': (context) => CarrinhoScreen(
              cartItems: [],
              selectedProducts: [],
            ), // Defina a rota para a tela do carrinho de compras
        '/produtos': (context) =>
            ProdutosScreen(), // Defina a rota para a tela de produtos
      },
    );
  }
}

class MyListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Minha lista'),
        backgroundColor: Color.fromARGB(
            255, 25, 143, 68), // Use the desired color here (WhatsApp green)
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 25, 143, 68),
              Color.fromARGB(255, 35, 180, 85),
            ],
          ),
        ),
        child: Center(
          child: Container(
            margin: EdgeInsets.only(top: 100),
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    // Navegue para a tela de produtos quando o ícone for clicado
                    Navigator.pushNamed(context, '/produtos');
                  },
                  child: buildIconWithText(
                    icon: Icons.shopping_bag_outlined,
                    color: Colors.white,
                    text: 'Produtos',
                  ),
                ),
                SizedBox(height: 20), // Espaçamento entre os ícones
                InkWell(
                  onTap: () {
                    // Navegue para a tela do carrinho de compras quando o ícone for clicado
                    Navigator.pushNamed(context, '/carrinho');
                  },
                  child: buildIconWithText(
                    icon: Icons.shopping_cart_outlined,
                    color: Colors.white,
                    text: 'Lista de Compras',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildIconWithText({
    required IconData icon,
    required Color color,
    required String text,
  }) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.transparent,
            shape: BoxShape.circle,
            border: Border.all(color: color, width: 3),
          ),
          child: Icon(
            icon,
            size: 50,
            color: color,
          ),
        ),
        SizedBox(height: 10),
        // Wrap the Icon and Text widgets inside a Row and set mainAxisAlignment to center.
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
