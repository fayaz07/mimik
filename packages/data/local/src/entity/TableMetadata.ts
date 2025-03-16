import { escapeSingleQuote } from "./Util";

export default interface TableMetadata {
  name: string;
  columns: {
    [key: string]: {
      key: string;
      type: string;
      constraints: string[];
    };
  };
}

export function createAnyTable(metadata: TableMetadata): string {
  const columns = Object.values(metadata.columns);

  const columnDefs = columns
    .map(
      ({ key, type, constraints }) => `${key} ${type} ${constraints.join(" ")}`
    )
    .join(",\n  ");

  return `CREATE TABLE IF NOT EXISTS ${metadata.name} (
    ${columnDefs}
  );`;
}

export function insertToAnyTable(
  metadata: TableMetadata,
  values: { [key: string]: any }
) {
  const columns = Object.values(metadata.columns);

  const columnNames: string[] = [];
  const columnValues: string[] = [];

  for (const column of columns) {
    const { key } = column;
    const value = values[key];

    if (value === undefined) {
      continue;
    }

    columnNames.push(key);

    if (typeof value === "string") {
      columnValues.push(`'${escapeSingleQuote(value)}'`);
    } else {
      columnValues.push(value);
    }
  }

  return `INSERT INTO ${metadata.name} (${columnNames}) VALUES (${columnValues});`;
}

export function selectAllFromAnyTable(metadata: TableMetadata): string {
  return `SELECT * FROM ${metadata.name};`;
}

export function selectFromAnyTable(
  metadata: TableMetadata,
  where: { [key: string]: any }
): string {
  const conditions = Object.entries(where)
    .map(([key, value]) => {
      return typeof value === "string"
        ? `${key} = '${escapeSingleQuote(value)}'`
        : `${key} = ${value}`;
    })
    .join(" AND ");

  return `SELECT * FROM ${metadata.name} WHERE ${conditions};`;
}

export function deleteFromAnyTable(
  metadata: TableMetadata,
  where: { [key: string]: any }
): string {
  const conditions = Object.entries(where)
    .map(([key, value]) => {
      return typeof value === "string"
        ? `${key} = '${escapeSingleQuote(value)}'`
        : `${key} = ${value}`;
    })
    .join(" AND ");

  return `DELETE FROM ${metadata.name} WHERE ${conditions};`;
}

export function updateAnyTable(
  metadata: TableMetadata,
  where: { [key: string]: any },
  values: { [key: string]: any }
): string {
  const conditions = Object.entries(where)
    .map(([key, value]) => {
      return typeof value === "string"
        ? `${key} = '${escapeSingleQuote(value)}'`
        : `${key} = ${value}`;
    })
    .join(" AND ");

  const updates = Object.entries(values)
    .map(([key, value]) => {
      return `${key} = ${typeof value === "string" ? `'${value}'` : value}`;
    })
    .join(", ");

  return `UPDATE ${metadata.name} SET ${updates} WHERE ${conditions};`;
}

export function deleteAllFromAnyTable(metadata: TableMetadata): string {
  return `DELETE FROM ${metadata.name};`;
}
