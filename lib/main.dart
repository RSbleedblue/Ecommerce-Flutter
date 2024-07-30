import 'package:CredexEcom/utils/language_change.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:CredexEcom/pages/sign_up_page.dart';
import 'package:CredexEcom/pages/user_landing.dart';
import 'package:CredexEcom/pages/intro_page.dart';
import 'package:CredexEcom/utils/product_provider.dart';
import 'package:CredexEcom/utils/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; 
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async { 
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final prefs = await SharedPreferences.getInstance();
  final String? email = prefs.getString('email');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ProductProvider()),
        ChangeNotifierProvider(create: (context) => CartProvider()),
        ChangeNotifierProvider(create: (context) => LanguageChange()),
      ],
      child: MyApp(initialRoute: email != null ? '/home' : '/login'),
    ),
  );
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageChange>(
      builder: (context, languageChange, child) {
        return MaterialApp(
          title: 'Credex Ecommerce',
          locale: languageChange.appLocale, 
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en'),
            Locale('es'),
            Locale('ja'),
            Locale('fr'),
            Locale('de'),
          ],
          debugShowCheckedModeBanner: false,
          initialRoute: initialRoute,
          routes: {
            '/home': (context) => const UserLanding(),
            '/signUp': (context) => const SignUpPage(),
            '/login': (context) => IntroPage(),
          },
        );
      },
    );
  }
}
