class PerformanceData {
  final double netSales;
  final double grossSales;
  final int transactionCount;
  final double previousNetSales;
  final double previousGrossSales;
  final int previousTransactionCount;
  final List<HourlySales> hourlySales;

  PerformanceData({
    required this.netSales,
    required this.grossSales,
    required this.transactionCount,
    required this.previousNetSales,
    required this.previousGrossSales,
    required this.previousTransactionCount,
    required this.hourlySales,
  });

  double get netSalesChange => previousNetSales == 0 ? 0 : ((netSales - previousNetSales) / previousNetSales) * 100;
  double get grossSalesChange => previousGrossSales == 0 ? 0 : ((grossSales - previousGrossSales) / previousGrossSales) * 100;
  double get transactionChange => previousTransactionCount == 0 ? 0 : ((transactionCount - previousTransactionCount) / previousTransactionCount) * 100;
}

class HourlySales {
  final int hour;
  final double amount;

  HourlySales({required this.hour, required this.amount});
}