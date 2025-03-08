import { configureStore, Dispatch } from "@reduxjs/toolkit";
import WorkSpaceRepo from "../workspaces/Repo";
import ProjectsRepo from "../projects/Repo";
import workspace from "../workspaces/Store";

const store = configureStore({
  reducer: {
    workspace,
  },
});

export type AppRootState = ReturnType<typeof store.getState>;
export type AppDispatch = typeof store.dispatch;

export default store;

export function useRepo<T extends typeof WorkSpaceRepo | typeof ProjectsRepo>(
  repoType: T
): InstanceType<T> {
  switch (repoType) {
    case WorkSpaceRepo:
      return WorkSpaceRepo.getInstance(store.dispatch) as InstanceType<T>;
    case ProjectsRepo:
      return ProjectsRepo.getInstance(store.dispatch) as InstanceType<T>;
    default:
      throw new Error("Invalid Repo type");
  }
}
