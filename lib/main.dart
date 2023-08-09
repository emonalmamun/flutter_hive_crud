import 'package:flutter/material.dart';
import 'package:flutter_hive_crud/home_page/binding/home_binding.dart';
import 'package:flutter_hive_crud/home_page/view/home_page.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

// emon branch
void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('shopping_box');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter hive db Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      //home: const HomePage(),
      initialRoute: '/home_page',
      getPages: [
        GetPage(name: '/home_page', page: () => HomePage(), binding: HomeBinding(), transition: Transition.fadeIn),
      ],
    );
  }
}

