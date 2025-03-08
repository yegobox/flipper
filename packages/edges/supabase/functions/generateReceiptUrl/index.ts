// @ts-nocheck

import { S3Client, GetObjectCommand, HeadObjectCommand } from 'aws-s3';
import { getSignedUrl } from 'aws-presigner';
import { createClient } from '@supabase/supabase-js';

console.log("Generate Pre-signed URL Function Started!")

const supabaseUrl = Deno.env.get('SUPABASE_URL')!
const supabaseKey = Deno.env.get('SUPABASE_ANON_KEY')!
const s3BucketName = Deno.env.get('S3_BUCKET_NAME')!
const s3Region = Deno.env.get('S3_REGION')!
const awsAccessKeyId = Deno.env.get('AWS_ACCESS_KEY_ID')!
const awsSecretAccessKey = Deno.env.get('AWS_SECRET_ACCESS_KEY')!

const supabase = createClient(supabaseUrl, supabaseKey, {
    global: {
        fetch: (...args) => fetch(...args),
    },
});

const s3Client = new S3Client({
  region: s3Region,
  credentials: {
      accessKeyId: awsAccessKeyId,
      secretAccessKey: awsSecretAccessKey
  }
});

const SMS_TEMPLATE = "Your Receipt is ready for download: ";
const BASE_SHORT_URL = "https://apihub.yegobox.com/s/";

