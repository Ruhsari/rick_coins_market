import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rick_coins_market_ruhsari/providers/local_user_provider.dart';

class MessageCreateWidget extends StatefulWidget {
  @override
  State<MessageCreateWidget> createState() => _MessageCreateWidgetState();
}

class _MessageCreateWidgetState extends State<MessageCreateWidget> {
  late TextEditingController _m_controller;

  @override
  void initState() {
    super.initState();
    _m_controller = TextEditingController();
  }

  @override
  void dispose() {
    _m_controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _m_controller,
              onChanged: (text) {
                userProvider.updateMarketMessage(text);
              },
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.text,

              decoration: const InputDecoration(
                hintText: "Your message...",
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
