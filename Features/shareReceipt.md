// Digital receipt flow (Ditto + edge function):
// 1. User confirms digital receipt in app → queueSmsAfterReceiptUpload(transactionId)
// 2. Receipt PDF uploads to S3 (uploadPdfToS3) → receiptFileName on Ditto transaction
// 3. App invokes generateReceiptUrl with branchId, receipt file name, customer phone
// 4. Edge function presigns S3, stores url_shorteners, queues messages row
// 5. sendSms cron delivers SMS; urlRedirect resolves apihub.yegobox.com/s/{id}
// 6. App sets isDigitalReceiptGenerated on the Ditto transaction