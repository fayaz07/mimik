import { Dispatch } from "@reduxjs/toolkit";
import { actions } from "./Store";
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

  async fetchAll() {
    this.dispatch(actions.setFetchApiStatus(this.loading()));
    const result = await window.electronAPI.workspaces.getAll();
    console.log("WorkSpaceRepo.fetchAll", result);
    if (result.success && result.data !== null) {
      this.dispatch(actions.setList(result.data!));
      this.dispatch(actions.setFetchApiStatus(this.idle()));
    } else {
      this.dispatch(actions.setFetchApiStatus(this.error(result.error!)));
    }
  }
}
