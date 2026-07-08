import 'package:flutter_test/flutter_test.dart';
import 'package:fanm_plus_app/main.dart';

void main() {
  testWidgets('App launches successfully', (WidgetTester tester) async {
    await tester.pumpWidget(const FanmPlusApp());
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
