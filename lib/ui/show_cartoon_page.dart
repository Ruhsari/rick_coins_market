// import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart';
//
// import '../models/btn_cartoon_model.dart';
//
// class ShowCartoonPage extends StatefulWidget {
//   final BtnCartoonModel btnCartoonModel;
//   const ShowCartoonPage({super.key, required this.btnCartoonModel});
//
//   @override
//   State<ShowCartoonPage> createState() => _ShowCartoonPageState();
// }
//
// class _ShowCartoonPageState extends State<ShowCartoonPage> {
//   Future<void> _launchURL() async {
//     final Uri url = Uri.parse(widget.btnCartoonModel.url);
//     if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Failed to load URL ${widget.btnCartoonModel.url}')),
//         );
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title:const Text('Cartoon Details'),
//         backgroundColor: const Color.fromARGB(255, 10, 119, 13),
//       ),
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Image.asset(widget.btnCartoonModel.image, height: 200),
//               const SizedBox(height: 30),
//               ElevatedButton.icon(
//                 onPressed: _launchURL,
//                 icon: const Icon(Icons.open_in_browser),
//                 label: const Text('Opeb Cartoon Resource'),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.blueAccent,
//                   foregroundColor: Colors.white,
//                   padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:rick_coins_market_ruhsari/models/btn_cartoon_model.dart'; // Проверь правильность пути к модели!
import 'package:webview_flutter/webview_flutter.dart';

class ShowCartoonPage extends StatefulWidget {
  final BtnCartoonModel btnCartoonModel; // Оставил твое оригинальное название переменной

  const ShowCartoonPage({Key? key, required this.btnCartoonModel}) : super(key: key);

  @override
  State<ShowCartoonPage> createState() => _ShowCartoonPageState();
}

class _ShowCartoonPageState extends State<ShowCartoonPage> {
  late final WebViewController _controller;
  bool _isLoading = true;
  double _loadingProgress = 0; // Правильная переменная

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (progress) {
            if (mounted) {
              setState(() {
                _loadingProgress = progress / 100.0; // <-- Исправлено здесь
              });
            }
          },
          onPageStarted: (String url) {
            if (mounted) {
              setState(() {
                _isLoading = true;
              });
            }
          },
          onPageFinished: (String url) {
            if (mounted) {
              setState(() {
                _isLoading = false;
              });
            }
          },
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/') ||
                request.url.startsWith('https://youtube.com/') ||
                request.url.startsWith('https://youtu.be/')) {
              return NavigationDecision.navigate;
            }
            return NavigationDecision.prevent;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.btnCartoonModel.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text(
          widget.btnCartoonModel.url,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Color(0xFF2B2D42),
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        iconTheme: const IconThemeData(color: Color(0xFF0077B6)),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: Colors.black.withOpacity(0.05),
            height: 1.0,
          ),
        ),
      ),

      body: Stack(
        children: [
          WebViewWidget(controller: _controller),

          if (_isLoading)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: LinearProgressIndicator(
                value: _loadingProgress, // <-- И исправлено здесь
                color: const Color(0xFF00B4D8),
                backgroundColor: Colors.white,
                minHeight: 2.5,
              ),
            ),
        ],
      ),
    );
  }
}