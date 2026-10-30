import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mobsur_flutter_sdk/mobsur_flutter_sdk.dart';

// Override with: flutter run --dart-define=MOBSUR_APP_ID=<your App ID>
const appId = String.fromEnvironment(
  'MOBSUR_APP_ID',
  defaultValue: '36121162-25d6-40f1-ab24-d5bd87a47601',
);

// Point the app at staging or a local MobSur server, e.g.
// --dart-define=MOBSUR_BASE_URL=http://localhost:3000
const baseUrl = String.fromEnvironment('MOBSUR_BASE_URL');

// SDK logs include the user ID, so they are on only in debug builds.
// Use --dart-define=MOBSUR_DEBUG=true to see them in a release build.
const debugLogs = kDebugMode || bool.fromEnvironment('MOBSUR_DEBUG');

// Lets the SDK show a survey without a BuildContext.
final navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupMobSur();
  runApp(const MyApp());
}

/// Pass your signed-in user's ID instead of null. With null the SDK creates a
/// random ID once and keeps it, so every launch isn't counted as a new user.
/// setup() never waits for the network, so it is safe to await before runApp.
Future<void> setupMobSur() => MobSurSDK().setup(
      appId,
      null,
      debug: debugLogs,
      navigatorKey: navigatorKey,
      baseUrl: baseUrl.isEmpty ? null : Uri.parse(baseUrl),
    );

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
  Timer? _refresh;

  @override
  void initState() {
    super.initState();
    // The SDK fetches surveys in the background and has no change callback,
    // so re-read its in-memory list every second.
    _refresh = Timer.periodic(const Duration(seconds: 1), (_) => setState(() {}));
  }

  @override
  void dispose() {
    _refresh?.cancel();
    _event.dispose();
    super.dispose();
  }

  void _newTestUser() {
    final random = Random.secure();
    final id = 'test-${List.generate(16, (_) => random.nextInt(16).toRadixString(16)).join()}';
    MobSurSDK().updateClientId(id);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('New test user. Restart the app to see a survey again: '
          'the SDK shows at most one survey per app session.'),
    ));
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
          const SizedBox(height: 24),
          OutlinedButton(
            onPressed: _newTestUser,
            child: const Text('New test user'),
          ),
        ],
      ),
    );
  }
}
