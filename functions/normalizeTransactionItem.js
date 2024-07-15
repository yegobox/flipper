exports = async function ({ query }) {
    const branchId = query.branchId;
  
    if (!branchId) {
      return { message: 'branchId is required' };
    }
  
    const mongodb = context.services.get("mongodb-atlas");
    const db = mongodb.db("flipper");
    const transactionCollection = db.collection("TransactionItem");
    const variantCollection = db.collection("Variant");
  
    // Get all TransactionItems for the given branchId
    const transactionItems = await transactionCollection.find({ branchId }).toArray();
  
    let updatedCount = 0;
  
    for (const transaction of transactionItems) {
      // Get the variantId from the TransactionItem
      const variantId = transaction.variantId;
  
      // Find the corresponding variant in the Variant collection
      const variant = await variantCollection.findOne({ id: variantId });
  
      if (variant) {
        // Update the splyAmt of the TransactionItem to be the supplyPrice of the variant
        await transactionCollection.updateOne(
          { _id: transaction._id },
          { $set: { splyAmt: variant.supplyPrice } }
        );
        updatedCount++;
      } else {
        console.error(`Variant with ID ${variantId} not found.`);
      }
    }
  
    return { message: `TransactionItems updated successfully. ${updatedCount} items updated.` };
  };
  