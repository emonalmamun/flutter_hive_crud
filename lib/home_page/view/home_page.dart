import 'package:flutter/material.dart';
import 'package:flutter_hive_crud/home_page/controller/home_controller.dart';
import 'package:flutter_hive_crud/utils/local_db/db_controller.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  final dbController = Get.put(DbController());
  final homeController = Get.find<HomeController>();
  /*const*/ HomePage({super.key});

  // TextFields' controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hive CRUD'),
      ),
      body: Obx((){
        return dbController.items.isEmpty ?
        const Center(
          child: Text(
            'No Data',
            style: TextStyle(fontSize: 30),
          ),
        )
            :
        ListView.builder(
          // the list of items
            itemCount: dbController.items.length,
            itemBuilder: (_, index) {
              final currentItem = dbController.items[index];
              return Card(
                color: Colors.blue.shade100,
                margin: const EdgeInsets.all(10),
                elevation: 3,
                child: ListTile(
                    title: Text(currentItem['name']),
                    subtitle: Text(currentItem['quantity'].toString()),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Edit button
                        IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () => _showForm(context, currentItem['key'])),
                        // Delete button
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => dbController.deleteItem(currentItem['key']),
                        ),
                      ],
                    )),
              );
            });
      }),
      // Add new item button
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showForm(context, null),
        child: const Icon(Icons.add),
      ),
    );
  }

  // This function will be triggered when the floating button is pressed
  // It will also be triggered when you want to update an item
  void _showForm(BuildContext ctx, int? itemKey) async {
    // itemKey == null -> create new item
    // itemKey != null -> update an existing item

    if (itemKey != null) {
      final existingItem =
      dbController.items.firstWhere((element) => element['key'] == itemKey);
      _nameController.text = existingItem['name'];
      _quantityController.text = existingItem['quantity'];
    }

    showModalBottomSheet(
        context: ctx,
        elevation: 5,
        isScrollControlled: true,
        builder: (_) => Container(
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(ctx).viewInsets.bottom,
              top: 15,
              left: 15,
              right: 15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(hintText: 'Name'),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: _quantityController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(hintText: 'Quantity'),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () async {
                  // Save new item
                  if (itemKey == null) {
                    dbController.createItem({
                      "name": _nameController.text,
                      "quantity": _quantityController.text
                    });
                  }

                  // update an existing item
                  if (itemKey != null) {
                    dbController.updateItem(itemKey, {
                      'name': _nameController.text.trim(),
                      'quantity': _quantityController.text.trim()
                    });
                  }

                  // Clear the text fields
                  _nameController.text = '';
                  _quantityController.text = '';

                  Navigator.of(Get.context!).pop(); // Close the bottom sheet
                },
                child: Text(itemKey == null ? 'Create New' : 'Update'),
              ),
              const SizedBox(
                height: 15,
              )
            ],
          ),
        ));
  }
}
