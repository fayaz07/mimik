import React, { useEffect } from "react";
import Card from "@mimik/ui/src/components/card";
import Stack from "@mimik/ui/src/components/stack";
import Space from "@mimik/ui/src/components/space";
import Icons from "@mimik/ui/src/components/icons";
import AppButton from "@mimik/ui/src/components/button/AppButton";
import ApiCallStatus, {
  isError,
  isIdle,
} from "@mimik/types/src/api/ApiCallStatus";
import { AppSpinnerWithMsg } from "@mimik/ui/src/components/spinner/AppSpinner";
import { useRepo, useWorkSpaceState } from "@mimik/repo/src/store/AppRootStore";
import WorkSpaceRepo from "@mimik/repo/src/workspaces/Repo";
import Error from "@mimik/ui/src/components/error";
import WorkspaceEntity from "@mimik/local/src/entity/Workspace";
import AddWorkspaceDialog from "../dialogs/Add";
import AddWorkspaceCard from "./AddWorkspaceCard";
import WorkspaceCard from "./WorkspaceCard";
import "./_.scss";

function Spinner() {
  return (
    <>
      <Space spacing={16} />
      <AppSpinnerWithMsg msg="Loading workspaces" />
    </>
  );
}

function List(props: {
  api: ApiCallStatus;
  list: WorkspaceEntity[];
  onAdd: () => void;
}) {
  const { api, list, onAdd } = props;

  if (isError(api)) {
    return <Error msg={api.msg} />;
  } else if (isIdle(api)) {
    // list is empty, never fetched
    // a fetch call should be made soon, until then show spinner
    if (list.length === 0 && api.lastReq === 0) {
      return <Spinner />;
    }

    const child = (
      <Stack direction="row" spacing={2}>
        {list.map((e) => {
          return <WorkspaceCard item={e} onClick={() => {}} />;
        })}
        <AddWorkspaceCard onClick={onAdd} />
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

function Header() {
  const workspaceRepo = useRepo(WorkSpaceRepo);

  return (
    <div className="wsLs_header">
      <h5>Recently Accessed</h5>
      <AppButton
        size="sm"
        content="Add"
        prefix={
          <Icons.addIcon
            size="1.75em"
            style={{ marginLeft: "0px", marginRight: "4px" }}
          />
        }
        onClick={workspaceRepo.showAddModal}
      />
    </div>
  );
}

export default function WorkSpacesList() {
  const repo = useRepo(WorkSpaceRepo);
  const state = useWorkSpaceState();

  useEffect(() => {
    repo.fetchAll();
  }, []);

  return (
    <Stack className="wsLs_body">
      <Header />
      <Space spacing={16} />
      <List
        api={state.fetchApi}
        list={state.list}
        onAdd={() => {
          repo.showAddModal();
        }}
      />
      <AddWorkspaceDialog
        show={state.showAddModal}
        api={state.createApi}
        name={state.name}
        onNameChange={repo.setCreateName}
        desc={state.desc}
        onDescChange={repo.setCreateDesc}
        onClose={repo.hideAddModal}
        onSave={repo.saveNewWorkspace}
      />
    </Stack>
  );
}
