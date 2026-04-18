import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rick_coins_market_ruhsari/states/local_user_provider.dart';

import 'app_navigation.dart';
import 'firebase_options.dart';
import 'package:google_fonts/google_fonts.dart';




Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => UserProvider())],
      child: const MyApp(),
    ),
  );
}




// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Rikki Morty Ruhsari',
//       debugShowCheckedModeBanner: false,
//       initialRoute: AppNavigation.home,
//       onGenerateRoute: AppNavigation.generateRoute,
//     );
//   }
// }
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rikki Morty Ruhsari',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF00B4D8)),
        useMaterial3: true,
        textTheme: GoogleFonts.nunitoTextTheme(
          Theme.of(context).textTheme,
        ),
      ),

      initialRoute: AppNavigation.home,
      onGenerateRoute: AppNavigation.generateRoute,
    );
  }
}
