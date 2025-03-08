import ApiCallStatus from "@mimik/types/src/api/ApiCallStatus";
import WorkSpaceEntity from "@mimik/local/src/entity/WorkSpace";

export default interface WorkSpaceState {
  fetchApi: ApiCallStatus;
  createApi: ApiCallStatus;
  updateApi: ApiCallStatus;
  deleteApi: ApiCallStatus;

  list: WorkSpaceEntity[];
}
