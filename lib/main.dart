import 'package:akla00001/abonnement/abonnement.page.dart';
import 'package:akla00001/pages/coursExos.page.dart';
import 'package:akla00001/pages/depart.page.dart';
import 'package:akla00001/pages/examensEpreuve.page.dart';
import 'package:akla00001/quizes/quizes.page.dart';
import 'package:flutter/material.dart';
import 'package:akla00001/pages/fonction.page.dart';
import 'package:akla00001/pages/about.page.dart';
import 'package:akla00001/classes/stateprovider.dart';
import 'package:provider/provider.dart';

void main() async {

  return runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
      create: (context) => Images(),
    ), ChangeNotifierProvider(
      create: (context) => CodeAbonnement(),
    ),
    ChangeNotifierProvider(
      create: (context) => EtatAbonnement(),
    ),
    ChangeNotifierProvider(
      create: (context) => ActiviterDuJour(),
    ), ChangeNotifierProvider(
      create: (context) => ThemeModel(),
    ),
    ChangeNotifierProvider(
      create: (context) => AppState(),
    ),

    ChangeNotifierProvider(
      create: (context) => userClass(),
    ),
    // ChangeNotifierProvider(create: (context) => ThemeModel()..loadThemeMode()),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Provider.of<EtatAbonnement>(context);
    Provider.of<CodeAbonnement>(context);
    Provider.of<ActiviterDuJour>(context);
    Provider.of<Images>(context);
    Provider.of<AppState>(context);
    Provider.of<userClass>(context);
    ThemeModel themeModel = Provider.of<ThemeModel>(context);

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blueGrey,
        ),
        darkTheme: ThemeData.dark().copyWith(
          textTheme: const TextTheme(
            headlineSmall: TextStyle(color: Colors.white),
            headlineLarge: TextStyle(color: Colors.white),
            headlineMedium: TextStyle(color: Colors.white),
            titleMedium: TextStyle(color: Colors.white),
            titleLarge: TextStyle(color: Colors.white),
            titleSmall: TextStyle(color: Colors.white),
            bodyMedium: TextStyle(
                color: Colors.white), // Exemple de personnalisation du texte
            // ...
          ),
          // ...
        ),
        themeMode: themeModel.theme,
        title: 'Flutter Tutorial',
        initialRoute: '/',
        routes: {
          '/': (context) => const SplashScreen(),
          '/function': (context) => const DemoPage(),
          '/CoursExos': (context) => const CoursExos(),
          '/about': (context) => const about(),
          '/examens': (context) => const ExamensPage(),
          '/abonnement': (context) => const Abonnement(),
          '/quiz': (context) => const QuizPage(),
        });
  }
}
