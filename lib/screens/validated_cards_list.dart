/// {@category Screens}
library validated_cards_list;

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:save_card/models/bank_card_model.dart';
import 'package:save_card/providers/validated_cards_provider.dart';
import 'package:save_card/screens/validate_card.dart';
import 'package:save_card/widgets/custom_app_bar.dart';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:save_card/widgets/validated_card.dart';

import '../utils/theme.dart';

///This screen displays the cards that have been validated successfully before.
///You can also delete the cards.
class SavedCardsList extends ConsumerStatefulWidget {
  const SavedCardsList({super.key});

  @override
  ConsumerState<SavedCardsList> createState() => _SavedCardsListState();
}

class _SavedCardsListState extends ConsumerState<SavedCardsList> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      String savedCardsString =
          await EncryptedSharedPreferences().getString('savedCards');
      if (savedCardsString.isNotEmpty) {
        ref.read(listOfSavedCards.notifier).state = [
          for (Map<String, dynamic> cardMap
              in jsonDecode(savedCardsString)['cards'])
            BankCardModel.fromJson(cardMap)
        ];
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<BankCardModel> listOfCards = ref.watch(listOfSavedCards);

    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Validated Cards',
        removeBackButton: true,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: const LinearGradient(
              colors: [ColorPalette.primary, ColorPalette.secondary]),
        ),
        margin: EdgeInsets.all(16),
        height: 50,
        child: TextButton(
          onPressed: () {
            context.pushNamed(SaveCard.route, pathParameters: {
              'id': (listOfCards.isNotEmpty ? listOfCards.last.id + 1 : 1)
                  .toString()
            });
          },
          child: Text(
            'Add Card',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
      ),
      body: Column(
        children: [
          Visibility(
            visible: listOfCards.isNotEmpty,
            child: Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 16),
                children: [
                  Text(
                      '${listOfCards.length} Card${listOfCards.length == 1 ? '' : 's'}'),
                  for (BankCardModel card in listOfCards)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: SavedCard(
                        card: card,
                        onDeleted: () {
                          List<BankCardModel> bankCards = [
                            ...ref.read(listOfSavedCards)
                          ];
                          bankCards
                              .removeWhere((element) => element.id == card.id);
                          EncryptedSharedPreferences()
                              .setString(
                                  'savedCards',
                                  jsonEncode({
                                    'cards': [
                                      for (BankCardModel card in bankCards)
                                        card.toJson()
                                    ]
                                  }))
                              .then((bool success) {
                            if (success) {
                              ref.read(listOfSavedCards.notifier).state =
                                  bankCards;
                            }
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Card Removed')));
                        },
                      ),
                    )
                ],
              ),
            ),
          ),
          Visibility(
            visible: listOfCards.isEmpty,
            child: Expanded(
                child: Center(
                    child: Text('You have no successfully validated cards', style: TextStyle(fontSize: 16),))),
          )
        ],
      ),
    );
  }
}
