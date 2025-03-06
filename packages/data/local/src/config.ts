import { app, ipcMain } from "electron";
import * as path from "path";
import betterSqlite3 from "better-sqlite3";
import { getEnv } from "@mimik/core/src/env/index";
import * as workspaceDao from "./dao/WorkSpace";

const TAG = "[better-sqlite3]";

const APP_NAME = app.getName();
const DB_EXT = ".sqlite3";

let database: betterSqlite3.Database;
let isDbInitialized = false;

export function initDb() {
  if (isDbInitialized) {
    return;
  }

  console.debug(TAG, "initializing database");
  let dbPath = path.join(app.getPath("userData"));
  const currentEnv = getEnv();
  if (currentEnv.isProd) {
    dbPath = path.join(dbPath, `${APP_NAME}${DB_EXT}`);
  } else {
    dbPath = path.join(`${APP_NAME}-${currentEnv.env}${DB_EXT}`);
    console.debug(TAG, "non prod environment, path: ", dbPath);
  }

  database = new betterSqlite3(dbPath);
  isDbInitialized = true;
  console.debug(TAG, "database initialized successfully");

  workspaceDao.init(database, ipcMain);
  return database;
}

export function getDb(): betterSqlite3.Database {
  return database;
}
