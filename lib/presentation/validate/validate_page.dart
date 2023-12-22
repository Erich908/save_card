/// {@category Screens}
library validate_page;

import 'dart:convert';
import 'dart:math';
import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ml_card_scanner/ml_card_scanner.dart';
import 'package:save_card_core/src/application/validate/validate_bloc.dart';
import 'package:save_card_core/src/application/history/history_bloc.dart';
import 'package:save_card_core/src/domain/bank_card/bank_card_model.dart';
import 'package:save_card_ui_kit/widgets/custom_app_bar.dart';
import 'package:save_card_ui_kit/widgets/custom_text_field.dart';
import 'package:save_card_ui_kit/utils/theme.dart';


///This screen is used for the purpose of Validating a Bank Card and will only
///store the card in local storage if has been validated successfully.

@RoutePage()
class ValidatePage extends StatefulWidget {
  const ValidatePage({super.key, required this.id});

  ///Route for GoRouter.
  static String route = 'save-card';

  ///Id of the card that will be saved.
  final int id;

  @override
  State<ValidatePage> createState() => _ValidatePageState();
}

class _ValidatePageState extends State<ValidatePage> {

  ///The controller used for the Card Scanner.
  final ScannerWidgetController _controller = ScannerWidgetController();

  ///The context that will be set by the showModalBottomSheet builder so the
  ///bottom sheet can be dismissed externally.
  late BuildContext bottomSheetContext;

  TextEditingController cardHolderController = TextEditingController();
  TextEditingController cardNumberController = TextEditingController();
  TextEditingController expiryDateController = TextEditingController();
  TextEditingController cvvController = TextEditingController();
  TextEditingController countryCodeController = TextEditingController();

  ///Shared preference instance to save a valid card to local storage.
  AndroidOptions _getAndroidOptions() => const AndroidOptions(
    encryptedSharedPreferences: true,
  );
  late final FlutterSecureStorage storage;

  final validateBloc = ValidateBloc();
  final historyBloc = HistoryBloc();

  ///Filename of SVG that should be show to indicate the card type.
  String cardType = '';

