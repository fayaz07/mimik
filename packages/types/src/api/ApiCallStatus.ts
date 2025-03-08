enum ApiCallState {
  idle = "idle",
  loading = "loading",
  error = "error",
}

export default interface ApiCallStatus {
  msg: string;
  state: ApiCallState;
}

const defState: ApiCallStatus = {
  msg: "",
  state: ApiCallState.idle,
};

export { ApiCallState, defState };

export function isLoading(status: ApiCallStatus): boolean {
  return status.state === ApiCallState.loading;
}

export function isError(status: ApiCallStatus): boolean {
  return status.state === ApiCallState.error;
}

export function isIdle(status: ApiCallStatus): boolean {
  return status.state === ApiCallState.idle;
}
