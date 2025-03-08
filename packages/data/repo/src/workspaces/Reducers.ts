import WorkSpaceEntity from "@mimik/local/src/entity/WorkSpace";
import { PayloadAction } from "@reduxjs/toolkit";
import WorkSpaceState from "./State";

export default {
  setList: (
    state: WorkSpaceState,
    action: PayloadAction<WorkSpaceEntity[]>
  ) => {
    state.list = action.payload;
  },
};
