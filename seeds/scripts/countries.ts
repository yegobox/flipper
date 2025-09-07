import { countries } from '../data/countries';
import postgres from 'postgres';

export const seedCountries = async ({ db }) => {
  // Clear existing countries first using direct postgres client
  const sql = postgres(process.env.DATABASE_URL || "postgresql://postgres:postgres@127.0.0.1:54322/postgres");
  try {
    await sql`TRUNCATE TABLE countries RESTART IDENTITY CASCADE`;
  } finally {
    await sql.end();
  }
  
  await db.countries(countries.map((country, index) => ({
    name: country.name,
    code: country["alpha-2"],
    description: country.name,
    sort_order: index + 1,
  })));
};