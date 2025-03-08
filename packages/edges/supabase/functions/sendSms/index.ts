// @ts-nocheck

import { createClient } from '@supabase/supabase-js';

const supabaseUrl = Deno.env.get('SUPABASE_URL')!
const supabaseKey = Deno.env.get('SUPABASE_ANON_KEY')!
const yegoboxBearerToken = Deno.env.get('YEGOBOX_BEARER_TOKEN')!;

const supabase = createClient(supabaseUrl, supabaseKey, {
    global: {
        fetch: (...args) => fetch(...args),
    },
});

const SMS_API_URL = "https://apihub.yegobox.com/v2/api/sms-broadcast";

async function sendSMS(text, phoneNumber) {
    const smsBody = {
        text: text,
        numberList: [phoneNumber]
    };

    const response = await fetch(SMS_API_URL, {
        method: "POST",
        headers: {
            "Content-Type": "application/json",
            "Authorization": `Bearer ${yegoboxBearerToken}`
        },
        body: JSON.stringify(smsBody)
    });
    return response.ok;
}

async function processPendingSMS() {
    const { data, error } = await supabase
        .from('messages')
        .select('id, text, phone_number, delivered')
        .eq('delivered', false)
        .limit(10);

    if (error) {
        console.error("Error fetching pending SMS:", error);
        return;
    }

    for (const record of data) {
        const success = await sendSMS(record.text, record.phone_number);
        if (success) {
            await supabase
                .from('messages')
                .update({ delivered: true })
                .eq('id', record.id);
        }
    }
}

Deno.serve(async (req) => {
    await processPendingSMS();
    return new Response(JSON.stringify({ message: "SMS processing complete." }), {
        headers: { "Content-Type": "application/json" },
    });
});
