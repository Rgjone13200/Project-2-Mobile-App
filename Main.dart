
import 'package:flutter/material.dart';

void main() {
  runApp(const ShopEasyApp());
}

// MODULE 1: Dart classes and data structures
class Product {
  final String name;
  final double price;
  final String image;

  const Product({
    required this.name,
    required this.price,
    required this.image,
  });
}

const products = <Product>[
  Product(
    name: 'Fresh Apples',
    price: 3.99,
    image:
        'https://images.unsplash.com/photo-1560806887-1e4cd0b6cbd6?w=400',
  ),
  Product(
    name: 'Bananas',
    price: 2.49,
    image:
        'https://images.unsplash.com/photo-1571771894821-ce9b6c11b08e?w=400',
  ),
  Product(
    name: 'Strawberries',
    price: 4.99,
    image:
        'https://images.unsplash.com/photo-1464965911861-746a04b4bca6?w=400',
  ),
  Product(
    name: 'Oranges',
    price: 3.49,
    image:
        'https://images.unsplash.com/photo-1547514701-42782101795e?w=400',
  ),
];

// MODULE 3: App-wide theming
class ShopEasyApp extends StatelessWidget {
  const ShopEasyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ShopEasy',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
        ),
        scaffoldBackgroundColor:
            const Color(0xFFF4F8F4),
        appBarTheme: const AppBarTheme(
          foregroundColor: Colors.white,
          backgroundColor: Colors.green,
        ),
      ),
      home: const ShopHome(),
    );
  }
}

class ShopHome extends StatefulWidget {
  const ShopHome({super.key});

  @override
  State<ShopHome> createState() => _ShopHomeState();
}

class _ShopHomeState extends State<ShopHome> {
  String search = '';
  double maxPrice = 10;
  bool darkMode = false;

  // Store selected items using a Dart list.
  final List<Product> cart = [];

