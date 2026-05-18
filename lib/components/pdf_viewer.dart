import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:provider/provider.dart';
import 'package:rick_coins_market_ruhsari/providers/local_user_provider.dart';



class PDFViewScreen extends StatelessWidget {
  final String url;
  final String title;
  final String authorId;
  PDFViewScreen({
    super.key,
    required this.url,
    required this.title,
    required this.authorId,
  });

  final String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: PdfViewer.uri(Uri.parse(url)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (currentUserId != authorId) {
            context.read<UserProvider>().giveRickCoins(authorId, 10);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("10 Rickkoins given!")),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("You can't give Rickkoins to yourself!"),
            ),
            );
          }
        },
        label: const Text("Give Rickkoins"),
        icon: const Icon(Icons.favorite),
      ),
    );
  }
}