import { Dispatch } from "@reduxjs/toolkit";

export default class BaseRepo {
  protected dispatch: Dispatch;

  constructor(dispatcher: Dispatch) {
    this.dispatch = dispatcher;
  }
}
