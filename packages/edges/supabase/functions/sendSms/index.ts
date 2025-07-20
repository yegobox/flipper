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
        const username = Deno.env.get('SMS_API_USERNAME');
        const password = Deno.env.get('SMS_API_PASSWORD');

        if (!username || !password) {
            return { success: false, error: 'SMS API credentials not configured' };
        }

        const smsBody = {
            text: text,
            numberList: [formattedNumber]
        };

        const response = await fetch(SMS_API_URL, {
            method: "POST",
            headers: {
                "Content-Type": "application/json",
                "Authorization": `Basic ${btoa(`${username}:${password}`)}`
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

async function getBranchUuid(branchServerId: number): Promise<string | null> {
    try {
        const { data, error } = await supabase
            .from('branches')
            .select('id')
            .eq('server_id', branchServerId)
            .single();

        if (error) {
            console.error(`Error fetching branch UUID for server_id ${branchServerId}:`, error);
            return null;
        }

        if (data) {
            return data.id;
        }
        return null;
    } catch (error) {
        console.error(`Exception fetching branch UUID for server_id ${branchServerId}:`, error);
        return null;
    }
}

async function deductCredits(branch_id: number, creditsToDeduct: number) {
    try {
        const { error: updateError } = await supabase.rpc('deduct_credits', {
            branch_id: branch_id,
            amount: creditsToDeduct
        });

        if (updateError) {
            console.error(`Failed to deduct credits for branch ${branch_id}:`, updateError);
            return { success: false, error: `Failed to deduct credits: ${updateError.message}` };
        }

        console.log(`Successfully deducted ${creditsToDeduct} credits for branch ${branch_id}.`);
        return { success: true };
    } catch (error) {
        console.error("Error during credit deduction:", error);
        return { success: false, error: error.message };
    }
}

async function refundCredits(branch_uuid: string, creditsToRefund: number) {
    try {
        const { error: updateError } = await supabase.rpc('add_credits', {
            branch_id_param: branch_uuid,
            amount_param: creditsToRefund
        });

        if (updateError) {
            console.error(`Failed to refund credits for branch ${branch_uuid}:`, updateError);
            return { success: false, error: `Failed to refund credits: ${updateError.message}` };
        }

        console.log(`Successfully refunded ${creditsToRefund} credits for branch ${branch_uuid}.`);
        return { success: true };
    } catch (error) {
        console.error("Error during credit refund:", error);
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
            let branchUuid: string | null = null; // Declare branchUuid here
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

            const branchServerId = record.branch_id; // This is the INT branch_id from messages table

            const creditDeductionResult = await deductCredits(branchServerId, SMS_CREDIT_COST);
            if (!creditDeductionResult.success) {
                console.warn(`Skipping message ${record.id} due to credit issues: ${creditDeductionResult.error}`);
                errors.push(`Message ${record.id}: ${creditDeductionResult.error}`);
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
                    // If update fails, refund credits as SMS was sent but not marked delivered
                    // Get branch UUID
                    const branchUuid = await getBranchUuid(branchServerId);
                    await refundCredits(branchUuid, SMS_CREDIT_COST);
                } else {
                    console.log(`Successfully delivered and updated message ID: ${record.id}`);
                    successCount++;
                }
            } else {
                console.error(`Failed to send SMS for message ID: ${record.id}`, result.error, record.phone_number);
                errors.push(`Message ${record.id}: ${result.error || 'Unknown API error'}`);
                if (result.details) {
                    errors.push(`API details: ${JSON.stringify(result.details)}`);
                }
                failedCount++;
                // Refund credits if SMS sending failed
                branchUuid = await getBranchUuid(branchServerId);
                if (branchUuid) {
                    await refundCredits(branchUuid, SMS_CREDIT_COST);
                }
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
        'YEGOBOX_BEARER_TOKEN': Deno.env.get('YEGOBOX_BEARER_TOKEN'),
        'SMS_API_USERNAME': Deno.env.get('SMS_API_USERNAME'),
        'SMS_API_PASSWORD': Deno.env.get('SMS_API_PASSWORD')
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