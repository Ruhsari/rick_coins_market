import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rick_coins_market_ruhsari/components/two_trade_by.dart';
import 'package:rick_coins_market_ruhsari/components/two_trade_sale.dart';
import 'package:rick_coins_market_ruhsari/providers/local_user_provider.dart';

class TwoPersonTradePage extends StatefulWidget {
  final String nickname;
  final String uid;

  const TwoPersonTradePage({
    super.key,
    required this.nickname,
    required this.uid,
  });

  @override
  State<TwoPersonTradePage> createState() => _TwoPersonTradePageState();
}

class _TwoPersonTradePageState extends State<TwoPersonTradePage> {
  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _chatController = TextEditingController();

  int _mySellOffer = 0;
  int _myBuyOffer = 0;
  late UserProvider _userProviderRef;
  late String _currentUserId;
  late String _chatRoomId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _userProviderRef = Provider.of<UserProvider>(context, listen: false);
    _currentUserId = FirebaseAuth.instance.currentUser?.uid ?? "";
    _chatRoomId = _getChatRoomId(_currentUserId, widget.uid);
  }

  @override
  void dispose() {
    _messageController.dispose();
    _chatController.dispose();
    super.dispose();
  }

  String _getChatRoomId(String user1, String user2) {
    List<String> ids = [user1, user2];
    ids.sort();
    return ids.join("_");
  }

  void _sendMessage() async {
    if (_chatController.text.trim().isEmpty) return;

    String text = _chatController.text;
    _chatController.clear();

    await FirebaseFirestore.instance
        .collection('chat_rooms')
        .doc(_chatRoomId)
        .collection('messages')
        .add({
      'senderId': _currentUserId,
      'text': text,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  void _sendProposal() {
    _userProviderRef.updateIndividualOffer(
      _myBuyOffer,
      _mySellOffer,
      widget.uid,
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Proposal sent! 🚀", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Color(0xFF0077B6),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F9), // Единый фон
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Color(0xFF03045E)),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.handshake_rounded, color: Color(0xFFF15BB5)),
            const SizedBox(width: 8),
            Text(
              widget.nickname,
              style: const TextStyle(
                color: Color(0xFF03045E),
                fontWeight: FontWeight.w900,
                fontSize: 20,
              ),
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: Colors.black.withOpacity(0.05),
            height: 1.0,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // ==========================================
            // ВЕРХНЯЯ ПОЛОВИНА: БЛОК ТОРГОВЛИ
            // ==========================================
            Expanded(
              flex: 1,
              child: StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('user_persons')
                    .doc(widget.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator(color: Color(0xFF00F5D4)));
                  }

                  var partnerData = snapshot.data!.data() as Map<String, dynamic>? ?? {};

                  int partnerWantsToSell = 0;
                  int partnerWantToBuy = 0;

                  if (partnerData['targetPartnerId'] == _currentUserId) {
                    partnerWantsToSell = partnerData['individualSell'] ?? 0;
                    partnerWantToBuy = partnerData['individualBuy'] ?? 0;
                  }

                  return SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Твое предложение
                        const Text(
                          "My Private Proposal 💼",
                          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: Color(0xFF03045E)),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4))],
                          ),
                          child: Column(
                            children: [
                              TwoTradeSale(onAmountChanged: (val) => _mySellOffer = val),
                              const SizedBox(height: 12),
                              TwoTradeBuy(onAmountChanged: (val) => _myBuyOffer = val),
                              const SizedBox(height: 16),

                              // Современная кнопка отправки
                              SizedBox(
                                width: double.infinity,
                                child: GestureDetector(
                                  onTap: _sendProposal,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 14),
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [Color(0xFF00F5D4), Color(0xFF0077B6)],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: [
                                        BoxShadow(color: const Color(0xFF0077B6).withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 4)),
                                      ],
                                    ),
                                    child: const Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.send_rounded, color: Colors.white, size: 18),
                                        SizedBox(width: 8),
                                        Text("Send Proposal", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Предложение партнера
                        const Text(
                          "Partner's Proposal 🤝",
                          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: Color(0xFF03045E)),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4))],
                          ),
                          child: Column(
                            children: [
                              if (partnerWantsToSell == 0 && partnerWantToBuy == 0)
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Text("Waiting for partner's offer...", style: TextStyle(color: Colors.grey[500], fontStyle: FontStyle.italic)),
                                ),
                              if (partnerWantsToSell > 0)
                                _buildPartnerOfferRow(
                                  label: "Wants to sell:",
                                  amount: partnerWantsToSell,
                                  gradient: const LinearGradient(colors: [Color(0xFFF15BB5), Color(0xFF9D4EDD)]),
                                  shadowColor: const Color(0xFFF15BB5),
                                  onAccept: () => Navigator.pushNamed(
                                    context,
                                    '/payment',
                                    arguments: {
                                      'partnerUid': widget.uid,
                                      'passed_amount': partnerWantsToSell,
                                      'partnerNickname': widget.nickname,
                                      'pageLable': 'from_two_person_trade',
                                    },
                                  ),
                                ),
                              if (partnerWantsToSell > 0 && partnerWantToBuy > 0)
                                const Divider(height: 16, indent: 20, endIndent: 20),
                              if (partnerWantToBuy > 0)
                                _buildPartnerOfferRow(
                                  label: "Wants to buy:",
                                  amount: partnerWantToBuy,
                                  gradient: const LinearGradient(colors: [Color(0xFF38EF7D), Color(0xFF11998E)]),
                                  shadowColor: const Color(0xFF38EF7D),
                                  onAccept: () async {
                                    try {
                                      await userProvider.acceptIndividualBuy(widget.uid, partnerWantToBuy);
                                      setState(() {
                                        _mySellOffer = 0;
                                        _myBuyOffer = 0;
                                      });
                                      if (context.mounted) {
                                        _showSuccessDialog(context, partnerWantToBuy);
                                      }
                                    } catch (e) {
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
                                    }
                                  },
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // ==========================================
            // НИЖНЯЯ ПОЛОВИНА: ЧАТ НА ДВОИХ
            // ==========================================
            Expanded(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 15,
                      offset: const Offset(0, -5),
                    )
                  ],
                ),
                child: Column(
                  children: [
                    // Маленький "хвостик" сверху панели чата
                    Container(
                      margin: const EdgeInsets.only(top: 10, bottom: 5),
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10)),
                    ),

                    // Список сообщений
                    Expanded(
                      child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('chat_rooms')
                            .doc(_chatRoomId)
                            .collection('messages')
                            .orderBy('timestamp', descending: true)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) return const Center(child: Text('Error loading chat'));
                          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());

                          final docs = snapshot.data!.docs;
                          if (docs.isEmpty) {
                            return Center(child: Text("No messages yet. Say hi! 👋", style: TextStyle(color: Colors.grey[400])));
                          }

                          return ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            reverse: true,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            itemCount: docs.length,
                            itemBuilder: (context, index) {
                              var data = docs[index].data() as Map<String, dynamic>;
                              bool isMe = data['senderId'] == _currentUserId;
                              return _buildMessageBubble(data, isMe);
                            },
                          );
                        },
                      ),
                    ),

                    // Поле ввода сообщения
                    Container(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border(top: BorderSide(color: Colors.grey.withOpacity(0.1))),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFFF4F7F9),
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: TextField(
                                controller: _chatController,
                                decoration: const InputDecoration(
                                  hintText: 'Type a message...',
                                  hintStyle: TextStyle(color: Colors.grey),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          GestureDetector(
                            onTap: _sendMessage,
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Color(0xFFF15BB5), Color(0xFF9D4EDD)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                shape: BoxShape.circle,
                                boxShadow: [BoxShadow(color: const Color(0xFFF15BB5).withOpacity(0.4), blurRadius: 10, offset: const Offset(0, 4))],
                              ),
                              child: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Обновленная строка предложения (с градиентными кнопками)
  Widget _buildPartnerOfferRow({
    required String label,
    required int amount,
    required LinearGradient gradient,
    required Color shadowColor,
    required VoidCallback onAccept,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("$label  $amount Rc\$", style: const TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF495057), fontSize: 15)),
          GestureDetector(
            onTap: onAccept,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                gradient: gradient,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(color: shadowColor.withOpacity(0.4), blurRadius: 8, offset: const Offset(0, 3))],
              ),
              child: const Text("Accept", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  // Современные текстовые облака чата
  Widget _buildMessageBubble(Map<String, dynamic> data, bool isMe) {
    String formattedTime = "";
    if (data['timestamp'] != null) {
      DateTime time = (data['timestamp'] as Timestamp).toDate();
      formattedTime = "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";
    }

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          gradient: isMe
              ? const LinearGradient(colors: [Color(0xFF00F5D4), Color(0xFF0077B6)], begin: Alignment.topLeft, end: Alignment.bottomRight)
              : null,
          color: isMe ? null : const Color(0xFFF4F7F9),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20),
            topRight: const Radius.circular(20),
            bottomLeft: Radius.circular(isMe ? 20 : 0),
            bottomRight: Radius.circular(isMe ? 0 : 20),
          ),
          boxShadow: [
            BoxShadow(
              color: isMe ? const Color(0xFF0077B6).withOpacity(0.2) : Colors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: const Offset(0, 3),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              data['text'] ?? '',
              style: TextStyle(
                fontSize: 15,
                color: isMe ? Colors.white : const Color(0xFF2B2D42),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              formattedTime,
              style: TextStyle(
                fontSize: 10,
                color: isMe ? Colors.white70 : Colors.grey[500],
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Новое диалоговое окно успеха (в стиле PaymentPage)
  void _showSuccessDialog(BuildContext context, int amount) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        contentPadding: const EdgeInsets.all(24),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle_rounded, color: Color(0xFF38EF7D), size: 80),
            const SizedBox(height: 16),
            const Text("Success!", style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Color(0xFF03045E))),
            const SizedBox(height: 12),
            Text(
              "You successfully sold $amount Rickcoins.\nThe payment has been sent to your BankCard account.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[700], height: 1.4),
            ),
          ],
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF38EF7D),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
              },
              child: const Text("Awesome!", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }
}