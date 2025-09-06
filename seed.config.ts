import { defineConfig } from "@snaplet/seed/config";
import { SeedPostgres } from "@snaplet/seed/adapter-postgres";
import postgres from "postgres";

export default defineConfig({
  adapter: () => {
    const client = postgres("postgresql://postgres:postgres@127.0.0.1:54322/postgres");
    return new SeedPostgres(client);
  },
});
