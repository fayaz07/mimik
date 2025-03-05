import Database from "better-sqlite3";
import path from "path";

const dbPath =
  process.env.NODE_ENV === "development"
    ? "./demo_table.db"
    : path.join("./demo_table.db");

const db = new Database(dbPath);
db.pragma("journal_mode = WAL");

export { db };
