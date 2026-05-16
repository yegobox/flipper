// @ts-nocheck
// Request-driven receipt URLs. Transaction state lives in Ditto; this function
// only presigns S3, stores url_shorteners, and optionally queues SMS (messages).

import { S3Client, GetObjectCommand, HeadObjectCommand } from "aws-s3";
import { getSignedUrl } from "aws-presigner";
import { createClient } from "@supabase/supabase-js";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type",
};

const jsonHeaders = { ...corsHeaders, "Content-Type": "application/json" };

const supabaseUrl = Deno.env.get("SUPABASE_URL")!;
const supabaseKey = Deno.env.get("SUPABASE_ANON_KEY")!;
const s3BucketName = Deno.env.get("S3_BUCKET_NAME")!;
const s3Region = Deno.env.get("S3_REGION")!;
const awsAccessKeyId = Deno.env.get("AWS_ACCESS_KEY_ID")!;
const awsSecretAccessKey = Deno.env.get("AWS_SECRET_ACCESS_KEY")!;

const supabase = createClient(supabaseUrl, supabaseKey, {
  global: { fetch: (...args) => fetch(...args) },
});

const s3Client = new S3Client({
  region: s3Region,
  credentials: {
    accessKeyId: awsAccessKeyId,
    secretAccessKey: awsSecretAccessKey,
  },
});

const SMS_TEMPLATE = "Your Receipt is ready for download: ";
const BASE_SHORT_URL = "https://apihub.yegobox.com/s/";
const PRESIGN_EXPIRY_SEC = 60 * 60 * 24 * 7;

async function resolveS3Key(
  branchId: string,
  fileName: string,
): Promise<string> {
  const candidates = [
    `public/invoices-${branchId}/${fileName}`,
    `invoices-${branchId}/${fileName}`,
    `invoices/${fileName}`,
    fileName,
  ];

  for (const key of candidates) {
    try {
      await s3Client.send(
        new HeadObjectCommand({ Bucket: s3BucketName, Key: key }),
      );
      console.log(`S3 object found: ${key}`);
      return key;
    } catch {
      console.log(`S3 object not at: ${key}`);
    }
  }

  throw new Error(`Receipt file not found in S3: ${fileName}`);
}

async function presignGetUrl(s3Key: string): Promise<string> {
  const command = new GetObjectCommand({ Bucket: s3BucketName, Key: s3Key });
  return await getSignedUrl(s3Client, command, {
    expiresIn: PRESIGN_EXPIRY_SEC,
  });
}

async function storeShortUrl(
  longUrl: string,
  existingShortUrlId?: string,
): Promise<string> {
  const shortUrlId =
    existingShortUrlId || crypto.randomUUID().substring(0, 4);

  const result = existingShortUrlId
    ? await supabase
        .from("url_shorteners")
        .update({ long_url: longUrl })
        .eq("short_url_id", shortUrlId)
        .select()
    : await supabase
        .from("url_shorteners")
        .insert({ long_url: longUrl, short_url_id: shortUrlId })
        .select();

  if (result.error) {
    throw new Error(`Failed to store short URL: ${result.error.message}`);
  }

  return shortUrlId;
}

async function queueReceiptSms(
  phone: string,
  branchId: string,
  shortUrlId: string,
): Promise<void> {
  const messageText = `${SMS_TEMPLATE}${BASE_SHORT_URL}${shortUrlId}`;
  const { error } = await supabase.from("messages").insert({
    text: messageText,
    phone_number: phone,
    branch_id: branchId,
  });

  if (error) {
    throw new Error(`Failed to queue SMS: ${error.message}`);
  }
}

