import WorkSpaceEntity, {
  metadata,
  createTableQuery,
  selectAll,
  insertQuery,
} from "@mimik/local/src/entity/WorkSpace";
import { Database } from "better-sqlite3";
import { isTableExisting } from "./Util";

const TAG = "[Workspaces dao]";

const events = Object.freeze({
  getAll: "get-workspaces",
  fetchedAll: "fetched-workspaces",

  create: "create-workspace",
  created: "created-workspace",

  failed: "failed",
});

export { events };

function createTable(db: Database) {
  try {
    if (!isTableExisting(metadata.tableName, db)) {
      console.debug(TAG, "creating Workspaces table");
      db.exec(createTableQuery());
    }
  } catch (e) {
    console.debug(
      "Failed to initialize Workspace table, please report this issue",
      e
    );
    process.exit(-1);
  }
}

function setupInsert(db: Database, ipcMain: Electron.IpcMain) {
  ipcMain.on(events.create, (event, name: string) => {
    try {
      const createdOn: string = Date.now().toLocaleString();
      const query = insertQuery(name, createdOn);
      console.debug(TAG, "inserting workspace: ", query);
      const result = db.prepare(query).run();
      console.debug(TAG, "inserted workspace: ", result);
      event.reply(events.created, {
        id: result.lastInsertRowid,
        name,
        createdOn,
      } as WorkSpaceEntity);
    } catch (e) {
      console.error(TAG, "Failed to insert workspace", e);
      event.reply(events.failed, `Failed to insert workspace, ${e}`);
    }
  });
}

export function init(db: Database, ipcMain: Electron.IpcMain) {
  console.debug(TAG, "initialing Workspaces dao");

  createTable(db);

  setupInsert(db, ipcMain);
}
