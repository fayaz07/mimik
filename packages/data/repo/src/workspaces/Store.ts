import { PayloadAction, createSlice } from "@reduxjs/toolkit";
import ApiCallStatus, { defState } from "@mimik/types/src/api/ApiCallStatus";
import Reducers from "./Reducers";
import WorkSpaceState from "./State";

const initialState: WorkSpaceState = {
  fetchApi: defState,
  updateApi: defState,
  deleteApi: defState,

  list: [],

  // add
  createApi: defState,
  showAddModal: false,
  name: "",
  desc: "",
};

const slice = createSlice({
  name: "workspaces",
  initialState,
  reducers: { ...Reducers },
});

export default slice.reducer;
export const { actions } = slice;
