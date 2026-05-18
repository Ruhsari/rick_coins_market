class DealModel {
  final int amount;
  final String currentUserId;
  final String partnerId;
  final String partnerNickname;
  final String dealType;
  final DateTime date;
  final String walletType;
  DealModel({
    required this.amount,
    required this.currentUserId,
    required this.partnerId,
    required this.partnerNickname,
    required this.dealType,
    required this.date,
    this.walletType = "PayPal",

  });

}