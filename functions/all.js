exports = async function () {
  const mongodb = context.services.get("mongodb-atlas");
  const db = mongodb.db("flipper");
  const transactionCollection = db.collection("TransactionItem");
  const stockCollection = db.collection("Stock");
  const expenseCollection = db.collection("ITransaction");
  const computedCollection = db.collection("Computed");

  // Define the branchId and businessId
  const branchId = 2;
  const businessId = 2;

  // Calculate totalSoldValue
  const totalSoldValuePipeline = [
    { $match: { branchId: branchId } },
    {
      $group: {
        _id: null,
        totalSoldValue: { $sum: { $multiply: ["$qty", "$price"] } }
      }
    }
  ];

  const totalSoldValueResult = await transactionCollection.aggregate(totalSoldValuePipeline).toArray();
  const totalSoldValue = totalSoldValueResult.length > 0 ? totalSoldValueResult[0].totalSoldValue : 0;

  // Calculate totalStockValue
  const totalStockValuePipeline = [
    { $match: { branchId: branchId, currentStock: { $gt: 0 } } },
    {
      $group: {
        _id: null,
        totalStockValue: { $sum: { $multiply: ["$currentStock", "$retailPrice"] } }
      }
    }
  ];

  const totalStockValueResult = await stockCollection.aggregate(totalStockValuePipeline).toArray();
  const totalStockValue = totalStockValueResult.length > 0 ? totalStockValueResult[0].totalStockValue : 0;

  // Calculate totalStockItems
  const totalStockItemsPipeline = [
    { $match: { branchId: branchId } },
    {
      $group: {
        _id: null,
        totalStockItems: { $sum: "$currentStock" }
      }
    }
  ];

  const totalStockItemsResult = await stockCollection.aggregate(totalStockItemsPipeline).toArray();
  const totalStockItems = totalStockItemsResult.length > 0 ? totalStockItemsResult[0].totalStockItems : 0;

  // Calculate total expenses where isExpense is true, expenses are for business not for the branch hence we use businessId
  const totalExpensesPipeline = [
    { $match: { businessId: businessId, isExpense: true } },
    {
      $group: {
        _id: null,
        totalExpenses: { $sum: "$amount" }
      }
    }
  ];

  const totalExpensesResult = await expenseCollection.aggregate(totalExpensesPipeline).toArray();
  const totalExpenses = totalExpensesResult.length > 0 ? totalExpensesResult[0].totalExpenses : 0;

  // Calculate netProfit as totalSoldValue minus totalExpenses
  const netProfit = totalSoldValue - totalExpenses;

  // Prepare the result document
  const result = {
    branchId: branchId,
    businessId: businessId,
    totalStockValue: totalStockValue,
    totalStockSoldValue: totalSoldValue,
    totalStockItems: totalStockItems,
    grossProfit: totalSoldValue, // Adjust this logic as per your requirement
    netProfit: netProfit
  };

  // Insert the result into Computed collection
  result._id = new BSON.ObjectId();
  const insertResult = await computedCollection.insertOne(result);

  return insertResult;
};
