/**
 * ! Executing this script will delete all data in your database and seed it with countries.
 * ! Make sure to adjust the script to your needs.
 * Use any TypeScript runner to run this script, for example: `npx tsx seed.ts`
 * Learn more about the Seed Client by following our guide: https://docs.snaplet.dev/seed/getting-started
 */
import { createSeedClient } from "@snaplet/seed";
import { run as seedCountries } from "./countries";

const main = async () => {
  const seed = await createSeedClient();

  // The seed.$resetDatabase() function is commented out to avoid permission issues.
  // await seed.$resetDatabase();

  // Seed the database with countries
  await seedCountries({ db: seed });

  // Type completion not working? You might want to reload your TypeScript Server to pick up the changes

  console.log("Database seeded successfully with countries!");

  process.exit();
};

main();
