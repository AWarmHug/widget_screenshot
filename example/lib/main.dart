import 'package:flutter/material.dart';
import 'package:widget_shot_example/example_list_extra.dart';

import 'example_list.dart';
import 'example_scrollview_extra.dart';
import 'example_single.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Example",
        ),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text("Single Example"),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) {
                  return const ExampleSinglePage();
                },
              ));
            },
          ),
          ListTile(
            title: const Text("List Example"),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) {
                  return const ExampleListPage();
                },
              ));
            },
          ),
          ListTile(
            title: const Text("List Extra Example"),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) {
                  return const ExampleListExtraPage();
                },
              ));
            },
          ),
          ListTile(
            title: const Text("ScrollView Example"),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) {
                  return const ExampleScrollViewExtraPage();
                },
              ));
            },
          ),
        ],
      ),
    );
  }
}
