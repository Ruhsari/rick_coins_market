import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:rick_coins_market_ruhsari/providers/local_user_provider.dart';

class RickkoinSaleBayWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
      ),
      child: Row(
        children: [
          Text('My offer sale:'),
          SizedBox(
            width: 50,
            child: TextField(
              onChanged: (value) {
                int val = value.isEmpty ? 0 : int.parse(value);
                userProvider.updateSaleIntent(val);
              },
              textInputAction: TextInputAction.done,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "0",
                contentPadding: EdgeInsets.only(left: 8),
                border: InputBorder.none,
              ),
            ),
          ),

          SizedBox(width: 10),
          Text('I will buy: '),
          SizedBox(
            width: 50,
            child: TextField(
              onChanged: (value) {
                int val = value.isEmpty ? 0 : int.parse(value);
                userProvider.updateBuyIntent(val);
              },
              textInputAction: TextInputAction.done,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "0",
                contentPadding: EdgeInsets.only(left: 8),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
