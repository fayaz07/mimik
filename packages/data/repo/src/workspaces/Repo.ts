import { Dispatch } from "@reduxjs/toolkit";
import { actions } from "./Store";
import WorkSpaceState from "./State";
import store from "../store/AppRootStore";
import BaseRepo from "../BaseRepo";
import ApiCallStatus from "@mimik/types/src/api/ApiCallStatus";
import ElectronAPI from "@mimik/core/src/app/ElectronAPI";

export default class WorkSpaceRepo extends BaseRepo {
  private static instance: WorkSpaceRepo | null = null;
  private localApi: ElectronAPI["workspaces"];

  constructor(dispatcher: Dispatch) {
    super(dispatcher);

    this.showAddModal = this.showAddModal.bind(this);
    this.hideAddModal = this.hideAddModal.bind(this);
    this.setCreateName = this.setCreateName.bind(this);
    this.setCreateDesc = this.setCreateDesc.bind(this);
    this.saveNewWorkspace = this.saveNewWorkspace.bind(this);
    this.localApi = window.electronAPI.workspaces;
  }

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
    const result = await this.localApi.getAll();
    console.log("WorkSpaceRepo.fetchAll", result);
    if (result.success && result.data !== null) {
      this.dispatch(actions.setList(result.data!));
      this.dispatch(actions.setFetchApiStatus(this.idle()));
    } else {
      this.dispatch(actions.setFetchApiStatus(this.error(result.error!)));
    }
  }

  // add modal
  showAddModal() {
    this.dispatch(actions.setShowAddModal(true));
  }

  hideAddModal() {
    this.dispatch(actions.setShowAddModal(false));
  }

  setCreateName(value: string) {
    this.dispatch(actions.setCreateName(value));
  }

  setCreateDesc(value: string) {
    this.dispatch(actions.setCreateDesc(value));
  }

  private setCreateApiStatus(status: ApiCallStatus) {
    this.dispatch(actions.setCreateApiStatus(status));
  }

  async saveNewWorkspace() {
    this.setCreateApiStatus(this.loading());

    const { name, desc } = this.state;

    const result = await this.localApi.create(name, desc);
    if (result.success) {
      this.dispatch(actions.add(result.data!));
      this.setCreateApiStatus(this.idle());
      this.hideAddModal();
    } else {
      this.setCreateApiStatus(
        this.error("Failed to add workspace, please try later")
      );
    }
  }
}
