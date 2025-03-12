import React, { useEffect } from "react";
import Card from "@mimik/ui/src/components/card";
import Stack from "@mimik/ui/src/components/stack";
import Space from "@mimik/ui/src/components/space";
import ApiCallStatus, {
  isError,
  isIdle,
} from "@mimik/types/src/api/ApiCallStatus";
import { AppSpinnerWithMsg } from "@mimik/ui/src/components/spinner/AppSpinner";
import { useRepo, useWorkSpaceState } from "@mimik/repo/src/store/AppRootStore";
import WorkSpaceRepo from "@mimik/repo/src/workspaces/Repo";
import Error from "@mimik/ui/src/components/error";
import WorkspaceEntity from "@mimik/local/src/entity/Workspace";
import AddWorkspaceDialog from "./dialogs/Add";

function Spinner() {
  return (
    <>
      <Space spacing={16} />
      <AppSpinnerWithMsg msg="Loading workspaces" />
    </>
  );
}

function AddWorkSpaceCard() {
  return (
    <Card>
      <p>Add Workspace</p>
    </Card>
  );
}

function List(props: { api: ApiCallStatus; list: WorkspaceEntity[] }) {
  const { api, list } = props;

  if (isError(api)) {
    return <Error msg={api.msg} />;
  } else if (isIdle(api)) {
    // list is empty, never fetched
    // a fetch call should be made soon, until then show spinner
    if (list.length === 0 && api.lastReq === 0) {
      return <Spinner />;
    }

    const child = (
      <Stack direction="row" spacing={8}>
        {list.map((e) => {
          return (
            <Card key={e.id}>
              <p>{e.name}</p>
            </Card>
          );
        })}
        <AddWorkSpaceCard />
      </Stack>
    );

    if (list.length === 0) {
      return (
        <Stack>
          <small style={{ textAlign: "center" }} className="text-muted">
            No workspaces found 😏, why don't you add one and fly 🚀
          </small>
          <Space spacing={8} />
          {child}
        </Stack>
      );
    } else {
      return child;
    }
  }

  // loading
  return <Spinner />;
}

export default function WorkSpacesList() {
  const repo = useRepo(WorkSpaceRepo);
  const state = useWorkSpaceState();

  useEffect(() => {
    repo.fetchAll();
  }, []);

  return (
    <Stack>
      <Space spacing={16} />
      <List api={state.fetchApi} list={state.list} />
      <AddWorkspaceDialog show={true} onClose={() => {}} />
    </Stack>
  );
}
