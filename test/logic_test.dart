import 'package:flutter_test/flutter_test.dart';
import 'package:ihsan_app/app.dart';

void main() {
  group('LaunchRequest', () {
    test('parses screen and atlas params', () {
      final LaunchRequest request = LaunchRequest.fromUri(
        Uri.parse('https://example.com/?screen=50&atlas=1'),
      );

      expect(request.screenId, 50);
      expect(request.showAtlas, isTrue);
      expect(request.tabIndex, isNull);
    });

    test('parses stage and tab params', () {
      final LaunchRequest request = LaunchRequest.fromUri(
        Uri.parse('https://example.com/?stage=shell&tab=3'),
      );

      expect(request.stage, AppStage.shell);
      expect(request.tabIndex, 3);
      expect(request.screenId, isNull);
    });
  });

  group('calculateZakat', () {
    test('returns zero under nisab', () {
      final double zakat = calculateZakat(
        cash: 100,
        gold: 100,
        investments: 100,
        businessAssets: 100,
        liabilities: 50,
        nisab: 500,
      );

      expect(zakat, 0);
    });

    test('calculates 2.5 percent above nisab', () {
      final double zakat = calculateZakat(
        cash: 10000,
        gold: 2500,
        investments: 4000,
        businessAssets: 1500,
        liabilities: 2000,
        nisab: 550,
      );

      expect(zakat, closeTo(400, 0.001));
    });
  });
}
