import 'package:flipper/stack.dart';
// import 'package:flutter_money_formatter/flutter_money_formatter.dart';

void main() {
  final stack = Stack<String>();
  stack.push('4');
  stack.push('4');
  // stack.print();
  // print(stack.list);
  // stack.pop();
  // final amount = stack.list.join('');
  // FlutterMoneyFormatter fmf = FlutterMoneyFormatter(
  //   amount: double.parse(amount),
  // );
  print(stack.list.join(''));
  // final top = myStack.pop();
  //start fake
  // final categoryId = Uuid().v1();
  // final String? userId = ProxyService.box.read(key: 'userId');
  // final String? branchId = ProxyService.box.read(key: 'branchId');
  // final Category category = new Category(
  //   id: categoryId,
  //   active: true,
  //   table: AppTables.category,
  //   focused: true,
  //   name: 'NONE',
  //   channels: [userId!],
  //   branchId: branchId!,
  // );
  // await ProxyService.api
  //     .create<Category>(data: category.toJson(), endPoint: 'category');
  // //get default colors for this branch
  // final List<String> colors = [
  //   '#d63031',
  //   '#0984e3',
  //   '#e84393',
  //   '#2d3436',
  //   '#6c5ce7',
  //   '#74b9ff',
  //   '#ff7675',
  //   '#a29bfe'
  // ];
  // final colorId = Uuid().v1();
  // final PColor color = new PColor(
  //   id: colorId,
  //   colors: colors,
  //   table: AppTables.color,
  //   channels: [userId],
  //   active: false,
  //   branchId: branchId,
  // );
  // await ProxyService.api
  //     .create<PColor>(data: color.toJson(), endPoint: 'color');
  // //now create default units for this branch
  //  final unitId = Uuid().v1();
  // final units = new Unit(
  //   name: 'sample',
  //   focused: false,
  //   id: unitId,
  //   table: AppTables.unit,
  //   units: mockUnits,
  //   branchId: branches[0].id,
  //   channels: [userId],
  // );
  // await ProxyService.api.addUnits(data: units.toJson());

  // end of fake
}
