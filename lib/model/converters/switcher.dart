
class Switcher{
  Switcher({this.business,this.userId,this.tableName,this.isClosed,
  this.openingFLoat,this.closingFloat,this.displayText,this.cashierName});

  String cashierName;
  bool isClosed;
  String tableName;
  double openingFLoat;
  double closingFloat;
  String displayText;
  String business;
  String userId;
  

 // ignore: sort_constructors_first
 Switcher.fromData(Map<String, dynamic> data)
      : cashierName = data['cashierName'],
        business = data['business'],
        isClosed = data['isClosed'],
        tableName = data['tableName'],
        openingFLoat = data['openingFLoat'],
        closingFloat = data['closingFloat'],
        displayText = data['displayText'],
        userId = data['userId'];

  Map<String, dynamic> toJson() {
    // ignore: always_specify_types
    return {
      'cashierName': cashierName,
      'isClosed': isClosed,
      'tableName': tableName,
      'openingFLoat':openingFLoat,
      'closingFloat':closingFloat,
      'displayText':displayText,
      'userId': userId,
      'business': business,
    };
  }
}