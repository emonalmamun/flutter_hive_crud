import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

class DbController extends GetxController{

  //List<Map<String, dynamic>> items = [];
  RxList items = [].obs;

  final shoppingBox = Hive.box('shopping_box');

  @override
  void onInit() {
    refreshItems();
    super.onInit();
  }
  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }

  // Get all items from the database
  void refreshItems() {
    final data = shoppingBox.keys.map((key) {
      final value = shoppingBox.get(key);
      return {"key": key, "name": value["name"], "quantity": value['quantity']};
    }).toList();

    //items = data.reversed.toList();
    items.value = data.reversed.toList();
    // we use "reversed" to sort items in order from the latest to the oldest
  }

  // Create new item
  Future<void> createItem(Map<String, dynamic> newItem) async {
    await shoppingBox.add(newItem);
    refreshItems(); // update the UI
  }

  // Retrieve a single item from the database by using its key
  // Our app won't use this function but I put it here for your reference
  Map<String, dynamic> _readItem(int key) {
    final item = shoppingBox.get(key);
    return item;
  }

  // Update a single item
  Future<void> updateItem(int itemKey, Map<String, dynamic> item) async {
    await shoppingBox.put(itemKey, item);
    refreshItems(); // Update the UI
  }

  // Delete a single item
  Future<void> deleteItem(int itemKey) async {
    await shoppingBox.delete(itemKey);
    refreshItems(); // update the UI

    // Display a snackbar
    //if (!mounted) return;
    ScaffoldMessenger.of(Get.context!).showSnackBar(const SnackBar(content: Text('An item has been deleted')));
  }

}