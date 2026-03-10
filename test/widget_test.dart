import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ihsan_app/app.dart';

void main() {
  testWidgets('launches Ihsan splash flow', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: IhsanApp()));
    await tester.pump();

    expect(find.text('IHSAN'), findsOneWidget);
    expect(find.text('Pursue Excellence.'), findsOneWidget);
  });
}
