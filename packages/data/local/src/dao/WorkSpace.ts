import WorkspaceEntity, {
  metadata,
  createTableQuery,
  selectAll,
  insertQuery,
  onWorkSpaceAccessed,
} from "@mimik/local/src/entity/Workspace";
import { Database } from "better-sqlite3";
import DBResult from "@mimik/types/src/api/DBResult";
import { isTableExisting } from "./Util";

const TAG = "[Workspaces dao]";

const events = Object.freeze({
  fetchAll: "fetch-workspaces",

  create: "create-workspace",

  accessed: "workspace-accessed",
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
  ipcMain.handle(
    events.create,
    async (_, name: string): Promise<DBResult<WorkspaceEntity>> => {
      try {
        const createdOn: string = Date.now().toLocaleString();
        const query = insertQuery(name);
        console.debug(TAG, "inserting workspace: ", query);
        const result = db.prepare(query).run();
        console.debug(TAG, "inserted workspace: ", result);

        return DBResult.success({
          id: result.lastInsertRowid,
          name,
          createdOn,
          lastAccessed: createdOn,
        } as WorkspaceEntity);
      } catch (e) {
        console.error(TAG, "Failed to insert workspace", e);
        // throw e;
        return DBResult.fail<WorkspaceEntity>(
          `Failed to insert workspace, ${e}`
        );
      }
    }
  );
}

function setupFetchAll(db: Database, ipcMain: Electron.IpcMain) {
  ipcMain.handle(
    events.fetchAll,
    async (): Promise<DBResult<WorkspaceEntity[]>> => {
      try {
        const result = db.prepare(selectAll()).all();
        console.debug(TAG, result);
        return DBResult.success(result as WorkspaceEntity[]);
      } catch (e) {
        console.debug(TAG, "Failed to fetch workspaces", e);
        return DBResult.fail<WorkspaceEntity[]>(
          `Failed to fetch workspaces, ${e}`
        );
      }
    }
  );
}

function setupAccessed(db: Database, ipcMain: Electron.IpcMain) {
  ipcMain.handle(
    events.accessed,
    async (_, id: number): Promise<DBResult<void>> => {
      try {
        const query = onWorkSpaceAccessed(id);
        console.debug(TAG, "accessed workspace: ", query);
        db.prepare(query).run();
        console.debug(TAG, "accessed workspace: ", id);
        return DBResult.successNoData();
      } catch (e) {
        console.error(TAG, "Failed to access workspace", e);
        return DBResult.fail<void>(`Failed to access workspace, ${e}`);
      }
    }
  );
}

export function init(db: Database, ipcMain: Electron.IpcMain) {
  console.debug(TAG, "initialing Workspaces dao");

  createTable(db);

  setupInsert(db, ipcMain);

  setupFetchAll(db, ipcMain);

  setupAccessed(db, ipcMain);
}
