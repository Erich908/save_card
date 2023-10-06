import 'package:flutter/material.dart';
import 'package:save_card/models/bank_card_model.dart';

import '../utils/theme.dart';

class SavedCard extends StatefulWidget {
  const SavedCard({super.key, required this.card, this.onDeleted});

  final BankCardModel card;
  final VoidCallback? onDeleted;

  @override
  State<SavedCard> createState() => _SavedCardState();
}

class _SavedCardState extends State<SavedCard> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [
                ColorPalette.primary,
                ColorPalette.secondary
              ]),
              borderRadius: BorderRadius.circular(10),
            ),
            height: 80,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('**** **** **** ' + widget.card.cardNumber.toString().substring(12), style: const TextStyle(fontSize: 18, color: Colors.white),),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(widget.card.expiry, style: const TextStyle(fontSize: 18, color: Colors.white),),
                    Text(widget.card.countryCode, style: const TextStyle(fontSize: 18, color: Colors.white))
                  ],
                )
              ],
            ),
          ),
        ),
        IconButton(onPressed: widget.onDeleted, icon: const Icon(Icons.delete_forever, color: ColorPalette.tertiaryLight),)
      ],
    );
  }
}
