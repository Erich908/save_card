/// {@category Providers}
library validated_cards_provider;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:save_card/models/bank_card_model.dart';

///This stores the list of Successfully Validated Cards.
final listOfSavedCards = StateProvider<List<BankCardModel>>((ref) {
  return [];
});

///This stores the boolean for if the front of the credit card should show.
final showFrontOfCard = StateProvider<bool>((ref) {
  return true;
});

///This stores the unbanned countries that cards can be from.
final validCountries = StateProvider<List<String>>((ref) {
  return ['South Africa', 'Namibia', 'Botswana'];
});

///This stores the card number.
final cardNumber = StateProvider<String>((ref) {
  return '0000 0000 0000 0000';
});

///This stores the card's expiry date.
final expiryDate = StateProvider<String>((ref) {
  return '00/00';
});

///This stores the card's cvv.
final cvv = StateProvider<String>((ref) {
  return '000';
});

///This stores the card's country of issue.
final countryCode = StateProvider<String>((ref) {
  return 'ZA';
});

///This stores the card holder's name.
final nameOnCard = StateProvider<String>((ref) {
  return 'John Doe';
});
