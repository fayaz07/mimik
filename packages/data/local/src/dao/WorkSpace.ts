import WorkSpace, {
  metadata,
  createTableQuery,
  selectAll,
  insertQuery,
} from "@mimik/local/src/entity/WorkSpace";
import { Database } from "better-sqlite3";
import { isTableExisting } from "./Util";

const events = Object.freeze({
  getAll: "get-workspaces",
  fetchedAll: "fetched-workspaces",
  create: "create-workspace",
  created: "created-workspace",
});

export { events };

export function init(db: Database, ipcMain: Electron.IpcMain) {
  console.debug("initialing Workspaces dao");

  // console.debug(db.prepare(createTableQuery()).run());
  if (isTableExisting(metadata.tableName)) {
  }

  ipcMain.on(events.getAll, (event) => {
    const res = db.prepare(selectAll()).all();
    console.log(res);
    event.reply(events.fetchedAll, res);
  });

  ipcMain.on(events.create, (event, name) => {
    const res = db.prepare(insertQuery(name));
    console.log(res);
    event.reply(events.created, res);
  });
}
