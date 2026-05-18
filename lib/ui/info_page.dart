import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:rick_coins_market_ruhsari/app_navigation.dart';
import '../providers/local_user_provider.dart';

class InfoPage extends StatefulWidget {
  const InfoPage({super.key});
  @override
  State<InfoPage> createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  bool _isExpanded = false;

  final String _shortText =
      "Discover how to earn Rick-Coins by contributing to our community! Upload scenarios, get likes, and level up.";
  final String _fullText =
      "Discover how to earn Rick-Coins by contributing to our community!\n\n"
      "📖 1. Upload high-quality cartoon snippets.\n"
      "❤️ 2. Get likes and shares from the community.\n"
      "🎯 3. Each milestone reached rewards you with Rick-Coins!\n"
      "🔥 4. Participate in weekly challenges for bonus multipliers.\n"
      "🛍️ 5. Redeem your coins for exclusive avatars and features.";

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final String myUid = FirebaseAuth.instance.currentUser?.uid ?? "";
    final String myName = userProvider.userData?.nickname ?? "User";

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F9), // Единый фон приложения
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF03045E)),
        title: const Text(
          "Info & Rules",
          style: TextStyle(
            color: Color(0xFF03045E),
            fontWeight: FontWeight.w900,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            // Карточка с правилами (Анимированная)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0077B6).withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.info_outline_rounded, color: Color(0xFF0077B6)),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          "How to earn Rick-Coins",
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 18,
                            color: Color(0xFF03045E),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Плавное раскрытие текста
                  AnimatedSize(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    alignment: Alignment.topCenter,
                    child: Text(
                      _isExpanded ? _fullText : _shortText,
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 15,
                        height: 1.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Кнопка "Читать далее / Свернуть"
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () => setState(() => _isExpanded = !_isExpanded),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF4F7F9),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _isExpanded ? "Show Less" : "Read More",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0077B6),
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(
                              _isExpanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                              color: const Color(0xFF0077B6),
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Анимация монетки с фоновым свечением
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF00F5D4).withOpacity(0.3),
                        blurRadius: 30,
                        spreadRadius: 10,
                      )
                    ],
                  ),
                ),
                Lottie.asset(
                  'assets/lottie/turn_coin.json',
                  height: 160,
                ),
              ],
            ),

            const SizedBox(height: 30),

            // Яркая градиентная карточка для покупки коинов
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFF15BB5), Color(0xFF9D4EDD)], // Розово-фиолетовый
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFF15BB5).withOpacity(0.4), // Цветная тень
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  )
                ],
              ),
              child: Column(
                children: [
                  const Icon(Icons.shopping_cart_checkout_rounded, color: Colors.white, size: 40),
                  const SizedBox(height: 12),
                  const Text(
                    "Want Rick-Coins Instantly?",
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 20,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Skip the wait! You can securely purchase Rick-Coins directly using your preferred payment method.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Кнопка перехода на оплату
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF9D4EDD),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: 0,
                      ),
                      // ИСПРАВЛЕНО: onTap заменено на onPressed
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          AppNavigation.payment,
                          arguments: {
                            'partnerUid': myUid,
                            'passed_amount': 0,
                            'partnerNickname': myName,
                            'pageLable': "from_info_page",
                          },
                        );
                      },
                      child: const Text(
                        "View Payment Options",
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 16,
                          color: Color(0xFF9D4EDD),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}