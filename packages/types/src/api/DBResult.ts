export default class DBResult<T> {
  constructor(
    public readonly success: boolean,
    public readonly data: T | null,
    public readonly error?: string
  ) {}

  static success<T>(data: T): DBResult<T> {
    return new DBResult(true, data);
  }

  static successNoData<T>(): DBResult<T> {
    return new DBResult(true, null as T);
  }

  static fail<T>(error: string): DBResult<T> {
    return new DBResult(false, null as T, error);
  }
}
