import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:mobsur_flutter_demo/main.dart';
import 'package:mobsur_flutter_sdk/mobsur_flutter_sdk.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter_platform_interface/webview_flutter_platform_interface.dart';

import 'fake_webview.dart';

final surveysBody = jsonEncode({
  'data': [
    {
      'id': 27,
      'url': 'https://web.mobsur.com/survey/27?user_reference_id=u&app_version=1.0.0&platform=ios&app_id=$appId',
      'start_date': '2026-01-01T00:00:00+00:00',
      'end_date': null,
      'rules': [
        {
          'type': 'counted_event',
          'name': 'MY_Event',
          'occurred': {'min': 1, 'max': null},
          'delay': 0,
        },
      ],
    },
  ],
});

void main() {
  late List<http.Request> requests;
  late FakeWebViewPlatform webViews;

  setUp(() {
    requests = [];
    webViews = FakeWebViewPlatform();
    WebViewPlatform.instance = webViews;
    SharedPreferences.setMockInitialValues({});
    PackageInfo.setMockInitialValues(
      appName: 'mobsur_flutter_demo',
      packageName: 'com.example.mobsur_flutter_demo',
      version: '1.0.0',
      buildNumber: '1',
      buildSignature: '',
    );
    MobSurSDK().resetForTesting();
    MobSurSDK.httpClientOverride = MockClient((request) async {
      requests.add(request);
      return http.Response(surveysBody, 200, headers: {'content-type': 'application/json'});
    });
  });

  tearDown(() => MobSurSDK.httpClientOverride = null);

  /// Runs the app's own setup and waits for the first survey fetch.
  Future<void> startApp(WidgetTester tester) async {
    await tester.runAsync(() async {
      await setupMobSur();
      await MobSurSDK().pendingFetch;
    });
    await tester.pumpWidget(const MyApp());
    await tester.pump(const Duration(seconds: 1));
  }

  testWidgets('lists the surveys fetched for this app', (tester) async {
    await startApp(tester);

    expect(requests.single.url.queryParameters['app_id'], appId);
    expect(find.text('Surveys for this device: 1'), findsOneWidget);
    expect(find.text('#27 on MY_Event'), findsOneWidget);

    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('the button opens the survey through the navigator key', (tester) async {
    await startApp(tester);

    await tester.tap(find.text('Start the survey'));
    for (var frame = 0; frame < 10; frame++) {
      await tester.pump(const Duration(milliseconds: 100));
    }

    expect(webViews.controller?.loaded.toString(), startsWith('https://web.mobsur.com/survey/27?'));

    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('New test user switches to a new user ID and fetches again', (tester) async {
    await startApp(tester);
    final firstUser = requests.single.url.queryParameters['user_reference_id'];

    await tester.tap(find.text('New test user'));
    await tester.runAsync(() => MobSurSDK().pendingFetch);
    await tester.pump();

    expect(requests, hasLength(2));
    final newUser = requests.last.url.queryParameters['user_reference_id'];
    expect(newUser, startsWith('test-'));
    expect(newUser, isNot(firstUser));
    expect(find.textContaining('Restart the app'), findsOneWidget);

    await tester.pumpWidget(const SizedBox());
  });
}
