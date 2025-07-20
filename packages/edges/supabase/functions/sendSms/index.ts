// @ts-nocheck

import { createClient } from '@supabase/supabase-js';
// supabase functions deploy sendSms
const supabaseUrl = Deno.env.get('SUPABASE_URL')!;
const supabaseKey = Deno.env.get('SUPABASE_ANON_KEY')!;
const yegoboxBearerToken = Deno.env.get('YEGOBOX_BEARER_TOKEN')!;

const supabase = createClient(supabaseUrl, supabaseKey, {
    global: {
        fetch: (...args) => fetch(...args),
    },
});

const SMS_API_URL = "https://apihub.yegobox.com/v2/api/sms-broadcast";
const SMS_CREDIT_COST = 10; // Define the cost of sending one SMS

async function sendSMS(text, phoneNumber) {
    try {
        // Ensure phone number has the + prefix for international format
        const formattedNumber = phoneNumber.startsWith('+') ? phoneNumber : `+${phoneNumber}`;
        console.log(`Attempting to send SMS to ${formattedNumber}: "${text}"`);

        const smsBody = {
            text: text,
            numberList: [formattedNumber]
        };

        const response = await fetch(SMS_API_URL, {
            method: "POST",
            headers: {
                "Content-Type": "application/json",
                "Authorization": `Basic ${btoa(`${Deno.env.get('SMS_API_USERNAME')}:${Deno.env.get('SMS_API_PASSWORD')}`)}`
            },
            body: JSON.stringify(smsBody)
        });

        // Read the full response and log it
        const responseData = await response.json().catch(e => {
            console.error("Failed to parse response JSON:", e);
            return null;
        });

        console.log("SMS API Response:", {
            status: response.status,
            ok: response.ok,
            data: responseData
        });

        // Check if the API response indicates success
        if (response.ok) {
            return { success: true };
        } else {
            return {
                success: false,
                error: `API returned status ${response.status}`,
                details: responseData
            };
        }
    } catch (error) {
        console.error("Error sending SMS:", error);
        return { success: false, error: error.message };
    }
}

async function deductCredits(branch_server_id: number, creditsToDeduct: number) { // Changed to number
    try {
        // Call the PostgreSQL function using supabase.rpc
        const { error: updateError } = await supabase.rpc('deduct_credits', {
            branch_id: branch_server_id,
            amount: creditsToDeduct
        });

        if (updateError) {
            console.error(`Failed to deduct credits for branch ${branch_server_id}:`, updateError);
            return { success: false, error: `Failed to deduct credits: ${updateError.message}` };
        }

        console.log(`Successfully deducted ${creditsToDeduct} credits for branch ${branch_server_id}.`);
        return { success: true }; // No need to return balance since the function does the update
    } catch (error) {
        console.error("Error during credit deduction:", error);
        return { success: false, error: error.message };
    }
}

