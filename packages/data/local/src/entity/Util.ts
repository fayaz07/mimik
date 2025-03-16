export function escapeSingleQuote(str: string): string {
  return str.replace(/'/g, "''");
}
