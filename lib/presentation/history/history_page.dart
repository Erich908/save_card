/// {@category Screens}
library history_page;

import 'dart:convert';

import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:save_card/app/engine/router.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:save_card_ui_kit/widgets/custom_app_bar.dart';
import 'package:save_card_ui_kit/widgets/validated_card.dart';
import 'package:save_card_ui_kit/utils/theme.dart';
import 'package:save_card_core/src/domain/bank_card/bank_card_model.dart';
import 'package:save_card_core/providers/validated_cards_provider.dart';

///This screen displays the cards that have been validated successfully before.
///You can also delete the cards.
@RoutePage()
class HistoryPage extends ConsumerStatefulWidget {
  const HistoryPage({super.key});

  @override
  ConsumerState<HistoryPage> createState() => _SavedCardsListState();
}

class _SavedCardsListState extends ConsumerState<HistoryPage> {

  AndroidOptions _getAndroidOptions() => const AndroidOptions(
    encryptedSharedPreferences: true,
  );
  late final FlutterSecureStorage storage;
  @override
  void initState() {
    storage = FlutterSecureStorage(aOptions: _getAndroidOptions());
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      String savedCardsString =
          await storage.read(key: 'savedCards') ?? '';
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
            context.router.push(ValidateRoute(id: listOfCards.isNotEmpty ? listOfCards.last.id + 1 : 1 ), );
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
                          try {
                            storage
                                .write(
                                key: 'savedCards',
                                value: jsonEncode({
                                  'cards': [
                                    for (BankCardModel card in bankCards)
                                      card.toJson()
                                  ]
                                }));
                            ref.read(listOfSavedCards.notifier).state =
                                bankCards;
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Card Removed')));
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Failed Card Removal')));
                          }
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
                    child: Text(
              'You have no successfully validated cards',
              style: TextStyle(fontSize: 16),
            ))),
          )
        ],
      ),
    );
  }
}
