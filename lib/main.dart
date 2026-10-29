import 'package:flutter/material.dart';
import 'package:mobsur_flutter_sdk/mobsur_flutter_sdk.dart';

// Override with: flutter run --dart-define=MOBSUR_APP_ID=<your App ID>
const appId = String.fromEnvironment(
  'MOBSUR_APP_ID',
  defaultValue: '36121162-25d6-40f1-ab24-d5bd87a47601',
);

// Lets the SDK show a survey without a BuildContext.
final navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Pass your signed-in user's ID here. With null the SDK creates a random ID
  // once and keeps it, so every launch isn't counted as a new user.
  // setup() never waits for the network, so it is safe to await before runApp.
  await MobSurSDK().setup(appId, null, debug: true, navigatorKey: navigatorKey);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MobSur Flutter Demo',
      navigatorKey: navigatorKey,
      theme: ThemeData(colorSchemeSeed: Colors.blue),
      home: const MyHomePage(title: 'MobSur Flutter Demo'),
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
  final _event = TextEditingController(text: 'MY_Event');

  @override
  void dispose() {
    _event.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final surveys = MobSurSDK().availableSurveys() ?? const [];
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          TextField(
            controller: _event,
            decoration: const InputDecoration(
              labelText: 'Event name',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: () => MobSurSDK().logEvent(_event.text.trim()),
            child: const Text('Start the survey'),
          ),
          const SizedBox(height: 24),
          Text(
            'Surveys for this device: ${surveys.length}',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          for (final survey in surveys)
            Text('#${survey.id} on ${survey.rules.map((rule) => rule.name).join(', ')}'),
          TextButton(
            onPressed: () => setState(() {}),
            child: const Text('Refresh this list'),
          ),
        ],
      ),
    );
  }
}
