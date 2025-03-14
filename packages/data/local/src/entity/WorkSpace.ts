const metadata = Object.freeze({
  tableName: "Workspace",
  columns: {
    id: {
      key: "id",
    },
    name: {
      key: "name",
    },
    desc: {
      key: "desc",
    },
    cover: {
      key: "cover",
    },
    createdOn: {
      key: "createdOn",
    },
    lastAccessed: {
      key: "lastAccessed",
    },
  },
});

export { metadata };

export default class WorkspaceEntity {
  id: number;
  name: string;
  desc: string;
  cover: string;
  createdOn: string;

  constructor(
    id: number,
    name: string,
    desc: string,
    cover: string,
    createdOn: string
  ) {
    this.id = id;
    this.name = name;
    this.desc = desc;
    this.cover = cover;
    this.createdOn = createdOn;
  }
}

// create table query
export function createTableQuery(): string {
  return `CREATE TABLE ${metadata.tableName} (
  ${metadata.columns.id.key} INTEGER PRIMARY KEY AUTOINCREMENT,
  ${metadata.columns.name.key} TEXT NOT NULL,
  ${metadata.columns.desc.key} TEXT NOT NULL,
  ${metadata.columns.cover.key} TEXT,
  ${metadata.columns.createdOn.key} DATETIME NOT NULL,
  ${metadata.columns.lastAccessed.key} DATETIME NOT NULL
);`;
}

export function insertQuery(name: string, desc: string): string {
  return `INSERT INTO ${metadata.tableName} 
  (
    ${metadata.columns.name.key}, 
    ${metadata.columns.desc.key}, 
    ${metadata.columns.createdOn.key},
    ${metadata.columns.lastAccessed.key}
  ) 
  VALUES 
  (\'${name}\', \'${desc}\', datetime('now'), datetime('now'));`.trim();
}

export function selectAll(): string {
  return `SELECT * FROM ${metadata.tableName} ORDER BY ${metadata.columns.lastAccessed.key} DESC;`;
}

export function onWorkSpaceAccessed(id: number): string {
  return `UPDATE ${metadata.tableName} 
  SET ${metadata.columns.lastAccessed.key} = datetime('now') 
  WHERE ${metadata.columns.id.key} = ${id};`.trim();
}
