import 'package:flutter_test/flutter_test.dart';
import 'package:costy/main.dart';

void main() {
  testWidgets('App launches test', (WidgetTester tester) async {
    await tester.pumpWidget(const Costy());

    expect(find.text('Dashboard'), findsWidgets);
    expect(find.text('Upcoming Renewals'), findsNothing);
  });
}
