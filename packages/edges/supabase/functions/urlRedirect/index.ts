import { createClient } from '@supabase/supabase-js';

const supabaseUrl = Deno.env.get('SUPABASE_URL')!;
const supabaseKey = Deno.env.get('SUPABASE_ANON_KEY')!;
const supabase = createClient(supabaseUrl, supabaseKey);

export async function handler(req: Request): Promise<Response> {
  const url = new URL(req.url);
  const shortUrlId = url.pathname.split('/').pop(); // Extract shortUrlId from the URL path

  if (!shortUrlId) {
    return new Response('Short URL not found', { status: 404 });
  }

  // Look up the long URL in Supabase
  const { data, error } = await supabase
    .from('url_shorteners')
    .select('long_url')
    .eq('short_url', `https://yourapp.com/s/${shortUrlId}`)
    .single();

  if (error || !data) {
    return new Response('Short URL not found', { status: 404 });
  }

  // Redirect to the long URL
  return Response.redirect(data.long_url, 302);
}
