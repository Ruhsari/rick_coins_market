import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rick_coins_market_ruhsari/app_navigation.dart';

class MarketChatBubble extends StatelessWidget {
  final Map<String, dynamic> userData;
  final String uid;

  const MarketChatBubble({
    Key? key,
    required this.userData,
    required this.uid,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? "";

    bool showAlarm = (userData['targetPartnerId'] == currentUserId) &&
        ((userData['individualSell'] ?? 0) > 0);

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          AppNavigation.twoPersonTrade,
          arguments: {
            'nickname': userData['nickname'] ?? 'User',
            'uid': uid,
          },
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24), // Современное скругление
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04), // Мягкая тень
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
            // Если есть предложение, добавляем легкое свечение всей карточке
            if (showAlarm)
              BoxShadow(
                color: const Color(0xFFF15BB5).withOpacity(0.15),
                blurRadius: 20,
                offset: const Offset(0, 0),
              ),
          ],
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Аватарка с цветным ободком
                  Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [Color(0xFF00F5D4), Color(0xFF0077B6)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 32,
                      backgroundColor: Colors.white,
                      backgroundImage: NetworkImage(userData['avatar'] ?? ''),
                      onBackgroundImageError: (_, __) => const Icon(Icons.person),
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Информация о пользователе
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userData['nickname'] ?? 'User',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF03045E), // Темно-синий цвет текста
                          ),
                        ),
                        const SizedBox(height: 4),

                        // Статус / Сообщение
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF4F7F9),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.withOpacity(0.2)),
                          ),
                          child: Text(
                            "\"${userData['message'] ?? 'No status'}\"",
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontStyle: FontStyle.italic,
                              fontSize: 13,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Бейджики с цифрами
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            _buildModernBadge(
                              icon: Icons.account_balance_wallet_rounded,
                              label: "${userData['coins'] ?? 0} Rc\$",
                              color: const Color(0xFF9D4EDD), // Фиолетовый
                            ),
                            _buildModernBadge(
                              icon: Icons.arrow_upward_rounded,
                              label: "Sell: ${userData['sales'] ?? 0}",
                              color: const Color(0xFF38EF7D), // Зеленый
                            ),
                            _buildModernBadge(
                              icon: Icons.arrow_downward_rounded,
                              label: "Buy: ${userData['buying'] ?? 0}",
                              color: const Color(0xFFFF512F), // Красный/Оранжевый
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Иконка уведомления (правильно спозиционированная через Stack)
            if (showAlarm)
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF15BB5),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFF15BB5).withOpacity(0.5),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.notifications_active_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Вспомогательный виджет для красивых бейджиков (Chips)
  Widget _buildModernBadge({required IconData icon, required String label, required Color color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1), // Полупрозрачный фон
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w800,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}