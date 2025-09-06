import { createSeedClient } from "@snaplet/seed";
import { seedCountries } from "./scripts/countries";

const main = async () => {
  const seed = await createSeedClient();

  // Seed the database
  await seedCountries({ db: seed });

  console.log("Database seeded successfully!");
  process.exit();
};

main();