  @override
  void initState() {
    storage = FlutterSecureStorage(aOptions: _getAndroidOptions());
    _controller.setCardListener((value) {
      String cardNumberScanned = value!.number;
      cardNumberController.text = cardNumberScanned;
      validateBloc.add(ChangeCardNumber(cardNumberScanned));
      setCardType(cardNumberScanned);
      Navigator.of(bottomSheetContext).pop();
    });

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      validateBloc.add(ResetValues());
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
                    child:
                    validateBloc.state.showFrontOfCard
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
                                      ? const Icon(
                                    Icons.credit_card,
                                    color: Colors.white,
                                  )
                                      : SvgPicture.asset(cardType),
                                  Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'CARD NUMBER',
                                        style: TextStyle(
                                            fontFamily: 'OCRB',
                                            color: Colors.white),
                                      ),
                                      Text(validateBloc.state.cardNumber,
                                          style: const TextStyle(
                                              fontFamily: 'OCRB',
                                              color: Colors.white,
                                              fontSize: 20))
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      const Text('CARD HOLDER',
                                          style: TextStyle(
                                              fontFamily: 'OCRB',
                                              color: Colors.white)),
                                      Text(
                                          validateBloc.state.nameOnCard
                                              .toUpperCase(),
                                          style: const TextStyle(
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
                            padding: const EdgeInsets.symmetric(vertical: 16),
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
                                              const Text('EXPIRY',
                                                  style: TextStyle(
                                                      fontFamily: 'OCRB',
                                                      color:
                                                      Colors.white)),
                                              Text(validateBloc.state.expiryDate,
                                                  style: const TextStyle(
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
                                              const Text('CVV',
                                                  style: TextStyle(
                                                      fontFamily: 'OCRB',
                                                      color:
                                                      Colors.white)),
                                              Text(validateBloc.state.cvv,
                                                  style: const TextStyle(
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
                                        const Text(
                                          'COUNTRY OF ISSUE',
                                          style: TextStyle(
                                              fontFamily: 'OCRB',
                                              color: Colors.white),
                                        ),
                                        Text(validateBloc.state.countryCode,
                                            style: const TextStyle(
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
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 2),
                          child: AnimatedScale(
                            duration: const Duration(milliseconds: 300),
                            scale: validateBloc.state.showFrontOfCard ? 1.2 : 1,
                            child: Icon(Icons.circle,
                                size: 10,
                                color: validateBloc.state.showFrontOfCard
                                    ? ColorPalette.primary
                                    : ColorPalette.tertiaryLight),
                          ),
                        ),
                        AnimatedScale(
                          duration: const Duration(milliseconds: 300),
                          scale: validateBloc.state.showFrontOfCard ? 1 : 1.2,
                          child: Icon(Icons.circle,
                              size: 10,
                              color: validateBloc.state.showFrontOfCard
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
                            validateBloc.add(ChangeShowFrontOfCard(true));
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
                            validateBloc.add(ChangeCardNumber(text));
                          },
                        ),
                      ),
                      IconButton(
                          onPressed: () {
                            showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                builder: (context) {
                                  bottomSheetContext = context;
                                  return Expanded(
                                    child: ScannerWidget(
                                      controller: _controller,
                                      overlayOrientation:
                                      CardOrientation.landscape,
                                    ),
                                  );
                                });
                          },
                          icon: Transform.rotate(
                              angle: pi / 2,
                              child: const Icon(Icons.document_scanner_outlined)))
                    ],
                  ),
                  CustomTextField(
                    controller: cardHolderController,
                    onTap: () {
                      validateBloc.add(ChangeShowFrontOfCard(true));
                    },
                    title: 'Name on Card',
                    onChanged: (text) {
                      validateBloc.add(ChangeNameOnCard(text));
                    },
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: CustomTextField(
                            onTap: () {
                              validateBloc.add(ChangeShowFrontOfCard(false));
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
                              validateBloc.add(ChangeExpiryDate(text));
                            },
                          )),
                      const SizedBox(
                        width: 16,
                      ),
                      Expanded(
                          child: CustomTextField(
                            maxLength: 4,
                            controller: cvvController,
                            onTap: () {
                              validateBloc.add(ChangeShowFrontOfCard(false));
                            },
                            title: 'CVV',
                            textInputType: TextInputType.number,
                            onChanged: (text) {
                              validateBloc.add(ChangeCVV(text));
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
                            validateBloc.add(ChangeShowFrontOfCard(false));
                          },
                          textCapitalization: TextCapitalization.words,
                          title: 'Country of Issue',
                          onChanged: (text) {
                            validateBloc.add(ChangeCountryCode(text));
                          },
                        ),
                      ),
                      IconButton(
                          onPressed: () {
                            showModalBottomSheet(
                                context: context,
                                builder: (context) {
                                  List<String> countries = validateBloc.state.validCountries;
                                  TextEditingController addCountryController =
                                  TextEditingController();
                                  return StatefulBuilder(
                                      builder: (context, bottomSheetSetState) {
                                        return Padding(
                                          padding: const EdgeInsets.all(16),
                                          child: Column(
                                            children: [
                                              const Text(
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
                                                    const EdgeInsets.only(left: 8),
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
                                                          validateBloc.add(ChangeValidCountries(countries));
                                                        });
                                                        FocusScope.of(context)
                                                            .unfocus();
                                                      },
                                                      child: const Text(
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
                                                                      validateBloc.add(ChangeValidCountries(countries));
                                                                    });
                                                              },
                                                              icon: const Icon(
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
                          icon: const Icon(Icons.settings))
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
        margin: const EdgeInsets.all(16),
        height: 50,
        child: TextButton(
          onPressed: () async {
            if (cardHolderController.text.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Name on Card is Required')));
            } else if (cardNumberController.text.length != 16) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Card Number must be 16 digits')));
            } else if (expiryDateController.text.length != 5) {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Expiry Date is Invalid')));
            } else if (int.parse(expiryDateController.text.substring(0, 2)) >
                31 ||
                DateTime(
                    int.parse(
                        '20${expiryDateController.text.substring(3)}'),
                    int.parse(
                        expiryDateController.text.substring(0, 2)))
                    .add(const Duration(days: 31))
                    .compareTo(DateTime.now()) <
                    0) {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Expiry Date is Invalid')));
            } else if ((cvvController.text.length != 4 &&
                cvvController.text.length != 3)) {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('CVV is Invalid')));
            } else if (
            historyBloc.state.listOfSavedCards
                .where((element) =>
            element.cardNumber == int.parse(cardNumberController.text))
                .isNotEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('You have Validated this Card already')));
            } else if (!validateBloc.state.validCountries
                .contains(countryCodeController.text)) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Country Misspelled or Banned')));
            } else {
              List<BankCardModel> bankCards = [...historyBloc.state.listOfSavedCards];
              bankCards.add(BankCardModel(
                  id: widget.id,
                  cardNumber: int.parse(cardNumberController.text),
                  cardHolder: cardHolderController.text,
                  expiry: expiryDateController.text,
                  cvv: int.parse(cvvController.text),
                  countryCode: countryCodeController.text));
              try {
                await storage.write(key: 'savedCards', value: jsonEncode({
                  'cards': [
                    for (BankCardModel card in bankCards) card.toJson()
                  ]
                }));
                historyBloc.add(ChangeSavedCardList(bankCards));
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Card is Valid')));
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Card is Invalid')));
              }
            }
          },
          child: const Text(
            'Save Card',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
      ),
    );
  }

  ///The transition builder used to flip the card around when specific text
  ///fields are focused.
  Widget transitionBuilder(Widget widget, Animation<double> animation) {
    final rotateAnim = Tween(begin: pi, end: 0.0).animate(animation);
    return AnimatedBuilder(
      animation: rotateAnim,
      child: widget,
      builder: (context, widget) {
        final isUnder = (ValueKey(validateBloc.state.showFrontOfCard) != widget?.key);
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

  ///Returns the file path of the SVG used to indicate card type.
  void setCardType(String text) {
    if (text.startsWith('4')) {
      setState(() {
        cardType = 'lib/icons/visa.svg';
      });
    } else if (text.startsWith('5')) {
      setState(() {
        cardType = 'lib/icons/mastercard.svg';
      });
    } else if (text.startsWith('34') || text.startsWith('37')) {
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