async function handleRenew(renewUrl: string): Promise<Response> {
  if (!renewUrl.startsWith(BASE_SHORT_URL)) {
    return new Response(JSON.stringify({ error: "Invalid short URL format" }), {
      status: 400,
      headers: jsonHeaders,
    });
  }

  const shortUrlId = renewUrl.replace(BASE_SHORT_URL, "");
  console.log(`Renewing short URL: ${shortUrlId}`);

  const { data: existingUrl, error: lookupError } = await supabase
    .from("url_shorteners")
    .select("*")
    .eq("short_url_id", shortUrlId)
    .single();

  if (lookupError || !existingUrl) {
    return new Response(
      JSON.stringify({
        error: lookupError?.message || "Short URL not found",
        code: "URL_NOT_FOUND",
      }),
      { status: 404, headers: jsonHeaders },
    );
  }

  const urlObj = new URL(existingUrl.long_url);
  let keyParam = urlObj.searchParams.get("Key");
  if (!keyParam) {
    const pathParts = urlObj.pathname.split("/");
    keyParam = pathParts.filter((part) => part.length > 0).pop();
  }
  if (!keyParam) {
    return new Response(
      JSON.stringify({ error: "Could not extract file path from stored URL" }),
      { status: 500, headers: jsonHeaders },
    );
  }

  try {
    await s3Client.send(
      new HeadObjectCommand({ Bucket: s3BucketName, Key: keyParam }),
    );
  } catch {
    return new Response(
      JSON.stringify({ error: `Receipt file no longer exists: ${keyParam}` }),
      { status: 404, headers: jsonHeaders },
    );
  }

  const newSignedUrl = await presignGetUrl(keyParam);
  const { error: updateError } = await supabase
    .from("url_shorteners")
    .update({ long_url: newSignedUrl, updated_at: new Date().toISOString() })
    .eq("short_url_id", shortUrlId);

  if (updateError) {
    return new Response(JSON.stringify({ error: updateError.message }), {
      status: 500,
      headers: jsonHeaders,
    });
  }

  return new Response(
    JSON.stringify({
      url: shortUrlId,
      short_url_ids: [shortUrlId],
      success: true,
      renewed: true,
    }),
    { headers: jsonHeaders },
  );
}

async function handleCreateReceiptLink(body: Record<string, unknown>): Promise<Response> {
  const branchId = String(body.branchId ?? "");
  const fileName = String(
    body.imageInS3 ?? body.receiptFileName ?? "",
  );
  const phone = body.phone != null ? String(body.phone) : "";
  const sendSms = body.sendSms !== false;
  const existingShortUrlId = body.shortUrlId
    ? String(body.shortUrlId)
    : undefined;
  const transactionId = body.transactionId
    ? String(body.transactionId)
    : undefined;

  if (!branchId || !fileName) {
    return new Response(
      JSON.stringify({
        error: "Missing branchId and imageInS3/receiptFileName",
        hint:
          "POST from the app after S3 upload. Transactions are in Ditto, not Supabase.",
      }),
      { status: 400, headers: jsonHeaders },
    );
  }

  console.log(
    `Receipt link request branch=${branchId} file=${fileName} tx=${transactionId ?? "n/a"}`,
  );

  const s3Key = await resolveS3Key(branchId, fileName);
  const signedUrl = await presignGetUrl(s3Key);
  const shortUrlId = await storeShortUrl(signedUrl, existingShortUrlId);

  let smsQueued = false;
  if (sendSms && phone.trim()) {
    await queueReceiptSms(phone.trim(), branchId, shortUrlId);
    smsQueued = true;
  }

  return new Response(
    JSON.stringify({
      url: shortUrlId,
      short_url_ids: [shortUrlId],
      short_url: `${BASE_SHORT_URL}${shortUrlId}`,
      success: true,
      sms_queued: smsQueued,
      transaction_id: transactionId,
    }),
    { headers: jsonHeaders },
  );
}

Deno.serve(async (req) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  try {
    let body: Record<string, unknown> | null = null;
    try {
      body = await req.json();
    } catch {
      body = null;
    }

    if (!body || Object.keys(body).length === 0) {
      return new Response(
        JSON.stringify({
          error: "Request body required",
          hint:
            "Cron polling of Supabase transactions was removed. Invoke from the Flipper app after uploading a receipt PDF to S3.",
        }),
        { status: 400, headers: jsonHeaders },
      );
    }

    if (body.renewUrl) {
      return await handleRenew(String(body.renewUrl));
    }

    return await handleCreateReceiptLink(body);
  } catch (error) {
    console.error("generateReceiptUrl error:", error);
    return new Response(
      JSON.stringify({
        error: error instanceof Error ? error.message : String(error),
      }),
      { status: 500, headers: jsonHeaders },
    );
  }
});
