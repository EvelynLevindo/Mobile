import 'package:flutter_test/flutter_test.dart';
import 'package:senai_checkin/main.dart';

void main() {
  testWidgets('app should render the SENAI CheckIn interface', (tester) async {
    await tester.pumpWidget(const SenaiCheckinApp());

    expect(find.text('SENAI CheckIn'), findsOneWidget);
    expect(find.text('Registrar ponto'), findsOneWidget);
  });
}
