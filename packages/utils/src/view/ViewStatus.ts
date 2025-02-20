/* eslint-disable no-unused-vars */
import Constants from "../constants/Constants";

enum ViewState {
  LOADING,
  ERROR,
  IDLE,
}

interface ViewStatus {
  state: ViewState;
  message: string;
}

const kLoading = {
  state: ViewState.LOADING,
  message: Constants.loading,
} as ViewStatus;

const kIdle = {
  state: ViewState.IDLE,
  message: "",
};

const kError = {
  state: ViewState.ERROR,
  message: Constants.error,
};

class View {
  static error(): ViewStatus {
    return kError;
  }

  static errorWithMsg(msg: string): ViewStatus {
    return { state: ViewState.ERROR, message: msg } as ViewStatus;
  }

  static loading(): ViewStatus {
    return kLoading;
  }

  static loadingWithMsg(msg: string): ViewStatus {
    return { state: ViewState.LOADING, message: msg } as ViewStatus;
  }

  static idle(): ViewStatus {
    return kIdle;
  }
}

export { View, ViewState };
export type { ViewStatus };
