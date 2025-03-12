import ApiCallStatus from "@mimik/types/src/api/ApiCallStatus";
import WorkspaceEntity from "@mimik/local/src/entity/Workspace";

export default interface WorkSpaceState {
  fetchApi: ApiCallStatus;
  createApi: ApiCallStatus;
  updateApi: ApiCallStatus;
  deleteApi: ApiCallStatus;

  list: WorkspaceEntity[];
}