Deno.serve(async (req) => {
  try {
    let requestBody = null; // Initialize as null
    try {
      requestBody = await req.json();
    } catch (jsonError) {
      //This is intentional to deal with case where request has no body
      console.log("No JSON body provided or invalid JSON, assuming no body");
    }

    if (!requestBody || Object.keys(requestBody).length === 0) { //Check for null as well
      console.log("No request body provided, fetching transactions...");

      // First, let's check if the transactions table exists and has any data
      console.log("Step 1: Checking if transactions table has any data");
      const { data: allTransactions, error: countError } = await supabase
        .from('transactions')
        .select('count')
        .limit(1);

      if (countError) {
        console.error("Error accessing transactions table:", countError);
        return new Response(JSON.stringify({
          error: countError.message,
          suggestion: "Check if the transactions table exists and your connection has proper permissions"
        }), {
          status: 500,
          headers: { "Content-Type": "application/json" },
        });
      }

      console.log(`Total transactions in table: ${allTransactions?.length > 0 ? 'some records exist' : 'no records found'}`);

      // Now check completed transactions
      console.log("Step 2: Checking completed transactions");
      const { data: completedTransactions, error: completedError } = await supabase
        .from('transactions')
        .select('count')
        .eq('status', 'completed')
        .limit(1);

      if (completedError) {
        console.error("Error querying completed transactions:", completedError);
        return new Response(JSON.stringify({
          error: completedError.message,
          suggestion: "Check if the 'status' column exists in the transactions table"
        }), {
          status: 500,
          headers: { "Content-Type": "application/json" },
        });
      }

      console.log(`Completed transactions: ${completedTransactions?.length > 0 ? 'some exist' : 'none found'}`);

      // Then check if any need receipt generation
      console.log("Step 3: Checking transactions needing receipt generation");
      const { data: needReceiptTransactions, error: needReceiptError } = await supabase
        .from('transactions')
        .select('count')
        .eq('status', 'completed')
        .eq('is_digital_receipt_generated', false)
        .limit(1);

      if (needReceiptError) {
        console.error("Error querying for receipt generation:", needReceiptError);
        return new Response(JSON.stringify({
          error: needReceiptError.message,
          suggestion: "Check if the 'is_digital_receipt_generated' column exists in the transactions table"
        }), {
          status: 500,
          headers: { "Content-Type": "application/json" },
        });
      }

      console.log(`Transactions needing receipt generation: ${needReceiptTransactions?.length > 0 ? 'some exist' : 'none found'}`);

      // Finally perform the actual query with all needed fields
      console.log("Step 4: Fetching transactions with all criteria and required fields");
      const { data: transactions, error } = await supabase
        .from('transactions')
        .select('id, receipt_file_name, branch_id, current_sale_customer_phone_number') //Include branch_id and phone number in the select statement
        .eq('status', 'completed')
        .eq('is_digital_receipt_generated', false)
        .order('created_at', { ascending: false })
        .limit(100);

      if (error) {
        console.error("Error fetching transactions:", error);
        return new Response(JSON.stringify({ error: error.message }), {
          status: 500,
          headers: { "Content-Type": "application/json" },
        });
      }

      // Check for missing receipt_file_name
      const transactionsWithReceipts = transactions?.filter(t => t.receipt_file_name) || [];
      const transactionsWithoutReceipts = transactions?.filter(t => !t.receipt_file_name) || [];
      console.log(`Transactions with receipt_file_name: ${transactionsWithReceipts.length}`);
      console.log(`Transactions missing receipt_file_name: ${transactionsWithoutReceipts.length}`);

      console.log(`Found ${transactions?.length || 0} transactions to process`);

      if (!transactions || transactions.length === 0) {
        return new Response(JSON.stringify({ message: "No transactions to process" }), {
          headers: { "Content-Type": "application/json" },
        });
      }

      const results = [];
      const errors = [];
      let filePath = ''; // Define filePath outside the loop to update it

      for (const transaction of transactions) {
        try {
          if (!transaction.receipt_file_name) {
            console.log(`Skipping transaction ${transaction.id} - no receipt file name`);
            continue;
          }

          if (!transaction.branch_id) {
            console.log(`Skipping transaction ${transaction.id} - no branch_id`);
            continue;
          }

          if (!transaction.current_sale_customer_phone_number) {
            console.log(`Skipping transaction ${transaction.id} - no current_sale_customer_phone_number`);
            continue;
          }

          // Make sure the path matches where your files are actually stored
          filePath = `public/invoices-${transaction.branch_id}/${transaction.receipt_file_name}`; //Use branch_id here
          console.log(`Processing transaction ${transaction.id}, initial file path: ${filePath}`);

          // Verify the file exists in S3 before trying to generate a URL
          let fileFound = false;

          try {
            const headCommand = new HeadObjectCommand({ Bucket: s3BucketName, Key: filePath });
            await s3Client.send(headCommand);
            console.log(`File confirmed to exist in S3: ${filePath}`);
            fileFound = true;
          } catch (headError) {
            console.error(`File does not exist at initial path ${filePath} in S3:`, headError.message);

            // Try alternative path formats
            const alternativePaths = [
              `invoices-${transaction.branch_id}/${transaction.receipt_file_name}`,
              `invoices/${transaction.receipt_file_name}`,
              `${transaction.receipt_file_name}`
            ];

            for (const altPath of alternativePaths) {
              try {
                console.log(`Trying alternative path: ${altPath}`);
                const altHeadCommand = new HeadObjectCommand({ Bucket: s3BucketName, Key: altPath });
                await s3Client.send(altHeadCommand);
                console.log(`File found at alternative path: ${altPath}`);
                filePath = altPath; // Update file path if found
                fileFound = true;
                break; // Exit the loop once the file is found
              } catch (altError) {
                console.log(`File not found at alternative path: ${altPath}, error: ${altError.message}`);
              }
            }

            if (!fileFound) {
              throw new Error(`Receipt file not found in S3 after trying alternative paths: ${transaction.receipt_file_name}`);
            }
          }

          if (fileFound) {
            try {
              const command = new GetObjectCommand({ Bucket: s3BucketName, Key: filePath });
              const signedUrl = await getSignedUrl(s3Client, command, { expiresIn: 60 * 60 * 24 * 7 } );// 604800 seconds (1 week));
              const shortUrlId = crypto.randomUUID().substring(0, 4);

              console.log(`Generated signed URL for ${filePath}, creating short URL: ${shortUrlId}`);

              // Insert the URL shortener record
              const { data: shortenerData, error: shortenerError } = await supabase
                .from('url_shorteners')
                .insert({
                  long_url: signedUrl,
                  short_url_id: shortUrlId,
                })
                .select();

              if (shortenerError) {
                throw new Error(`Failed to insert URL shortener: ${shortenerError.message}`);
              }

              //Insert the message
              const messageText = `${SMS_TEMPLATE} ${BASE_SHORT_URL}${shortUrlId}`;
              const { data: messageData, error: messageError } = await supabase
                .from('messages')
                .insert({
                    text: messageText,
                    phone_number: transaction.current_sale_customer_phone_number
                })
                .select();

              if(messageError) {
                  console.error(`Failed to insert message: ${messageError.message}`);
                  //Decide whether to throw an error here.  If message insertion fails, should we stop the entire process?
                  //For now, we'll just log the error and continue.
              }

              // Update the transaction
              const { data: updateData, error: updateError } = await supabase
                .from('transactions')
                .update({ is_digital_receipt_generated: true })
                .eq('id', transaction.id)
                .select();

              if (updateError) {
                throw new Error(`Failed to update transaction: ${updateError.message}`);
              }

              console.log(`Successfully processed transaction ${transaction.id} with short URL ${shortUrlId}`);
              results.push({ transaction_id: transaction.id, short_url_id: shortUrlId });
            } catch (s3Error) {
              console.error(`S3 or database error for transaction ${transaction.id}:`, s3Error);
              errors.push({ transaction_id: transaction.id, error: s3Error.message });
            }
          } else {
            console.warn(`File not found in S3 for transaction ${transaction.id} after all attempts.`);
            errors.push({transaction_id: transaction.id, error: "File not found in S3"});
          }
        } catch (transactionError) {
          console.error(`Error processing transaction ${transaction.id}:`, transactionError);
          errors.push({ transaction_id: transaction.id, error: transactionError.message });
        }
      }

      // Extract just the short URL IDs for easy access
      const shortUrlIds = results.map(result => result.short_url_id);

      return new Response(JSON.stringify({
        message: "Processed transactions",
        success_count: results.length,
        error_count: errors.length,
        short_url_ids: shortUrlIds,
        results,
        errors: errors.length > 0 ? errors : undefined,
        debug_info: {
          total_transactions_fetched: transactions?.length || 0,
          transactions_with_receipt_files: transactionsWithReceipts.length,
          transactions_without_receipt_files: transactionsWithoutReceipts.length
        }
      }), {
        headers: { "Content-Type": "application/json" },
      });
    }

    // Handle request with body
    const { imageInS3, branchId, shortUrlId: existingShortUrlId } = requestBody;
    if (!imageInS3 || !branchId) {
      return new Response(JSON.stringify({ error: "Missing imageInS3 or branchId" }), {
        status: 400,
        headers: { "Content-Type": "application/json" },
      });
    }

    const filePath = `public/invoices-${branchId}/${imageInS3}`;
    console.log(`Generating pre-signed URL for: ${filePath}`);

    try {
      const command = new GetObjectCommand({ Bucket: s3BucketName, Key: filePath });
      const signedUrl = await getSignedUrl(s3Client, command, { expiresIn: 60 * 60 * 24 * 90 });
      console.log(`Pre-signed URL generated: ${signedUrl}`);

      let shortUrlId = existingShortUrlId || crypto.randomUUID().substring(0, 4);
      let supabaseResult;

      if (existingShortUrlId) {
        console.log(`Updating existing short URL: ${existingShortUrlId}`);
        supabaseResult = await supabase
          .from('url_shorteners')
          .update({ long_url: signedUrl })
          .eq('short_url_id', existingShortUrlId)
          .select();
      } else {
        console.log(`Creating new short URL: ${shortUrlId}`);
        supabaseResult = await supabase
          .from('url_shorteners')
          .insert([{ long_url: signedUrl, short_url_id: shortUrlId }])
          .select();
      }

      const { data, error } = supabaseResult;
      if (error) {
        console.error('Error storing/updating URL mapping in Supabase:', error);
        return new Response(JSON.stringify({ error: error.message }), {
          status: 500,
          headers: { "Content-Type": "application/json" },
        });
      }

      return new Response(JSON.stringify({
        url: shortUrlId,
        short_url_ids: [shortUrlId],
        success: true
      }), {
        headers: { "Content-Type": "application/json" },
      });
    } catch (s3Error) {
      console.error(`Error generating pre-signed URL for ${filePath}:`, s3Error);
      return new Response(JSON.stringify({ error: s3Error.message }), {
        status: 500,
        headers: { "Content-Type": "application/json" },
      });
    }
  } catch (error) {
    console.error("Error in request handler:", error);
    return new Response(JSON.stringify({ error: error.message }), {
      status: 500,
      headers: { "Content-Type": "application/json" },
    });
  }
});