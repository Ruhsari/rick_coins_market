import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rick_coins_market_ruhsari/providers/local_user_provider.dart';
import 'package:webview_flutter/webview_flutter.dart';


class WordReadingPage extends StatefulWidget {
  final String url;
  final String title;
  final String authorId;
  const WordReadingPage({
    super.key,
    required this.url,
    required this.title,
    required this.authorId
  });
  @override
  State<WordReadingPage> createState() => _WordReadingPageState();
}

class _WordReadingPageState extends State<WordReadingPage> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    final String googleDocsUrl =
        "https://docs.google.com/gview?embedded=true&url="
        "${Uri.encodeComponent(widget.url)}";
    _controller =
    WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() {
              _isLoading = true;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              _isLoading = false;
            });
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint("WebView Error: ${error.description}");
          },
        ),
      )
      ..loadRequest(Uri.parse(googleDocsUrl));
  }

  final String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.blueAccent,
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading) const Center(child: CircularProgressIndicator()),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (currentUserId != widget.authorId) {
            context.read<UserProvider>().giveRickCoins(widget.authorId, 10);
            ScaffoldMessenger.of (context,
            ) .showSnackBar(const SnackBar(content: Text("10 Rickkoins given!")),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("You can't give Rickkoins to yourself!"),
              ),
            );
          }
        },
        label: const Text("Reward Author"),
        icon: const Icon(Icons.star),
      ),
    );
  }
}
