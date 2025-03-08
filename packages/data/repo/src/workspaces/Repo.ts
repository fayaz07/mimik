import { Dispatch } from "@reduxjs/toolkit";
import WorkSpaceState from "./State";
import store from "../store/AppRootStore";
import BaseRepo from "../BaseRepo";

export default class WorkSpaceRepo extends BaseRepo {
  private static instance: WorkSpaceRepo | null = null;

  public static getInstance(dispatcher: Dispatch): WorkSpaceRepo {
    if (!this.instance) {
      this.instance = new WorkSpaceRepo(dispatcher);
    }
    return this.instance;
  }

  private get state(): WorkSpaceState {
    return store.getState().workspace;
  }
}
