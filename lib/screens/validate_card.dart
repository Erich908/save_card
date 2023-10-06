import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:save_card/models/bank_card_model.dart';
import 'package:save_card/utils/theme.dart';
import 'package:save_card/widgets/custom_app_bar.dart';
import 'package:save_card/widgets/custom_text_field.dart';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:ml_card_scanner/ml_card_scanner.dart';

import '../providers/validated_cards_provider.dart';

class SaveCard extends ConsumerStatefulWidget {
  const SaveCard({super.key, required this.id});

  static String route = 'save-card';

  final int id;

  @override
  ConsumerState createState() => _SavedCardsListState();
}

class _SavedCardsListState extends ConsumerState<SaveCard> {
  final ScannerWidgetController _controller = ScannerWidgetController();
  late BuildContext bottomSheetContext;

  TextEditingController cardHolderController = TextEditingController();
  TextEditingController cardNumberController = TextEditingController();
  TextEditingController expiryDateController = TextEditingController();
  TextEditingController cvvController = TextEditingController();
  TextEditingController countryCodeController = TextEditingController();

  EncryptedSharedPreferences encryptedSharedPreferences =
      EncryptedSharedPreferences();

  String cardType = '';

  @override
  void initState() {
    _controller
      .setCardListener((value) {
        String cardNumberScanned = value!.number;
        cardNumberController.text = cardNumberScanned;
        ref.read(cardNumber.notifier).state = cardNumberScanned;
        setCardType(cardNumberScanned);
        Navigator.of(bottomSheetContext).pop();
      });

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.invalidate(cardNumber);
      ref.invalidate(nameOnCard);
      ref.invalidate(cvv);
      ref.invalidate(expiryDate);
      ref.invalidate(countryCode);
      ref.invalidate(showFrontOfCard);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Validate a Card',
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
                    switchOutCurve: Curves.easeInBack.flipped,
                    layoutBuilder: (widget, list) =>
                        Stack(children: [widget!, ...list]),
                    transitionBuilder: transitionBuilder,
                    duration: const Duration(milliseconds: 800),
                    child: ref.watch(showFrontOfCard)
                        ? Material(
                            key: const ValueKey(true),
                            borderRadius: BorderRadius.circular(10),
                            elevation: 3,
                            child: AspectRatio(
                                aspectRatio: 1.8,
                                child: Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(colors: [
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
                                        cardType.isEmpty
                                            ? Icon(
                                                Icons.credit_card,
                                                color: Colors.white,
                                              )
                                            : SvgPicture.asset(cardType),
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
                            key: const ValueKey(false),
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
                                                'COUNTRY OF ISSUE',
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

                  Row(
                    children: [
                      Expanded(
                        child: CustomTextField(
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
                            setCardType(text);
                            ref.read(cardNumber.notifier).state = text;
                          },
                        ),
                      ),
                      IconButton(
                          onPressed: () {
                            showModalBottomSheet(context: context, isScrollControlled: true, builder: (context) {
                              bottomSheetContext = context;
                              return Expanded(
                                child: ScannerWidget(
                                  controller: _controller,
                                  overlayOrientation: CardOrientation.landscape,
                                ),
                              );
                            });
                          },
                          icon: Transform.rotate(
                              angle: pi / 2,
                              child: Icon(Icons.document_scanner_outlined)))
                    ],
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
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextField(
                          controller: countryCodeController,
                          onTap: () {
                            ref.read(showFrontOfCard.notifier).state = false;
                          },
                          textCapitalization: TextCapitalization.words,
                          title: 'Country of Issue',
                          onChanged: (text) {
                            ref.read(countryCode.notifier).state = text;
                          },
                        ),
                      ),
                      IconButton(
                          onPressed: () {
                            showModalBottomSheet(
                                context: context,
                                builder: (context) {
                                  List<String> countries =
                                      ref.read(validCountries);
                                  TextEditingController addCountryController =
                                      TextEditingController();
                                  return StatefulBuilder(
                                      builder: (context, bottomSheetSetState) {
                                    return Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: Column(
                                        children: [
                                          Text(
                                            'Valid Countries',
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                  child: CustomTextField(
                                                title: 'Country Name',
                                                controller:
                                                    addCountryController,
                                              )),
                                              Container(
                                                width: 70,
                                                margin:
                                                    EdgeInsets.only(left: 8),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  gradient:
                                                      const LinearGradient(
                                                          colors: [
                                                        ColorPalette.primary,
                                                        ColorPalette.secondary
                                                      ]),
                                                ),
                                                height: 40,
                                                child: TextButton(
                                                  onPressed: () {
                                                    bottomSheetSetState(() {
                                                      countries.add(
                                                          addCountryController
                                                              .text);
                                                      ref
                                                          .read(validCountries
                                                          .notifier)
                                                          .state = countries;
                                                    });
                                                    FocusScope.of(context).unfocus();
                                                  },
                                                  child: Text(
                                                    'Add',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 18),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Expanded(
                                            child: ListView(
                                              children: [
                                                for (String country
                                                    in countries)
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(country),
                                                      IconButton(
                                                          onPressed: () {
                                                            bottomSheetSetState(
                                                                () {
                                                              countries.remove(
                                                                  countries.firstWhere(
                                                                      (element) =>
                                                                          element ==
                                                                          country));
                                                              ref
                                                                  .read(validCountries
                                                                      .notifier)
                                                                  .state = countries;
                                                            });
                                                          },
                                                          icon: Icon(
                                                              Icons.delete))
                                                    ],
                                                  )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  });
                                });
                          },
                          icon: Icon(Icons.settings))
                    ],
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
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Name on Card is Required')));
            } else if (cardNumberController.text.length != 16) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Card Number must be 16 digits')));
            } else if (expiryDateController.text.length != 5) {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Expiry Date is Invalid')));
            } else if (int.parse(expiryDateController.text.substring(0, 2)) > 31 || DateTime(int.parse('20${expiryDateController.text.substring(3)}'), int.parse(expiryDateController.text.substring(0, 2))).add(Duration(days: 31)).compareTo(DateTime.now()) < 0) {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Expiry Date is Invalid')));
            } else if ((cvvController.text.length != 4 &&
                cvvController.text.length != 3)) {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('CVV is Invalid')));
            } else if (ref
                .read(listOfSavedCards)
                .where((element) =>
                    element.cardNumber == int.parse(cardNumberController.text))
                .isNotEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('You have Validated this Card already')));
            } else if (!ref
                .read(validCountries)
                .contains(countryCodeController.text)) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Country Misspelled or Banned')));
            } else {
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
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Card is Valid')));
                  print(
                      await encryptedSharedPreferences.getString('savedCards'));
                } else {
                  print('save fail');
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Card is Invalid')));
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

  void setCardType(String text) {
    if (text.startsWith('4')) {
      setState(() {
        cardType = 'lib/icons/visa.svg';
      });
    } else if (text.startsWith('5')) {
      setState(() {
        cardType = 'lib/icons/mastercard.svg';
      });
    } else if (text.startsWith('34') ||
        text.startsWith('37')) {
      setState(() {
        cardType = 'lib/icons/american-express.svg';
      });
    } else {
      setState(() {
        cardType = '';
      });
    }
  }
}
