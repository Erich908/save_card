/// {@category Models}
library bank_card_model;

class BankCardModel {
  final int id;
  final int cardNumber;
  final String cardHolder;
  final String expiry;
  final int cvv;
  final String countryCode;

  BankCardModel({
    required this.id,
    required this.cardNumber,
    required this.cardHolder,
    required this.expiry,
    required this.cvv,
    required this.countryCode,
  });

  factory BankCardModel.fromJson(Map<String, dynamic> json) {
    return BankCardModel(
        id: json['id'] ?? 0,
        cardNumber: json['cardNumber'] ?? 0,
        cardHolder: json['cardHolder'] ?? '',
        expiry: json['expiry'] ?? '',
        cvv: json['cvv'] ?? 0,
        countryCode: json['countryCode'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cardNumber': cardNumber,
      'cardHolder': cardHolder,
      'expiry': expiry,
      'cvv': cvv,
      'countryCode': countryCode
    };
  }
}
