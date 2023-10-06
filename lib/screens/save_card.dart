/// {@category Screens}
library saved_card_list;

import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:save_card/models/bank_card_model.dart';
import 'package:save_card/utils/theme.dart';
import 'package:save_card/widgets/custom_app_bar.dart';
import 'package:save_card/widgets/custom_text_field.dart';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';

import '../providers/saved_cards_provider.dart';

class SaveCard extends ConsumerStatefulWidget {
  const SaveCard({super.key, required this.id});

  static String route = 'save-card';

  final int id;

  @override
  ConsumerState createState() => _SavedCardsListState();
}

class _SavedCardsListState extends ConsumerState<SaveCard> {

  TextEditingController cardHolderController = TextEditingController();
  TextEditingController cardNumberController = TextEditingController();
  TextEditingController expiryDateController = TextEditingController();
  TextEditingController cvvController = TextEditingController();
  TextEditingController countryCodeController = TextEditingController();

  EncryptedSharedPreferences encryptedSharedPreferences =
      EncryptedSharedPreferences();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Save a Card',
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  AnimatedSwitcher(
                    switchInCurve: Curves.easeInBack,
                    switchOutCurve: Curves.easeOutBack.flipped,
                    layoutBuilder: (widget, list) =>
                        Stack(children: [widget!, ...list]),
                    transitionBuilder: transitionBuilder,
                    duration: const Duration(seconds: 1),
                    reverseDuration: const Duration(seconds: 1),
                    child: ref.watch(showFrontOfCard)
                        ? Material(
                            key: const Key('FrontCard'),
                            borderRadius: BorderRadius.circular(10),
                            elevation: 3,
                            child: AspectRatio(
                                aspectRatio: 1.8,
                                child: Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    gradient:  const LinearGradient(colors: [
                                      ColorPalette.primary,
                                      ColorPalette.secondary
                                    ]),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Icon(Icons.credit_card),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'CARD NUMBER',
                                              style: TextStyle(
                                                  fontFamily: 'OCRB',
                                                  color: Colors.white),
                                            ),
                                            Text(ref.watch(cardNumber),
                                                style: TextStyle(
                                                    fontFamily: 'OCRB',
                                                    color: Colors.white,
                                                    fontSize: 20))
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text('CARD HOLDER',
                                                style: TextStyle(
                                                    fontFamily: 'OCRB',
                                                    color: Colors.white)),
                                            Text(
                                                ref
                                                    .watch(nameOnCard)
                                                    .toUpperCase(),
                                                style: TextStyle(
                                                    fontFamily: 'OCRB',
                                                    color: Colors.white,
                                                    fontSize: 20))
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                )),
                          )
                        : Material(
                            key: const Key('RearCard'),
                            borderRadius: BorderRadius.circular(10),
                            elevation: 3,
                            child: AspectRatio(
                                aspectRatio: 1.8,
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 16),
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(colors: [
                                      ColorPalette.secondary,
                                      ColorPalette.primary
                                    ]),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          height: 40,
                                          color: Colors.black,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text('EXPIRY',
                                                        style: TextStyle(
                                                            fontFamily: 'OCRB',
                                                            color:
                                                                Colors.white)),
                                                    Text(ref.watch(expiryDate),
                                                        style: TextStyle(
                                                            fontFamily: 'OCRB',
                                                            color: Colors.white,
                                                            fontSize: 20))
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text('CVV',
                                                        style: TextStyle(
                                                            fontFamily: 'OCRB',
                                                            color:
                                                                Colors.white)),
                                                    Text(ref.watch(cvv),
                                                        style: TextStyle(
                                                            fontFamily: 'OCRB',
                                                            color: Colors.white,
                                                            fontSize: 20))
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'COUNTRY CODE',
                                                style: TextStyle(
                                                    fontFamily: 'OCRB',
                                                    color: Colors.white),
                                              ),
                                              Text(ref.watch(countryCode),
                                                  style: TextStyle(
                                                      fontFamily: 'OCRB',
                                                      color: Colors.white,
                                                      fontSize: 20))
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )),
                          ),
                  ),
                  // AspectRatio(
                  //     aspectRatio: 1.8,
                  //     child: Container(
                  //       decoration: BoxDecoration(
                  //         gradient: const LinearGradient(
                  //             colors: [ColorPalette.primary, ColorPalette.secondary]),
                  //         borderRadius: BorderRadius.circular(10),
                  //       ),
                  //     )),
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 2),
                          child: AnimatedScale(
                            duration: const Duration(milliseconds: 300),
                            scale: ref.watch(showFrontOfCard) ? 1.2 : 1,
                            child: Icon(Icons.circle,
                                size: 10,
                                color: ref.watch(showFrontOfCard)
                                    ? ColorPalette.primary
                                    : ColorPalette.tertiaryLight),
                          ),
                        ),
                        AnimatedScale(
                          duration: const Duration(milliseconds: 300),
                          scale: ref.watch(showFrontOfCard) ? 1 : 1.2,
                          child: Icon(Icons.circle,
                              size: 10,
                              color: ref.watch(showFrontOfCard)
                                  ? ColorPalette.tertiaryLight
                                  : ColorPalette.primary),
                        )
                      ],
                    ),
                  ),
                  // Text(ref.watch(completeUsernameProvider)),

                  CustomTextField(
                    controller: cardNumberController,
                    onTap: () {
                      ref.read(showFrontOfCard.notifier).state = true;
                    },
                    title: 'Card Number',
                    textInputType: TextInputType.number,
                    maxLength: 16,
                    onChanged: (text) {
                      int spacesAmount = (text.length / 4).ceil() - 1;
                      for (int i = 1; i <= spacesAmount; i++) {
                        text =
                            '${text.substring(0, i * 4 + i - 1)} ${text.substring(i * 4 + i - 1)}';
                      }
                      // if (text.length == 16) {
                      //   FocusNode().nextFocus();
                      // }
                      ref.read(cardNumber.notifier).state = text;
                    },
                  ),
                  CustomTextField(
                    controller: cardHolderController,
                    onTap: () {
                      ref.read(showFrontOfCard.notifier).state = true;
                    },
                    title: 'Name on Card',
                    onChanged: (text) {
                      ref.read(nameOnCard.notifier).state = text;
                    },
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: CustomTextField(
                        onTap: () {
                          ref.read(showFrontOfCard.notifier).state = false;
                        },
                        controller: expiryDateController,
                        maxLength: 5,
                        title: 'Expiry Date',
                        textInputType: TextInputType.number,
                        onChanged: (text) {
                          text = text.replaceAll('/', '');
                          if (text.length >= 3) {
                            text =
                                '${text.substring(0, 2)}/${text.substring(2)}';
                          }
                          expiryDateController
                            ..text = text
                            ..selection = TextSelection(
                                baseOffset: text.length,
                                extentOffset: text.length);
                          ref.read(expiryDate.notifier).state = text;
                        },
                      )),
                      SizedBox(
                        width: 16,
                      ),
                      Expanded(
                          child: CustomTextField(
                            maxLength: 4,
                        controller: cvvController,
                        onTap: () {
                          ref.read(showFrontOfCard.notifier).state = false;
                        },
                        title: 'CVV',
                        textInputType: TextInputType.number,
                        onChanged: (text) {
                          ref.read(cvv.notifier).state = text;
                        },
                      ))
                    ],
                  ),
                  CustomTextField(
                    maxLength: 3,
                    controller: countryCodeController,
                    onTap: () {
                      ref.read(showFrontOfCard.notifier).state = false;
                    },
                    textCapitalization: TextCapitalization.characters,
                    title: 'Country Code',
                    onChanged: (text) {
                      ref.read(countryCode.notifier).state = text;
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
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
            print(
                '${ref.read(cardNumber)}\n${ref.read(nameOnCard)}\n${ref.read(expiryDate)}\n${ref.read(cvv)}\n${ref.read(countryCode)}');
            //TODO: Add validation for country code
            if (cardHolderController.text.isEmpty) {

            } else if (cardNumberController.text.length != 16) {

            } else if (expiryDateController.text.length != 5) {

            } else if ((cvvController.text.length != 4 &&
                cvvController.text.length != 3)) {

            } else if (ref.read(listOfSavedCards).where((element) => element.cardNumber == int.parse(cardNumberController.text)).isEmpty) {

            }else {
              List<BankCardModel> bankCards = [...ref.read(listOfSavedCards)];
              bankCards.add(BankCardModel(
                  id: widget.id,
                  cardNumber: int.parse(cardNumberController.text),
                  cardHolder: cardHolderController.text,
                  expiry: expiryDateController.text,
                  cvv: int.parse(cvvController.text),
                  countryCode: countryCodeController.text));
              // ref.read(listOfSavedCards.notifier).state = bankCards;
              encryptedSharedPreferences
                  .setString(
                      'savedCards',
                      jsonEncode({
                        'cards': [
                          for (BankCardModel card in bankCards) card.toJson()
                        ]
                      }))
                  .then((bool success) async {
                if (success) {
                  ref.read(listOfSavedCards.notifier).state = bankCards;
                  print('save success');
                  context.pop();
                  print(await encryptedSharedPreferences.getString('savedCards'));
                } else {
                  print('save fail');
                }
              });
            }
          },
          child: Text(
            'Save Card',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
      ),
    );
  }

  Widget transitionBuilder(Widget widget, Animation<double> animation) {
    final rotateAnim = Tween(begin: pi, end: 0.0).animate(animation);
    return AnimatedBuilder(
      animation: rotateAnim,
      child: widget,
      builder: (context, widget) {
        final isUnder = (ValueKey(ref.watch(showFrontOfCard)) != widget?.key);
        var tilt = ((animation.value - 0.5).abs() - 0.5) * 0.003;
        tilt *= isUnder ? -1.0 : 1.0;
        final value =
            isUnder ? min(rotateAnim.value, pi / 2) : rotateAnim.value;
        return Transform(
          transform: Matrix4.rotationY(value)..setEntry(3, 0, tilt),
          alignment: Alignment.center,
          child: widget,
        );
      },
    );
  }
}
