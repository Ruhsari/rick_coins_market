import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class TwoTradeSale extends StatelessWidget {
  final Function(dynamic val) onAmountChanged;

  const TwoTradeSale({
    super.key,
    required this.onAmountChanged
  });


  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 6),
      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          Text("Offer sale:"),
          SizedBox(
            width: 160,
            height: 50,
            child: TextField(
              onChanged: (value) {
                int val = value.isEmpty ? 0 : int.parse(value);
                onAmountChanged(val);
              },
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],

              decoration: InputDecoration(
                  hintText: "0",
                  contentPadding: EdgeInsets.only(left: 8),
                  border: InputBorder.none
              ),
            ),
          )
        ],
      ),
    );
  }
}
