import { Database } from "better-sqlite3";

export function isTableExisting(tableName: string, db: Database): boolean {
  const query = db.prepare(
    "SELECT name FROM sqlite_master WHERE type='table' AND name=?"
  );
  const result = query.get(tableName);
  return result !== undefined;
}
