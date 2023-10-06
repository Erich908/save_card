/// {@category Widgets}
library validated_card;

import 'package:flutter/material.dart';
import 'package:save_card/models/bank_card_model.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../utils/theme.dart';

///The widget used to display a summary of a successfully validated card.
class SavedCard extends StatefulWidget {
  const SavedCard({super.key, required this.card, this.onDeleted});

  ///The card info that will be used for the summary.
  final BankCardModel card;
  ///Action triggered when the delete button is pressed.
  final VoidCallback? onDeleted;

  @override
  State<SavedCard> createState() => _SavedCardState();
}

class _SavedCardState extends State<SavedCard> {

  String firstTwoDigits = '';
  @override
  void initState() {
    firstTwoDigits = widget.card.cardNumber.toString().substring(0, 2);
    super.initState();
  }
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('**** **** **** ' + widget.card.cardNumber.toString().substring(12), style: const TextStyle(fontSize: 18, color: Colors.white),),
                        Text(widget.card.expiry, style: const TextStyle(fontSize: 18, color: Colors.white),),
                      ],
                    ),
                    SvgPicture.asset(firstTwoDigits.startsWith('4') ? 'lib/icons/visa.svg' : firstTwoDigits.startsWith('5') ? 'lib/icons/mastercard.svg' : 'lib/icons/american-express.svg')
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
