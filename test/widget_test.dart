import 'package:flutter_test/flutter_test.dart';
import 'package:harry_potter_app/main.dart';

void main() {
  testWidgets('App smoke test - verifies LoginView renders properly', (WidgetTester tester) async {
    // Jalankan aplikasi dengan status login false
    await tester.pumpWidget(const MyApp(isLoggedIn: false));

    // Verifikasi bahwa teks Login dan form input muncul di layar
    expect(find.text('Login'), findsWidgets);
    expect(find.text('Username'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
  });
}
