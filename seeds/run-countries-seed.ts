import { createSeedClient } from "@snaplet/seed";
import { seedCountries } from "./scripts/countries";

async function run() {
  const seed = await createSeedClient();
  await seedCountries({ db: seed });
  console.log("Countries seeded!");
}

run();
