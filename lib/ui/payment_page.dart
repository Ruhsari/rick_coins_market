import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rick_coins_market_ruhsari/providers/local_user_provider.dart';

class PaymentPage extends StatefulWidget {
  final String partnerUid;
  final int passed_amount;
  final String partnerNickname;
  final String pageLable;

  const PaymentPage({
    super.key,
    required this.partnerUid,
    required this.passed_amount,
    required this.partnerNickname,
    required this.pageLable,
  });

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  late TextEditingController _amountController;
  late int _chosenAmount;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController();
    if (widget.pageLable == "from_two_person_trade") {
      _chosenAmount = widget.passed_amount;
    } else {
      if (widget.pageLable == "from_info_page") {
        _chosenAmount = 0;
      }
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F9), // Единый светлый фон
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF03045E)),
        title: const Text(
          "Payment",
          style: TextStyle(
            color: Color(0xFF03045E),
            fontWeight: FontWeight.w900,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF00F5D4), Color(0xFF0077B6)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF00B4D8).withOpacity(0.4), // Свечение
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Text(
                    "Total Payment",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "\$${_chosenAmount * 10}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "For $_chosenAmount RickCoins",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            if (widget.pageLable == "from_info_page")
              Padding(
                padding: const EdgeInsets.only(bottom: 24.0),
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      )
                    ],
                  ),
                  child: TextField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "How many Rick-Coins to buy?",
                      labelStyle: TextStyle(color: Colors.grey[500]),
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: const Icon(Icons.add_shopping_cart, color: Color(0xFF9D4EDD)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onChanged: (val) {
                      setState(() {
                        _chosenAmount = int.tryParse(val) ?? 0;
                      });
                    },
                  ),
                ),
              ),

            // Заголовок методов оплаты
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Select Payment Method",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF03045E),
                ),
              ),
            ),
            const SizedBox(height: 16),

            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.3,
              children: [
                _paymentCard(
                  context: context,
                  nameBankCard: "VISA/MASTER",
                  partnerNickname: widget.partnerNickname,
                  gradient: const LinearGradient(colors: [Color(0xFFFF512F), Color(0xFFDD2476)]),
                  shadowColor: const Color(0xFFFF512F),
                  icon: Icons.credit_card_rounded,
                ),
                _paymentCard(
                  context: context,
                  nameBankCard: "PAYPAL",
                  partnerNickname: widget.partnerNickname,
                  gradient: const LinearGradient(colors: [Color(0xFF4FACFE), Color(0xFF00F2FE)]),
                  shadowColor: const Color(0xFF4FACFE),
                  icon: Icons.account_balance_wallet_rounded,
                ),
                _paymentCard(
                  context: context,
                  nameBankCard: "M-BANK",
                  partnerNickname: widget.partnerNickname,
                  gradient: const LinearGradient(colors: [Color(0xFF11998E), Color(0xFF38EF7D)]),
                  shadowColor: const Color(0xFF11998E),
                  icon: Icons.account_balance_rounded,
                ),
                _paymentCard(
                  context: context,
                  nameBankCard: "O BANK",
                  partnerNickname: widget.partnerNickname,
                  gradient: const LinearGradient(colors: [Color(0xFFB92B27), Color(0xFF1565C0)]),
                  shadowColor: const Color(0xFFB92B27),
                  icon: Icons.phone_android_rounded,
                ),
              ],
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // Обновленный виджет карточки банка
  Widget _paymentCard({
    required BuildContext context,
    required String nameBankCard,
    required String partnerNickname,
    required LinearGradient gradient,
    required Color shadowColor,
    required IconData icon,
  }) {
    return GestureDetector(
      onTap: () {
        if (_chosenAmount <= 0) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Please enter an amount first!")),
          );
          return;
        }
        _showConfirmationDialog(context, nameBankCard, partnerNickname);
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: shadowColor.withOpacity(0.4),
              blurRadius: 12,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 36),
            const SizedBox(height: 8),
            Text(
              nameBankCard,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showConfirmationDialog(
      BuildContext context,
      String nameBankCard,
      String partnerNickname,
      ) {
    final userProvider = context.read<UserProvider>();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text(
          'Confirm Transaction',
          style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF03045E)),
        ),
        content: Text(
          "Confirming will withdraw USD \$${_chosenAmount * 10} "
              "from your $nameBankCard wallet "
              "to buy $_chosenAmount Rickcoins from $partnerNickname.",
          style: const TextStyle(fontSize: 15, height: 1.4),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cancel", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0077B6),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () async {
              try {
                await userProvider.acceptIndividualSell(
                  widget.partnerUid,
                  _chosenAmount,
                );
                if (context.mounted) {
                  Navigator.pop(context);
                  _showFinalSuccess(context, nameBankCard, partnerNickname);
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      "Transaction failed. Try again later.\nError: $e",
                    ),
                  ),
                );
              }
            },
            child: const Text("PAY NOW", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _showFinalSuccess(
      BuildContext context,
      String nameBankCard,
      String partnerNickname,
      ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        contentPadding: const EdgeInsets.all(24),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.check_circle_rounded,
              color: Color(0xFF38EF7D),
              size: 80,
            ),
            const SizedBox(height: 16),
            const Text(
              "Success!",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: Color(0xFF03045E),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              "Your $nameBankCard-wallet has been withdrawn by "
                  "\$${_chosenAmount * 10} to buy $_chosenAmount "
                  "Rickcoins from $partnerNickname.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[700], height: 1.4),
            ),
            const SizedBox(height: 16),
            Text(
              "Date: ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}",
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
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
              child: const Text("OK", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }
}