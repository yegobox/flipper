import { S3Client, GetObjectCommand } from 'aws-s3';
import { getSignedUrl } from 'aws-presigner';
import { createClient } from '@supabase/supabase-js';
// Direct import for UUID
//import { v4 as uuidv4 } from 'https://deno.land/std@0.178.0/uuid/mod.ts'; // Not needed anymore

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
    const { imageInS3, branchId, shortUrlId: existingShortUrlId } = await req.json(); // Destructure existingShortUrlId

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

    let shortUrlId = existingShortUrlId;  // Assign value to shortUrlId

    if (!existingShortUrlId) {
      // Generate a unique short URL using crypto API if not provided
      shortUrlId = crypto.randomUUID().substring(0, 4);
    }

    // Store/Update the mapping in Supabase
    let supabaseResult;
    if (existingShortUrlId) {
       // Update existing record if shortUrlId exists
       console.log(`Updating existing short URL: ${existingShortUrlId}`);
        supabaseResult = await supabase
        .from('url_shorteners')
        .update({ long_url: signedUrl })
        .eq('short_url_id', existingShortUrlId);


    } else {
      //Insert new record if shortUrlId does not exists
      console.log(`Creating new short URL: ${shortUrlId}`);
      supabaseResult = await supabase
      .from('url_shorteners')
      .insert([
        { long_url: signedUrl, short_url_id: shortUrlId },
      ]);
    }


    const { data, error } = supabaseResult;  //Destructure data and error from supabaseResult
    
    if (error) {
      console.error('Error storing/updating URL mapping in Supabase:', error);
      return new Response(JSON.stringify({ error: error.message }), {
        status: 500,
        headers: { "Content-Type": "application/json" },
      });
    }

    console.log(`Shortened URL: ${shortUrlId}`);

    return new Response(
      JSON.stringify({ url: shortUrlId }),
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