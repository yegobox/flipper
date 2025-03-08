// Import from the specified locations in deno.json
import { S3Client, GetObjectCommand } from 'aws-s3';
import { getSignedUrl } from 'aws-presigner';
import { createClient } from '@supabase/supabase-js';
// Direct import for UUID
import { v4 as uuidv4 } from 'https://deno.land/std@0.178.0/uuid/mod.ts';

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

Deno.serve(async (req) => {
  try {
    const { imageInS3, branchId } = await req.json();
    
    if (!imageInS3 || !branchId) {
      return new Response(JSON.stringify({ error: "Missing imageInS3 or branchId" }), {
        status: 400,
        headers: { "Content-Type": "application/json" },
      });
    }
    
    const filePath = `public/invoices-${branchId}/${imageInS3}`;
    
    console.log(`Generating pre-signed URL for: ${filePath}`);
    
    const command = new GetObjectCommand({
        Bucket: s3BucketName,
        Key: filePath,
    });
    
    const signedUrl = await getSignedUrl(s3Client, command, { expiresIn: 60 * 30 }); // 30 minutes
    
    console.log(`Pre-signed URL generated: ${signedUrl}`);
    
    // Generate a unique short URL using crypto API instead of UUID
    const shortUrlId = crypto.randomUUID();
    const shortUrl = `https://ombieopwqgfuzequezeq.supabase.co/functions/v1/urlRedirect/s/${shortUrlId}`;
    
    // Store the mapping in Supabase
    const { data, error } = await supabase
      .from('url_shorteners')
      .insert([
        { long_url: signedUrl, short_url: shortUrl },
      ]);
    
    if (error) {
      console.error('Error storing URL mapping in Supabase:', error);
      return new Response(JSON.stringify({ error: error.message }), {
        status: 500,
        headers: { "Content-Type": "application/json" },
      });
    }
    
    console.log(`Shortened URL: ${shortUrl}`);
    
    return new Response(
      JSON.stringify({ url: shortUrl }),
      { headers: { "Content-Type": "application/json" } }
    );
  } catch (error) {
    console.error("Error generating pre-signed URL:", error);
    return new Response(JSON.stringify({ error: error.message }), {
      status: 500,
      headers: { "Content-Type": "application/json" },
    });
  }
});