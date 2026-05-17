// @ts-nocheck

import { createClient } from '@supabase/supabase-js';

const supabaseUrl = Deno.env.get('SUPABASE_URL')!;
const supabaseServiceKey =
  Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? Deno.env.get('SUPABASE_ANON_KEY')!;
const supabase = createClient(supabaseUrl, supabaseServiceKey, {
    auth: { autoRefreshToken: false, persistSession: false },
    global: {
        fetch: (...args) => fetch(...args),
    },
});

const SMS_API_URL = "https://apihub.yegobox.com/v2/api/sms-broadcast";
const SMS_CREDIT_COST = 30; // Define the cost of sending one SMS

const BRANCH_UUID_RE =
  /^[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/i;

/** Resolve Ditto branch UUID for deduct_credits(branch_id uuid, …). */
async function resolveBranchUuid(
  branchIdRaw: string | number | null | undefined,
): Promise<string | null> {
  if (branchIdRaw == null || branchIdRaw === "") return null;
  const asString = String(branchIdRaw);
  if (BRANCH_UUID_RE.test(asString)) return asString;

  const asNum = Number(asString);
  if (Number.isFinite(asNum) && !asString.includes("-")) {
    const { data, error } = await supabase
      .from("branches")
      .select("id")
      .eq("server_id", asNum)
      .maybeSingle();
    if (error) {
      console.error("resolveBranchUuid:", error.message);
      return null;
    }
    return data?.id ?? null;
  }

  return null;
}

function smsApiAuthHeader(): string | null {
    const username = Deno.env.get("SMS_API_USERNAME");
    const password = Deno.env.get("SMS_API_PASSWORD");
    if (username && password) {
        return `Basic ${btoa(`${username}:${password}`)}`;
    }
    const bearer = Deno.env.get("YEGOBOX_BEARER_TOKEN");
    if (bearer) {
        return `Bearer ${bearer}`;
    }
    return null;
}

async function sendSMS(text, phoneNumber) {
    try {
        const authHeader = smsApiAuthHeader();
        if (!authHeader) {
            return {
                success: false,
                error: "SMS API credentials not configured (SMS_API_USERNAME/PASSWORD or YEGOBOX_BEARER_TOKEN)",
            };
        }

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
                "Authorization": authHeader
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

async function deductCredits(branchUuid: string, creditsToDeduct: number) {
    try {
        // Always pass UUID so PostgREST picks deduct_credits(uuid, int) not (integer, int).
        const { error: updateError } = await supabase.rpc('deduct_credits', {
            branch_id: branchUuid,
            amount: creditsToDeduct
        });

        if (updateError) {
            console.error(`Failed to deduct credits for branch ${branchUuid}:`, updateError);
            return { success: false, error: `Failed to deduct credits: ${updateError.message}` };
        }

        console.log(`Successfully deducted ${creditsToDeduct} credits for branch ${branchUuid}.`);
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

            const branchUuid = await resolveBranchUuid(record.branch_id);
            if (branchUuid == null) {
                console.error(`Could not resolve branch UUID for ${record.branch_id}`);
                errors.push(`Message ${record.id}: Invalid branch_id`);
                failedCount++;
                continue;
            }

            const creditCheckResult = await deductCredits(branchUuid, SMS_CREDIT_COST);
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
    const supabaseUrl = Deno.env.get("SUPABASE_URL");
    const hasBasicAuth =
        !!Deno.env.get("SMS_API_USERNAME") && !!Deno.env.get("SMS_API_PASSWORD");
    const hasBearer = !!Deno.env.get("YEGOBOX_BEARER_TOKEN");
    const hasSmsAuth = hasBasicAuth || hasBearer;

    const missing: string[] = [];
    if (!supabaseUrl) missing.push("SUPABASE_URL");
    if (!hasSmsAuth) {
        missing.push("SMS_API_USERNAME+SMS_API_PASSWORD (or YEGOBOX_BEARER_TOKEN)");
    }

    return {
        allPresent: missing.length === 0,
        missing,
        values: {
            supabaseUrl: supabaseUrl ? `${supabaseUrl.substring(0, 10)}...` : "missing",
            smsAuth: hasBasicAuth ? "basic" : hasBearer ? "bearer" : "missing",
        },
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