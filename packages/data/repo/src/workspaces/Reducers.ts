import WorkspaceEntity from "@mimik/local/src/entity/Workspace";
import { PayloadAction } from "@reduxjs/toolkit";
import WorkSpaceState from "./State";
import ApiCallStatus from "@mimik/types/src/api/ApiCallStatus";

export default {
  setFetchApiStatus: (
    state: WorkSpaceState,
    action: PayloadAction<ApiCallStatus>
  ) => {
    state.fetchApi = action.payload;
  },

  setList: (
    state: WorkSpaceState,
    action: PayloadAction<WorkspaceEntity[]>
  ) => {
    state.list = action.payload;
  },
};
