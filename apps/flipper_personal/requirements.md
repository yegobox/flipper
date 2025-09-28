Flipper Drive customers to your business door.

⚡ Updated Game Flow with Ditto Offline Sync
1. Businesses register a challenge code
    * Each business has a Ditto node running (could be a tablet, kiosk, or even staff’s device).
    * That node advertises a "code" in its local Ditto store.
2. User enters proximity
    * Customer’s app is constantly syncing in the background.
    * When they come near the business, the app automatically receives the challenge code data.
3. Popup Claim Prompt
    * As soon as the code is synced, user’s app shows:🎉 “You’ve discovered a challenge code at [Business Name]! Claim it?”
    * Two buttons: Claim | Later.
4. Claiming
    * Claiming marks the code as “redeemed” for that user in their local Ditto.
    * Ditto syncs back to cloud (or other peers) when online → prevents double-claiming or abuse.
5. Reward Delivery
    * Upon claiming, user could:
        * Get a digital coupon.
        * Unlock points/badges in their profile.
        * Enter a raffle / leaderboard.

🔑 Key Benefits of Using Ditto Here
* Offline-first: Users don’t need internet or scanning QR — just being near the location is enough.
* Peer-to-peer: Businesses don’t need complex infra; their device advertises the code.
* Real-time gamification: Popups feel magical → “this place has something hidden for me.”

🔮 Advanced Mechanics You Could Add
* Geo-gated codes: Business publishes its code only within a certain distance (e.g. 50m radius).
* Timed availability: A code only exists at lunchtime, or during events.
* Mystery codes: Some businesses broadcast a "hidden" code, and customers get a clue (e.g. “Find the café with a red door”).
* Group claiming: Certain codes require more than one device in proximity to unlock → promotes group visits.

📲 UX Flow Example
1. Customer walks into a restaurant.
2. App detects Ditto sync → new "Code #1234" arrives in local DB.
3. App immediately triggers a push-like popup:
    * “🍕 Welcome to Pizza Point! You’ve unlocked a special code.”
    * Button: Claim Reward → adds discount coupon to wallet.
4. Next time app syncs online, it updates central system (for leaderboards, anti-cheat, analytics).

Alright 🚀 let’s sketch out a Ditto data model + sync logic for your Flipper Business Customer Game.

🗂️ Data Model (Ditto Collections)
1. ChallengeCode
Represents a code a business creates & broadcasts.
{
  "id": "uuid",                // Unique code id
  "businessId": "uuid",        // Which business owns this code
  "code": "string",            // The actual challenge code (human readable or hidden)
  "reward": {                  // Optional reward
    "type": "coupon | points | badge",
    "value": "10% off" 
  },
  "validFrom": "timestamp",    // When code becomes valid
  "validTo": "timestamp",      // Expiration
  "location": {                // Optional geo constraint
    "lat": 0.0,
    "lng": 0.0,
    "radiusMeters": 50
  }
}

2. Claim
Represents a user claiming a code.
{
  "id": "uuid",
  "userId": "uuid",           
  "challengeCodeId": "uuid",  // Link to ChallengeCode
  "claimedAt": "timestamp",
  "status": "claimed | redeemed"
}

3. Business
(Optional, but useful for UX & analytics).
{
  "id": "uuid",
  "name": "Pizza Point",
  "address": "123 Main St",
  "logoUrl": "https://..."
}

🔄 Sync Flow with Ditto
1. Business setup
    * Restaurant’s device (tablet/phone with Flipper Business app) inserts a ChallengeCode into Ditto.
    * Example:await ditto.store["ChallengeCode"].upsert({
    *   "id": "1234",
    *   "businessId": "biz-001",
    *   "code": "PIZZA2025",
    *   "reward": {"type": "coupon", "value": "10% off"},
    *   "validFrom": DateTime.now(),
    *   "validTo": DateTime.now().add(Duration(days: 7))
    * });
    * 
2. Customer arrives
    * Their app syncs with nearby Ditto peers (business device).
    * Customer’s local Ditto store now contains ChallengeCode.
3. Popup Trigger
    * App observes new ChallengeCode entries.
    * On detection → show popup:“🎉 You’ve discovered a challenge at Pizza Point. Claim reward?”
4. Claim Action
    * User taps Claim → app inserts into Claim collection.await ditto.store["Claim"].upsert({
    *   "id": uuid.v4(),
    *   "userId": currentUser.id,
    *   "challengeCodeId": challenge.id,
    *   "claimedAt": DateTime.now(),
    *   "status": "claimed"
    * });
    * 
5. Conflict Resolution
    * Ditto automatically syncs claims across peers & cloud.
    * If two users claim the same code:
        * That’s fine (unless business sets maxClaims: 1).
        * If maxClaims: 1, the first claim wins → others see “Sorry, already claimed.”
6. Online Sync
    * Once online, Ditto syncs back to global server → enabling leaderboards, analytics, anti-abuse.

⚡ Bonus Features with Ditto
* Nearby Codes: Preload map of codes when online, but unlock only when device is in proximity.
* Hidden Codes: Business can broadcast codes without showing them in the list → must physically visit to discover.
* Multi-Device Claim Sync: If user has multiple devices (phone + tablet), claims sync offline-first.