async function processPendingSMS() {
    console.log("Starting to process pending SMS messages...");

    try {
        // Fetch pending messages, including branch_id
        const { data, error } = await supabase
            .from('messages')
            .select('id, text, phone_number, delivered, branch_id')
            .eq('delivered', false)
            .limit(10);

        if (error) {
            console.error("Error fetching pending SMS:", error);
            return {
                processed: 0,
                success: 0,
                failed: 0,
                error: `Database fetch error: ${error.message}`
            };
        }

        console.log(`Found ${data.length} pending SMS messages to process`);

        let successCount = 0;
        let failedCount = 0;
        let errors = [];

        // Process each message
        for (const record of data) {
            console.log(`Processing message ID: ${record.id}`);

            // Check if phone number is valid
            if (!record.phone_number || !record.phone_number.trim()) {
                console.error(`Invalid phone number for message ID: ${record.id}`);
                errors.push(`Message ${record.id}: Invalid phone number`);
                failedCount++;
                continue;
            }

            // Check if text is valid
            if (!record.text || !record.text.trim()) {
                console.error(`Empty message text for message ID: ${record.id}`);
                errors.push(`Message ${record.id}: Empty message text`);
                failedCount++;
                continue;
            }

            // CHECK CREDITS
            if (!record.branch_id) {
                console.error(`Missing branch_id for message ID: ${record.id}`);
                errors.push(`Message ${record.id}: Missing branch_id`);
                failedCount++;
                continue;
            }

            // Make sure the branch_id is a number
            const branchId = Number(record.branch_id);
            if (isNaN(branchId)) {
                console.error(`Invalid branch_id (not a number) for message ID: ${record.id}`);
                errors.push(`Message ${record.id}: Invalid branch_id (not a number)`);
                failedCount++;
                continue;
            }

            const creditCheckResult = await deductCredits(branchId, SMS_CREDIT_COST); // Call deductCredits for each message
            if (!creditCheckResult.success) {
                console.warn(`Skipping message ${record.id} due to credit issues: ${creditCheckResult.error}`);
                errors.push(`Message ${record.id}: ${creditCheckResult.error}`);
                failedCount++;
                continue;
            }


            const result = await sendSMS(record.text, record.phone_number);

            if (result.success) {
                // Update message status in database
                const { error: updateError } = await supabase
                    .from('messages')
                    .update({ delivered: true })
                    .eq('id', record.id);

                if (updateError) {
                    console.error(`Failed to update message ${record.id} status:`, updateError);
                    errors.push(`Message ${record.id}: Database update failed - ${updateError.message}`);
                    failedCount++;
                } else {
                    console.log(`Successfully delivered and updated message ID: ${record.id}`);
                    successCount++;
                }
            } else {
                console.error(`Failed to send SMS for message ID: ${record.id}`, result.error);
                errors.push(`Message ${record.id}: ${result.error || 'Unknown API error'}`);
                if (result.details) {
                    errors.push(`API details: ${JSON.stringify(result.details)}`);
                }
                failedCount++;
            }
        }

        return {
            processed: data.length,
            success: successCount,
            failed: failedCount,
            errors: errors,
            pendingMessages: data.map(m => ({
                id: m.id,
                phone: m.phone_number,
                textLength: m.text ? m.text.length : 0,
                branch_id: m.branch_id
            }))
        };
    } catch (error) {
        console.error("Error in processPendingSMS:", error);
        return { processed: 0, success: 0, failed: error.toString() };
    }
}

// Utility function to check environment variables
function checkEnvironmentVariables() {
    const vars = {
        'SUPABASE_URL': Deno.env.get('SUPABASE_URL'),
        'SUPABASE_ANON_KEY': Deno.env.get('SUPABASE_ANON_KEY'),
        'YEGOBOX_BEARER_TOKEN': Deno.env.get('YEGOBOX_BEARER_TOKEN')
    };

    const missingVars = Object.entries(vars)
        .filter(([_, value]) => !value)
        .map(([name]) => name);

    return {
        allPresent: missingVars.length === 0,
        missing: missingVars,
        values: {
            supabaseUrl: vars['SUPABASE_URL'] ? `${vars['SUPABASE_URL'].substring(0, 10)}...` : 'missing',
            tokenLength: vars['YEGOBOX_BEARER_TOKEN'] ? vars['YEGOBOX_BEARER_TOKEN'].length : 0
        }
    };
}

// Main handler
Deno.serve(async (req) => {
    try {
        console.log("SMS processing endpoint called");

        // Check environment variables
        const envCheck = checkEnvironmentVariables();
        if (!envCheck.allPresent) {
            return new Response(JSON.stringify({
                message: "Environment configuration error",
                missing: envCheck.missing
            }), {
                headers: { "Content-Type": "application/json" },
                status: 500
            });
        }

        const result = await processPendingSMS();

        return new Response(JSON.stringify({
            message: "SMS processing complete",
            stats: result,
            config: {
                env: envCheck.values,
                apiUrl: SMS_API_URL,
                creditCost: SMS_CREDIT_COST
            }
        }), {
            headers: { "Content-Type": "application/json" },
            status: 200
        });
    } catch (error) {
        console.error("Unhandled error in request handler:", error);

        return new Response(JSON.stringify({
            message: "Error processing SMS messages",
            error: error.toString(),
            stack: error.stack
        }), {
            headers: { "Content-Type": "application/json" },
            status: 500
        });
    }
});