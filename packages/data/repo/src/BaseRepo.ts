import { Dispatch, PayloadAction } from "@reduxjs/toolkit";
import ApiCallStatus, {
  ApiCallState,
} from "@mimik/types/src/api/ApiCallStatus";

export default class BaseRepo {
  protected dispatch: Dispatch;

  constructor(dispatcher: Dispatch) {
    this.dispatch = dispatcher;
  }

  protected loading(msg: string = ""): ApiCallStatus {
    return {
      state: ApiCallState.loading,
      msg,
      lastReq: Date.now(),
    } as ApiCallStatus;
  }

  protected idle(msg: string = ""): ApiCallStatus {
    return {
      state: ApiCallState.idle,
      msg,
    } as ApiCallStatus;
  }

  protected error(msg: string = ""): ApiCallStatus {
    return {
      state: ApiCallState.error,
      msg,
    } as ApiCallStatus;
  }
}
