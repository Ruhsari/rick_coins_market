import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // Обязательно добавь этот пакет в pubspec.yaml, если его там нет
import 'package:webview_flutter/webview_flutter.dart';
import 'package:rick_coins_market_ruhsari/models/btn_cartoon_model.dart';

class ShowCartoonPage extends StatefulWidget {
  final BtnCartoonModel btnCartoonModel;

  const ShowCartoonPage({Key? key, required this.btnCartoonModel}) : super(key: key);

  @override
  State<ShowCartoonPage> createState() => _ShowCartoonPageState();
}

class _ShowCartoonPageState extends State<ShowCartoonPage> {
  late final WebViewController _controller;
  bool _isLoading = true;
  double _loadingProgress = 0;

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0xFFF4F7F9)) // Единый фон
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (progress) {
            if (mounted) {
              setState(() {
                _loadingProgress = progress / 100.0;
              });
            }
          },
          onPageStarted: (String url) {
            if (mounted) {
              setState(() => _isLoading = true);
            }
          },
          onPageFinished: (String url) {
            if (mounted) {
              setState(() => _isLoading = false);
            }
          },
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            // Разрешаем только ссылки на YouTube
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

  // Функция для открытия видео во внешнем приложении (YouTube)
  Future<void> _launchExternal() async {
    final Uri url = Uri.parse(widget.btnCartoonModel.url);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load URL ${widget.btnCartoonModel.url}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F9),
      appBar: AppBar(
        title: const Text(
          "Watch Channel 🍿",
          style: TextStyle(
            color: Color(0xFF03045E),
            fontSize: 20,
            fontWeight: FontWeight.w900,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
        ),
        iconTheme: const IconThemeData(color: Color(0xFF03045E)),
        // Легкая тень под AppBar
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ]
            ),
          ),
        ),
      ),

      body: Stack(
        children: [
          // Сам WebView (Видео)
          WebViewWidget(controller: _controller),

          // Красивый Overlay (Экран загрузки)
          if (_isLoading)
            Positioned.fill(
              child: Container(
                color: const Color(0xFFF4F7F9),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Светящаяся круглая аватарка мультфильма при загрузке
                    Container(
                      width: 140,
                      height: 140,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF00F5D4).withOpacity(0.4),
                            blurRadius: 25,
                            spreadRadius: 5,
                            offset: const Offset(0, 8),
                          ),
                        ],
                        image: DecorationImage(
                          image: AssetImage(widget.btnCartoonModel.image),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Стильный индикатор
                    const CircularProgressIndicator(
                      color: Color(0xFFF15BB5), // Яркий розовый акцент
                      strokeWidth: 4,
                    ),
                    const SizedBox(height: 20),

                    // Текст с процентами загрузки
                    Text(
                      "Loading Universe... ${(_loadingProgress * 100).toInt()}%",
                      style: const TextStyle(
                        color: Color(0xFF03045E),
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),

      // Плавающая кнопка для открытия в YouTube
      floatingActionButton: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFF15BB5), Color(0xFF9D4EDD)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFF15BB5).withOpacity(0.4), // Цветная тень
              blurRadius: 15,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: FloatingActionButton(
          onPressed: _launchExternal,
          backgroundColor: Colors.transparent, // Фон берется от градиента контейнера
          elevation: 0,
          tooltip: 'Open in YouTube App',
          child: const Icon(Icons.open_in_new_rounded, color: Colors.white, size: 28),
        ),
      ),
    );
  }
}