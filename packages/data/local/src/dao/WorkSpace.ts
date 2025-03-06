import WorkSpace, {
  createTableQuery,
  selectAll,
  insertQuery,
} from "@mimik/local/src/entity/WorkSpace";
import betterSqlite3 from "better-sqlite3";

// let dao: WorkSpaceDao;
// let initiated: boolean = false;

// export class WorkSpaceDao {
//   db: betterSqlite3.Database;

//   constructor(_db: betterSqlite3.Database) {
//     this.db = _db;

//     this.init();
//   }

//   private init() {
//     console.log(this.db.prepare(createQuery()).run());
//   }

//   getAll(): WorkSpace[] {
//     const result = this.db.prepare(select());
//     return result.all() as WorkSpace[];
//   }
// }

const events = Object.freeze({
  getAll: "get-workspaces",
  fetchedAll: "fetched-workspaces",
  create: "create-workspace",
  created: "created-workspace",
});

export { events };

export function init(db: betterSqlite3.Database, ipcMain: Electron.IpcMain) {
  // dao = new WorkSpaceDao(db);
  // initiated = true;
  // return dao;

  console.debug("initialing Workspaces dao");

  // console.debug(db.prepare(createTableQuery()).run());

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
