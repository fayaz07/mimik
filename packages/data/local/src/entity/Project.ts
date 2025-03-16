import TableMetadata, {
  createAnyTable,
  updateAnyTable,
  deleteFromAnyTable,
  selectFromAnyTable,
  insertToAnyTable,
  selectAllFromAnyTable,
} from "./TableMetadata";
import { metadata as WorkspaceMD } from "./Workspace";

const metadata = {
  name: "projects",
  columns: {
    id: {
      key: "id",
      type: "INTEGER",
      constraints: ["PRIMARY KEY", "AUTOINCREMENT"],
    },
    workspaceId: {
      key: "workspaceId",
      type: "INTEGER",
      constraints: [
        "NOT NULL",
        `REFERENCES ${WorkspaceMD.name}(${WorkspaceMD.columns.id.key})`,
      ],
    },
    name: {
      key: "name",
      type: "TEXT",
      constraints: ["NOT NULL"],
    },
    desc: {
      key: "desc",
      type: "TEXT",
      constraints: ["NOT NULL"],
    },
    cover: {
      key: "cover",
      type: "TEXT",
      constraints: [],
    },
    createdOn: {
      key: "createdOn",
      type: "DATETIME",
      constraints: ["NOT NULL"],
    },
    lastAccessed: {
      key: "lastAccessed",
      type: "DATETIME",
      constraints: ["NOT NULL"],
    },
  },
} as TableMetadata;

export { metadata };

export default class ProjectEntity {
  id: number;
  workspaceId: number;
  name: string;
  desc: string;
  cover: string;
  createdOn: string;
  lastAccessed: string;

  constructor(
    id: number,
    workspaceId: number,
    name: string,
    desc: string,
    cover: string,
    createdOn: string,
    lastAccessed: string
  ) {
    this.id = id;
    this.workspaceId = workspaceId;
    this.name = name;
    this.desc = desc;
    this.cover = cover;
    this.createdOn = createdOn;
    this.lastAccessed = lastAccessed;
  }

  static fromRow(row: any): ProjectEntity {
    return new ProjectEntity(
      row.id,
      row.workspaceId,
      row.name,
      row.desc,
      row.cover,
      row.createdOn,
      row.lastAccessed
    );
  }

  static fromRows(rows: any[]): ProjectEntity[] {
    return rows.map((row) => ProjectEntity.fromRow(row));
  }

  static toRow(project: ProjectEntity): any {
    return {
      id: project.id,
      workspaceId: project.workspaceId,
      name: project.name,
      desc: project.desc,
      cover: project.cover,
      createdOn: project.createdOn,
      lastAccessed: project.lastAccessed,
    };
  }

  static toRows(projects: ProjectEntity[]): any[] {
    return projects.map((project) => ProjectEntity.toRow(project));
  }

  static createTableQuery(): string {
    return createAnyTable(metadata);
  }

  static insertQuery(name: string, desc: string, workspaceId: number): string {
    return insertToAnyTable(metadata, {
      name,
      desc,
      workspaceId,
      createdOn: "datetime('now')",
      lastAccessed: "datetime('now')",
    });
  }

  static selectAllQuery(): string {
    return selectAllFromAnyTable(metadata);
  }

  static selectQuery(where: { [key: string]: any }): string {
    return selectFromAnyTable(metadata, where);
  }

  static updateQuery(
    where: { [key: string]: any },
    values: { [key: string]: any }
  ): string {
    return updateAnyTable(metadata, where, values);
  }

  static onAccessedQuery(id: number): string {
    return updateAnyTable(
      metadata,
      { id },
      { lastAccessed: "datetime('now')" }
    );
  }
}