  // MODULE 1: Functions implement application logic.
  void addToCart(Product product) {
    setState(() {
      cart.add(product);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.name} added to cart'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  double get cartTotal {
    return cart.fold(
      0.0,
      (total, product) => total + product.price,
    );
  }

  // Open the shopping cart dialog.
  void showCart() {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('My Shopping Cart'),
          content: SizedBox(
            width: 350,
            child: cart.isEmpty
                ? const Text('Your cart is empty.')
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ConstrainedBox(
                        constraints:
                            const BoxConstraints(maxHeight: 240),
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: cart.length,
                          itemBuilder: (context, index) {
                            final item = cart[index];
                            return ListTile(
                              title: Text(item.name),
                              trailing: Text(
                                '\$${item.price.toStringAsFixed(2)}',
                              ),
                            );
                          },
                        ),
                      ),
                      const Divider(),
                      Text(
                        'Total: \$${cartTotal.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 19,
                        ),
                      ),
                    ],
                  ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Close'),
            ),
            if (cart.isNotEmpty)
              TextButton(
                onPressed: () {
                  setState(() {
                    cart.clear();
                  });
                  Navigator.pop(dialogContext);
                },
                child: const Text('Clear Cart'),
              ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = products.where((product) {
      return product.name
              .toLowerCase()
              .contains(search.toLowerCase()) &&
          product.price <= maxPrice;
    }).toList();

    final theme = darkMode
        ? ThemeData.dark(useMaterial3: true)
        : ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.green,
            ),
            scaffoldBackgroundColor:
                const Color(0xFFF4F8F4),
          );

    return Theme(
      data: theme,
      child: Scaffold(
        // MODULE 2: Navigation Drawer
        drawer: Drawer(
          child: ListView(
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.green,
                      Colors.lightGreen,
                    ],
                  ),
                ),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    'ShopEasy Menu',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.home),
                title: const Text('Home'),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: const Icon(Icons.shopping_cart),
                title: const Text('My Cart'),
                onTap: () {
                  Navigator.pop(context);
                  showCart();
                },
              ),
              SwitchListTile(
                title: const Text('Dark Mode'),
                secondary: const Icon(Icons.dark_mode),
                value: darkMode,
                onChanged: (value) {
                  setState(() {
                    darkMode = value;
                  });
                },
              ),
              const Divider(),
              const ListTile(
                leading: Icon(Icons.info_outline),
                title: Text('About ShopEasy'),
                subtitle: Text(
                  'Flutter Advanced UI Final Project',
                ),
              ),
            ],
          ),
        ),

        // MODULE 5: Slivers and advanced scrolling
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 180,
              pinned: true,
              stretch: true,
              foregroundColor: Colors.white,
              backgroundColor: Colors.green.shade700,
              title: const Text(
                'ShopEasy',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              actions: [
                IconButton(
                  tooltip: 'Open shopping cart',
                  onPressed: showCart,
                  icon: Badge(
                    label: Text('${cart.length}'),
                    child: const Icon(
                      Icons.shopping_cart,
                    ),
                  ),
                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.green.shade800,
                        Colors.lightGreen.shade400,
                      ],
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.fromLTRB(
                      24, 85, 24, 16,
                    ),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        'Fresh groceries,\nmade simple!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    // MODULE 4: Entrance animation
                    TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0, end: 1),
                      duration: const Duration(
                        milliseconds: 900,
                      ),
                      builder: (context, value, child) {
                        return Opacity(
                          opacity: value,
                          child: Transform.translate(
                            offset: Offset(
                              0,
                              25 * (1 - value),
                            ),
                            child: child,
                          ),
                        );
                      },
                      child: Card(
                        elevation: 5,
                        child: Padding(
                          padding:
                              const EdgeInsets.all(18),
                          child: Row(
                            children: [
                              Icon(
                                Icons.local_grocery_store,
                                color: Colors.green.shade600,
                                size: 45,
                              ),
                              const SizedBox(width: 14),
                              const Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Welcome to ShopEasy!',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight:
                                            FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      'Find your favorite groceries.',
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // MODULE 2: Interactive text field
                    TextField(
                      onChanged: (value) {
                        setState(() => search = value);
                      },
                      decoration: InputDecoration(
                        hintText: 'Search groceries...',
                        prefixIcon:
                            const Icon(Icons.search),
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(16),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // MODULE 3: Interactive price slider
                    Text(
                      'Maximum Price: '
                      '\$${maxPrice.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    Slider(
                      value: maxPrice,
                      min: 0,
                      max: 10,
                      divisions: 20,
                      label:
                          '\$${maxPrice.toStringAsFixed(2)}',
                      onChanged: (value) {
                        setState(() => maxPrice = value);
                      },
                    ),

                    const SizedBox(height: 10),

                    // MODULE 5: Typography
                    const Text(
                      'Popular Products',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // MODULE 5: Responsive SliverGrid
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                16, 0, 16, 24,
              ),
              sliver: SliverLayoutBuilder(
                builder: (context, constraints) {
                  final width =
                      constraints.crossAxisExtent;
                  final columns = width >= 700 ? 3 : 2;

                  return SliverGrid(
                    gridDelegate:
                        SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: columns,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      mainAxisExtent: 275,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return ProductCard(
                          product: filtered[index],
                          onAdd: () {
                            addToCart(filtered[index]);
                          },
                        );
                      },
                      childCount: filtered.length,
                    ),
                  );
                },
              ),
            ),

            if (filtered.isEmpty)
              const SliverToBoxAdapter(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: Text(
                      'No matching products found.',
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// MODULE 4: Images, shadows and button animations
class ProductCard extends StatefulWidget {
  final Product product;
  final VoidCallback onAdd;

  const ProductCard({
    super.key,
    required this.product,
    required this.onAdd,
  });

  @override
  State<ProductCard> createState() =>
      _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool pressed = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: pressed ? 0.96 : 1,
      duration: const Duration(
        milliseconds: 180,
      ),
      child: GestureDetector(
        onTapDown: (_) {
          setState(() => pressed = true);
        },
        onTapUp: (_) {
          setState(() => pressed = false);
        },
        onTapCancel: () {
          setState(() => pressed = false);
        },
        child: Card(
          elevation: 5,
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius:
                      BorderRadius.circular(12),
                  child: Image.network(
                    widget.product.image,
                    height: 140,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    cacheWidth: 500,
                    errorBuilder:
                        (context, error, stackTrace) {
                      return Container(
                        height: 140,
                        color: Colors.green.shade50,
                        child: const Center(
                          child: Icon(
                            Icons.broken_image,
                            size: 40,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  widget.product.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '\$${widget.product.price.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: widget.onAdd,
                    icon: const Icon(Icons.add),
                    label: const Text('Add'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
