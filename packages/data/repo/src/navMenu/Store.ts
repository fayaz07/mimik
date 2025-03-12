/* eslint-disable no-param-reassign */
import { PayloadAction, createSlice } from "@reduxjs/toolkit";

import NavMenuState from "./State";

const initialState: NavMenuState = {
  showMenu: true,
};

const slice = createSlice({
  name: "navMenu_slice",
  initialState,
  reducers: {
    setShowMenu: (state, action: PayloadAction<boolean>) => {
      state.showMenu = action.payload;
    },
  },
});

export default slice.reducer;
export const { actions } = slice;
