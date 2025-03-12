import { Dispatch } from "@reduxjs/toolkit";

import { actions } from "./Store";

export default class NavMenuRepo {
  private dispatch: Dispatch;

  constructor(dispatcher: Dispatch) {
    this.dispatch = dispatcher;
    this.setShowMenu = this.setShowMenu.bind(this);
  }

  setShowMenu(show: boolean) {
    this.dispatch(actions.setShowMenu(show));
  }
}
