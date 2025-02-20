function getValueOrEmpty(value: string | null | undefined): string {
  return value || "";
}

function isEmpty(value: string | null | undefined): boolean {
  return getValueOrEmpty(value).length === 0;
}

export { getValueOrEmpty, isEmpty };
