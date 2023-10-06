import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:save_card/models/bank_card_model.dart';

final listOfSavedCards = StateProvider<List<BankCardModel>>((ref) {
  return [];
});

final showFrontOfCard = StateProvider<bool>((ref) {
  return true;
});

final validCountries = StateProvider<List<String>>((ref) {
  return ['South Africa', 'Namibia', 'Botswana'];
});

final cardNumber = StateProvider<String>((ref) {
  return '0000 0000 0000 0000';
});

final expiryDate = StateProvider<String>((ref) {
  return '00/00';
});

final cvv = StateProvider<String>((ref) {
  return '000';
});

final countryCode = StateProvider<String>((ref) {
  return 'ZA';
});

final nameOnCard = StateProvider<String>((ref) {
  return 'John Doe';
});
