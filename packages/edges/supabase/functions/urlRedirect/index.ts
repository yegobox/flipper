import { createClient } from '@supabase/supabase-js';

// Initialize Supabase with explicit timeout
const supabaseUrl = Deno.env.get('SUPABASE_URL')!;
const supabaseKey = Deno.env.get('SUPABASE_ANON_KEY')!;
const supabase = createClient(supabaseUrl, supabaseKey, {
  auth: {
    persistSession: false,
  },
  global: {
    fetch: (url, options) => {
      // Set a 5-second timeout for all Supabase requests
      const controller = new AbortController();
      const timeoutId = setTimeout(() => controller.abort(), 5000);
      
      return fetch(url, {
        ...options,
        signal: controller.signal
      }).finally(() => clearTimeout(timeoutId));
    }
  }
});

export async function handler(req: Request): Promise<Response> {
  console.log("Handler started");
  
  try {
    // Check if Supabase environment variables are set
    if (!supabaseUrl || !supabaseKey) {
      console.error("Missing Supabase environment variables");
      return new Response('Server configuration error', { status: 500 });
    }
    
    const url = new URL(req.url);
    console.log(`Request URL: ${req.url}`);
    console.log(`Pathname: ${url.pathname}`);
    
    const pathParts = url.pathname.split('/');
    console.log(`Path parts: ${JSON.stringify(pathParts)}`);
    
    const shortUrlId = pathParts.pop();
    console.log(`Extracted shortUrlId: ${shortUrlId}`);
    
    // Validate shortUrlId
    if (!shortUrlId || shortUrlId === '') {
      console.log("Missing shortUrlId");
      return new Response('Short URL ID is missing', { status: 400 });
    }
    
    console.log("About to query Supabase");
    
    // Try a simpler query first to test database connection
    try {
      const testQuery = await supabase
        .from('url_shorteners')
        .select('count')
        .limit(1);
      
      console.log("Test query response:", testQuery);
      
      if (testQuery.error) {
        console.error("Test query failed:", testQuery.error);
        return new Response(`Database connection error: ${testQuery.error.message}`, { status: 500 });
      }
    } catch (testErr) {
      console.error("Test query exception:", testErr);
      return new Response(`Database test failed: ${testErr.message}`, { status: 500 });
    }
    
    // Attempt both field names to see which one works
    console.log("Querying with short_url_id");
    let result = await supabase
      .from('url_shorteners')
      .select('long_url')
      .eq('short_url_id', shortUrlId)
      .maybeSingle();
    
    // If no result, try the other field name
    if (!result.data) {
      console.log("No result with short_url_id, trying short_url");
      result = await supabase
        .from('url_shorteners')
        .select('long_url')
        .eq('short_url', shortUrlId)
        .maybeSingle();
    }
    
    // If still no result, try with the full URL
    if (!result.data) {
      console.log("Trying with full URL format");
      result = await supabase
        .from('url_shorteners')
        .select('long_url')
        .eq('short_url', `https://ombieopwqgfuzequezeq.supabase.co/functions/v1/urlRedirect/s/${shortUrlId}`)
        .maybeSingle();
    }
    
    console.log("Query completed", result);
    
    if (result.error) {
      console.error("Supabase error:", result.error);
      return new Response(`Database error: ${result.error.message}`, { status: 500 });
    }
    
    if (!result.data || !result.data.long_url) {
      console.log("URL not found in database");
      return new Response('Short URL not found in database', { status: 404 });
    }
    
    const longUrl = result.data.long_url;
    console.log(`Found long URL: ${longUrl}`);
    
    // Validate the long URL before redirecting
    try {
      new URL(longUrl); // This will throw if the URL is invalid
      console.log("URL is valid, redirecting");
      return Response.redirect(longUrl, 302);
    } catch (urlError) {
      console.error("Invalid URL in database:", urlError);
      return new Response('Invalid redirect URL stored in database', { status: 500 });
    }
  } catch (err) {
    console.error("Unexpected error:", err);
    return new Response(`Server error: ${err instanceof Error ? err.message : String(err)}`, { status: 500 });
  }
}