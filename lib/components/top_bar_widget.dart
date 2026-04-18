import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../states/local_user_provider.dart';

class TopBarWidget extends StatelessWidget {
  final bool showLogoutButton;
  const TopBarWidget({super.key, this.showLogoutButton = false});

  @override
  Widget build(BuildContext context) {
    final auth = FirebaseAuth.instance;
    final currentUser = auth.currentUser;
    final userProvider = context.watch<UserProvider>();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              if (currentUser == null) {
                Navigator.pushNamed(context, '/login');
              }
            },
            child: Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFF00B4D8), width: 2),
              ),
              child: CircleAvatar(
                radius: 28,
                backgroundColor: Colors.grey[200],
                backgroundImage: (currentUser == null ||
                    userProvider.userData?.avatar == null ||
                    userProvider.userData!.avatar.isEmpty)
                    ? const AssetImage("assets/images/who_is_photo.png") as ImageProvider
                    : NetworkImage(userProvider.userData!.avatar),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  (currentUser == null) ? "Click avatar to login" : "Welcome back,",
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                Text(
                  userProvider.userData?.nickname ?? "Guest",
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                    color: Color(0xFF2B2D42),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (currentUser != null)
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF00B4D8).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.monetization_on, size: 14, color: Color(0xFF00B4D8)),
                        const SizedBox(width: 4),
                        Text(
                          "${userProvider.userData?.coins ?? 0} Rc\$",
                          style: const TextStyle(
                            color: Color(0xFF00B4D8),
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          if (currentUser != null && showLogoutButton)
            Container(
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.logout_rounded, color: Colors.redAccent),
                onPressed: () async {
                  await auth.signOut();
                },
              ),
            ),
        ],
      ),
    );
  }
}