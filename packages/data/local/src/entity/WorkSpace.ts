const metadata = Object.freeze({
  tableName: "WorkSpace",
  columns: {
    id: {
      key: "id",
    },
    name: {
      key: "name",
    },
    createdOn: {
      key: "createdOn",
    },
  },
});

export { metadata };

export default class WorkSpace {
  id: number;
  name: string;
  createdOn: string;

  constructor(id: number, name: string, createdOn: string) {
    this.id = id;
    this.name = name;
    this.createdOn = createdOn;
  }
}

// create table query
export function createTableQuery(): string {
  return `CREATE TABLE ${metadata.tableName} (
  ${metadata.columns.id.key} INTEGER PRIMARY KEY AUTOINCREMENT,
  ${metadata.columns.name.key} TEXT NOT NULL,
  ${metadata.columns.createdOn.key} DATETIME NOT NULL
);`;
}

export function insertQuery(name: string, createdOn: string): string {
  return `INSERT INTO ${metadata.tableName} 
  (${metadata.columns.name.key}, ${metadata.columns.createdOn.key}) VALUES ('${name}', '${createdOn}');`;
}

export function selectAll(): string {
  return `SELECT * FROM ${metadata.tableName};`;
}
