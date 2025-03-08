import { Dispatch } from "@reduxjs/toolkit";
import BaseRepo from "../BaseRepo";

export default class ProjectsRepo extends BaseRepo {
  private static instance: ProjectsRepo | null = null;

  public static getInstance(dispatcher: Dispatch): ProjectsRepo {
    if (!this.instance) {
      this.instance = new ProjectsRepo(dispatcher);
    }
    return this.instance;
  }
}
