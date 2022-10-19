import 'package:flutter/material.dart';
import 'package:mobsur_flutter_sdk/mobsur_flutter_sdk.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // You can call this method somewhere else in the app instead,
  // but it should not be right before an event, that should trigger a survey
  MobSurSDK().setup('686034d7-dbf2-4555-8c7b-7ccfdc84927a', 'user-id');
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
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextButton(
                onPressed: () {
                  MobSurSDK().logEvent('myevent', context);
                },
                child: const Text('Start survey'))
          ],
        ),
      ),
    );
  }
}
