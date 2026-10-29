import 'package:flutter_test/flutter_test.dart';

import 'package:mobsur_flutter_demo/main.dart';

void main() {
  testWidgets('Home screen shows the event field and the survey button', (tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('MobSur Flutter Demo'), findsOneWidget);
    expect(find.text('MY_Event'), findsOneWidget);
    expect(find.text('Start the survey'), findsOneWidget);
    expect(find.text('Surveys for this device: 0'), findsOneWidget);
  });
}
