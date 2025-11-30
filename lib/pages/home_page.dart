import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../providers/cart_provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/product_card.dart';
import 'cart_page.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final products = context.watch<ProductProvider>().products;
    final cart = context.watch<CartProvider>();

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Theme.of(
          context,
        ).colorScheme.surface, 
        statusBarIconBrightness: context.watch<ThemeProvider>().isDark
            ? Brightness.light
            : Brightness.dark,
      ),
      child: Scaffold(
        extendBodyBehindAppBar: false,

        appBar: AppBar(
          toolbarHeight: 72,
          backgroundColor: Theme.of(context).colorScheme.surface,
          surfaceTintColor: Colors.transparent,
          elevation: 1,
          shadowColor: Colors.black12,
          forceMaterialTransparency: false,

          title: Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Text(
              "Modern Interiors",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),

          actions: [
            Stack(
              children: [
                IconButton(
                  icon: const Icon(Icons.shopping_cart_outlined),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const CartPage()),
                    );
                  },
                ),
                if (cart.count > 0)
                  Positioned(
                    right: 6,
                    top: 6,
                    child: Container(
                      height: 16,
                      width: 16,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          cart.count.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),

        body: LayoutBuilder(
          builder: (context, constraints) {
            int crossAxis;

            if (constraints.maxWidth <= 500) {
              crossAxis = 2;
            } else if (constraints.maxWidth <= 900) {
              crossAxis = 3;
            } else {
              crossAxis = 4;
            }

            return Padding(
              padding: EdgeInsets.all(0),
              child: GridView.builder(
                padding: EdgeInsets.all(10),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxis,
                  childAspectRatio: MediaQuery.of(context).size.width > 1000
                      ? 0.95
                      : 1.15,
                  mainAxisExtent: MediaQuery.of(context).size.width > 1000
                      ? 300
                      : 220,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                ),
                itemCount: products.length,
                itemBuilder: (_, i) => ProductCard(product: products[i]),
              ),
            );
          },
        ),

        floatingActionButton: FloatingActionButton(
          onPressed: () {
            context.read<ThemeProvider>().toggleTheme();
          },
          backgroundColor: Colors.teal,
          child: Icon(
            context.watch<ThemeProvider>().isDark
                ? Icons.light_mode
                : Icons.dark_mode,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
