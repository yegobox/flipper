/// this is a duplicate of what is in constant, I should have used the same class for constants
/// but because I am rushing then recreatted it later will use the one in constatd in future
class TransactionType {
  static const String cashIn = 'Cash In';
  static const String cashOut = 'Cash Out';
  static const String sale = 'Sale';
  static const String purchase = 'Purchase';
  static const String adjustment = 'adjustment';
  static const String importation = 'Import';
  static const String salary = 'Salary';
  static const String transport = 'Transport';
  static const String airtime = 'Airtime';
  static const List<String> acceptedCashOuts = [salary, transport, airtime];
}

