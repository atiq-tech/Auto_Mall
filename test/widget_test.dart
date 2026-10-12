import 'package:flutter_test/flutter_test.dart';

import 'package:auto_mall/main.dart';

void main() {
  testWidgets('Auto Mall app loads', (WidgetTester tester) async {
    await tester.pumpWidget(AutoMallApp());

    expect(find.text('Auto Mall'), findsOneWidget);
    expect(find.text('Smart business management'), findsOneWidget);
  });
}
