const metadata = Object.freeze({
  tableName: "WorkSpace",
  columns: [
    {
      key: "id",
    },
    {
      key: "name",
    },
    {
      key: "createdOn",
    },
  ],
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
  ${metadata.columns[0].key} INTEGER PRIMARY KEY AUTOINCREMENT,
  ${metadata.columns[1].key} TEXT NOT NULL
);`;
  // ${metadata.columns[2].key} DATETIME NOT NULL
}

export function insertQuery(name: string): string {
  return `INSERT INTO ${metadata.tableName} 
  (${metadata.columns[1].key}) VALUES ('${name}');`;
  //  ${metadata.columns[2].key} DATETIME NOT NULL
}

export function selectAll(): string {
  return `SELECT * FROM ${metadata.tableName};`;
}
