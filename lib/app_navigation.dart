import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rick_coins_market_ruhsari/ui/cabinet_page.dart';
import 'package:rick_coins_market_ruhsari/ui/home_page.dart';
import 'package:rick_coins_market_ruhsari/ui/sign_in_sign_up/login_page.dart';
import 'package:rick_coins_market_ruhsari/ui/sign_in_sign_up/registration_page.dart';
import 'package:rick_coins_market_ruhsari/ui/info_page.dart';
import 'package:rick_coins_market_ruhsari/ui/market_page.dart';
import 'package:rick_coins_market_ruhsari/ui/offerta_page.dart';
import 'package:rick_coins_market_ruhsari/ui/payment_page.dart';
import 'package:rick_coins_market_ruhsari/components/pdf_viewer.dart';
import 'package:rick_coins_market_ruhsari/components/word_viewer.dart';
import 'package:rick_coins_market_ruhsari/ui/two_person_trade_page.dart';
import 'package:rick_coins_market_ruhsari/states/main_screen_state.dart';
import 'package:rick_coins_market_ruhsari/ui/splash_page.dart';

class AppNavigation {
  static const String splash = '/splash';
  static const String home = '/';
  static const String market = '/market';
  static const String cabinet = '/cabinet';
  static const String info_page = '/info_page';
  static const String offerta = '/offerta';
  static const String payment = '/payment';
  static const String login = '/login';
  static const String registration = '/registration';
  static const String pdfView = '/pdf_view';
  static const String wordView = '/word_view';
  static const String twoPersonTrade = '/two_person_trade';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    final bool isLoggedIn = FirebaseAuth.instance.currentUser != null;
    final List<String> protectedRoutes = [market, cabinet, payment, pdfView];

    if (protectedRoutes.contains(settings.name) && !isLoggedIn) {
      return MaterialPageRoute(builder: (_) => LoginPage());
    }

    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashPage());
      case login:
        return MaterialPageRoute(builder: (_) => LoginPage());
      case registration:
        return MaterialPageRoute(builder: (_) => RegistrationPage());
      case home:
        return MaterialPageRoute(builder: (_) => MainScreen());
      case market:
        return MaterialPageRoute(builder: (_) => MarketPage());
      case cabinet:
        return MaterialPageRoute(builder: (_) => CabinetPage());
      case info_page:
        return MaterialPageRoute(builder: (_) => const InfoPage());
      case offerta:
        return MaterialPageRoute(builder: (_) => OffertaPage());
      case payment:
        final args = (settings.arguments as Map<String, dynamic>?) ?? {};
        return MaterialPageRoute(
          builder:
              (_) => PaymentPage(
            partnerUid: args['partnerUid'] ?? '',
            passed_amount: args['passed_amount'] ?? 0,
            partnerNickname: args['partnerNickname'] ?? 'Partner',
            pageLable: args['pageLable'] ?? '',
          ),
        );

      case twoPersonTrade:
        final args = (settings.arguments as Map<String, dynamic>?) ?? {};
        return MaterialPageRoute(
          builder:
              (_) => TwoPersonTradePage(
            nickname: args['nickname']?.toString() ?? 'no name',
            uid: args['uid']?.toString() ?? '',
          ),
        );
      case pdfView:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder:
              (_) => PDFViewScreen(
            url: args['url'],
            title: args['title'],
            authorId: args['authorId'],
          ),
        );
      case wordView:
        final argsW = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder:
              (_) => WordReadingPage(
            url: argsW['url'],
            title: argsW['title'],
            authorId: argsW['authorId'],
          ),
        );

      default:
      // Fallback to home if route is unknown
        return MaterialPageRoute(builder: (_) => MainScreen());
    }
  }
}