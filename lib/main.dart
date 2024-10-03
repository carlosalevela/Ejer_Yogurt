import 'package:flutter/material.dart';
import 'package:bd_yogurt/database_helper.dart';
import 'package:bd_yogurt/yogurt.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Yogurt Inventory',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const YogurtListScreen(),
    );
  }
}

class YogurtListScreen extends StatefulWidget {
  const YogurtListScreen({super.key});

  @override
  State<YogurtListScreen> createState() => _YogurtListScreenState();
}

class _YogurtListScreenState extends State<YogurtListScreen> {
  final _dbHelper = DatabaseHelper.instance;
  List<Yogurt> _yogurts = [];

  @override
  void initState() {
    super.initState();
    _loadYogurts();
  }

  Future<void> _loadYogurts() async {
    final yogurtMaps = await _dbHelper.getYogurts();
    setState(() {
      _yogurts = yogurtMaps.map((map) => Yogurt.fromMap(map)).toList();
    });
  }

  Future<void> _addYogurt(String description, int quantity) async {
    final yogurt = Yogurt(description: description, quantity: quantity);
    await _dbHelper.insertYogurt(yogurt.toMap());
    _loadYogurts();
  }

  Future<void> _sellYogurt(Yogurt yogurt) async {
    if (yogurt.quantity > 0) {
      yogurt.quantity--;
      yogurt.sold++;
      await _dbHelper.updateYogurt(yogurt.toMap());
      _loadYogurts();
    }
  }

  Future<void> _deleteYogurt(int id) async {
    await _dbHelper.deleteYogurt(id);
    _loadYogurts();
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController descriptionController = TextEditingController();
    final TextEditingController quantityController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Yogurt Inventory'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                hintText: 'Enter yogurt description',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: quantityController,
              decoration: const InputDecoration(
                hintText: 'Enter quantity',
              ),
              keyboardType: TextInputType.number,
            ),
          ),
          ElevatedButton(
            onPressed: () {
              final description = descriptionController.text;
              final quantity = int.tryParse(quantityController.text);
              if (description.isNotEmpty && quantity != null && quantity > 0) {
                _addYogurt(description, quantity);
                descriptionController.clear();
                quantityController.clear();
              }
            },
            child: const Text('Add Yogurt'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _yogurts.length,
              itemBuilder: (context, index) {
                final yogurt = _yogurts[index];
                return ListTile(
                  title: Text(yogurt.description),
                  subtitle: Text(
                      'Quantity: ${yogurt.quantity} | Sold: ${yogurt.sold}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.add_shopping_cart),
                        onPressed: () {
                          _sellYogurt(yogurt);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          _deleteYogurt(yogurt.id!);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
