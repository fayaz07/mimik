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

  add: (state: WorkSpaceState, action: PayloadAction<WorkspaceEntity>) => {
    if (!state.list) {
      state.list = [];
    }
    state.list.push(action.payload);
  },

  setShowAddModal: (state: WorkSpaceState, action: PayloadAction<boolean>) => {
    state.showAddModal = action.payload;
  },

  setCreateName: (state: WorkSpaceState, action: PayloadAction<string>) => {
    state.name = action.payload;
  },

  setCreateDesc: (state: WorkSpaceState, action: PayloadAction<string>) => {
    state.desc = action.payload;
  },

  setCreateApiStatus: (
    state: WorkSpaceState,
    action: PayloadAction<ApiCallStatus>
  ) => {
    state.createApi = action.payload;
  },
};
