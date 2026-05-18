import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rick_coins_market_ruhsari/components/top_bar_widget.dart';

import '../components/market_chat_bubble.dart';
import '../components/message_create_widget.dart';
import '../components/rikkoins_sales_bay.dart';

class MarketPage extends StatefulWidget {
  @override
  State<MarketPage> createState() => _MarketPageState();
}

class _MarketPageState extends State<MarketPage> {
  bool isSaleBuyCardShow = false;
  bool isMessageCardShow = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Очень легкий, свежий серо-голубой фон (создает ощущение "воздуха" и чистоты)
      backgroundColor: const Color(0xFFF4F7F9),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10),
            TopBarWidget(showLogoutButton: false),

            // Яркий, современный заголовок
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    const Text(
                      "Rickcoins Market",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF03045E), // Глубокий темно-синий
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text("🚀", style: TextStyle(fontSize: 24)),
                  ],
                ),
              ),
            ),

            // Яркие кнопки-переключатели с разными градиентами
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  _buildVibrantToggle(
                    title: "Trade",
                    icon: Icons.currency_exchange_rounded,
                    isActive: isSaleBuyCardShow,
                    // Сочный бирюзово-синий градиент
                    activeGradient: const LinearGradient(
                      colors: [Color(0xFF00F5D4), Color(0xFF0077B6)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shadowColor: const Color(0xFF00B4D8),
                    onTap: () {
                      setState(() {
                        isSaleBuyCardShow = !isSaleBuyCardShow;
                        if (isSaleBuyCardShow) isMessageCardShow = false;
                      });
                    },
                  ),
                  const SizedBox(width: 16),
                  _buildVibrantToggle(
                    title: "Message",
                    icon: Icons.chat_bubble_outline_rounded,
                    isActive: isMessageCardShow,
                    // Яркий розово-фиолетовый градиент
                    activeGradient: const LinearGradient(
                      colors: [Color(0xFFF15BB5), Color(0xFF9D4EDD)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shadowColor: const Color(0xFFF15BB5),
                    onTap: () {
                      setState(() {
                        isMessageCardShow = !isMessageCardShow;
                        if (isMessageCardShow) isSaleBuyCardShow = false;
                      });
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Плавное появление панелей
            AnimatedSize(
              duration: const Duration(milliseconds: 350),
              curve: Curves.fastOutSlowIn,
              child: isSaleBuyCardShow ? RickkoinSaleBayWidget() : const SizedBox.shrink(),
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 350),
              curve: Curves.fastOutSlowIn,
              child: isMessageCardShow ? MessageCreateWidget() : const SizedBox.shrink(),
            ),

            const SizedBox(height: 10),

            // Лента предложений
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('user_persons').snapshots(),
                builder: (context, snapshots) {
                  if (!snapshots.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFFF15BB5), // Яркий индикатор загрузки
                      ),
                    );
                  }

                  final String currentUid = FirebaseAuth.instance.currentUser?.uid ?? "";

                  final List<QueryDocumentSnapshot> otherUsers = snapshots.data!.docs.where((doc) {
                    return doc.id != currentUid;
                  }).toList();

                  if (otherUsers.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.inbox_rounded, size: 60, color: Colors.grey[400]),
                          const SizedBox(height: 16),
                          const Text(
                            "Market is empty right now.\nBe the first to post!",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey, fontSize: 16),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    physics: const BouncingScrollPhysics(), // Приятная физика скролла (особенно для iOS)
                    padding: const EdgeInsets.only(bottom: 30, top: 8),
                    itemCount: otherUsers.length,
                    itemBuilder: (context, index) {
                      var userData = otherUsers[index].data() as Map<String, dynamic>;
                      String docId = otherUsers[index].id;
                      return MarketChatBubble(userData: userData, uid: docId);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Обновленный виджет кнопки с цветной тенью (Glow Effect)
  Widget _buildVibrantToggle({
    required String title,
    required IconData icon,
    required bool isActive,
    required LinearGradient activeGradient,
    required Color shadowColor,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            gradient: isActive ? activeGradient : null,
            color: isActive ? null : Colors.white,
            borderRadius: BorderRadius.circular(24), // Более круглые, мягкие углы
            boxShadow: [
              if (isActive)
                BoxShadow(
                  color: shadowColor.withOpacity(0.4), // Цветное свечение под активной кнопкой
                  blurRadius: 15,
                  offset: const Offset(0, 6),
                )
              else
                BoxShadow(
                  color: Colors.black.withOpacity(0.04), // Очень легкая тень для неактивной
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isActive ? Colors.white : const Color(0xFF6C757D),
                size: 22,
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: TextStyle(
                  color: isActive ? Colors.white : const Color(0xFF495057),
                  fontWeight: FontWeight.w800, // Жирный шрифт для читаемости
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}