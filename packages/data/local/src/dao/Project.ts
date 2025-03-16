import ProjectEntity, { metadata } from "../entity/Project";
import { Database } from "better-sqlite3";
import DBResult from "@mimik/types/src/api/DBResult";
import Electron from "electron";
import { isTableExisting } from "./Util";

const TAG = "[Projects dao]";

const events = Object.freeze({
  fetchAll: "fetch-projects",

  create: "create-project",

  accessed: "project-accessed",
});

export { events };

function createTable(db: Database) {
  try {
    if (!isTableExisting(metadata.name, db)) {
      console.debug(TAG, "creating Projects table");
      db.exec(ProjectEntity.createTableQuery());
    }
  } catch (e) {
    console.debug(
      "Failed to initialize Projects table, please report this issue",
      e
    );
    process.exit(-1);
  }
}

function setupInsert(db: Database, ipcMain: Electron.IpcMain) {
  ipcMain.handle(
    events.create,
    async (
      _,
      name: string,
      desc: string,
      workspaceId: number
    ): Promise<DBResult<ProjectEntity>> => {
      try {
        const createdOn: string = Date.now().toLocaleString();
        const query = ProjectEntity.insertQuery(name, desc, workspaceId);
        console.debug(TAG, "inserting project: ", query);
        const result = db.prepare(query).run();
        console.debug(TAG, "inserted project: ", result);

        return DBResult.success({
          id: result.lastInsertRowid,
          name,
          desc,
          workspaceId,
          createdOn,
          lastAccessed: createdOn,
          cover: "",
        } as ProjectEntity);
      } catch (e) {
        console.error(TAG, "Failed to insert project", e);
        return DBResult.fail<ProjectEntity>(`Failed to insert project, ${e}`);
      }
    }
  );
}

function setupFetchAll(db: Database, ipcMain: Electron.IpcMain) {
  ipcMain.handle(
    events.fetchAll,
    async (): Promise<DBResult<ProjectEntity[]>> => {
      try {
        const query = ProjectEntity.selectAllQuery();
        console.debug(TAG, "fetching all projects: ", query);
        const rows = db.prepare(query).all();
        console.debug(TAG, "fetched all projects: ", rows);

        return DBResult.success(ProjectEntity.fromRows(rows));
      } catch (e) {
        console.error(TAG, "Failed to fetch all projects", e);
        return DBResult.fail<ProjectEntity[]>(
          `Failed to fetch all projects, ${e}`
        );
      }
    }
  );
}

function setupAccessed(db: Database, ipcMain: Electron.IpcMain) {
  ipcMain.handle(
    events.accessed,
    async (_, id: number): Promise<DBResult<ProjectEntity>> => {
      try {
        const lastAccessed: string = Date.now().toLocaleString();
        const query = ProjectEntity.onAccessedQuery(id);
        console.debug(TAG, "updating project accessed: ", query);
        const result = db.prepare(query).run();
        console.debug(TAG, "updated project accessed: ", result);

        return DBResult.success({
          id,
          lastAccessed,
        } as ProjectEntity);
      } catch (e) {
        console.error(TAG, "Failed to update project accessed", e);
        return DBResult.fail<ProjectEntity>(
          `Failed to update project accessed, ${e}`
        );
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
