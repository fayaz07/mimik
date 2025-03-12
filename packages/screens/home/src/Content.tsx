import React from "react";
import { whatPartOfTimeIsIt } from "@mimik/utils/src/Time";
import AppButton from "@mimik/ui/src/components/button/AppButton";
import Stack from "@mimik/ui/src/components/stack";
import Icons from "@mimik/ui/src/components/icons";
import { HorizontalDivider } from "@mimik/ui/src/components/divider";
import WorkSpacesList from "./WorkspacesList";
import "./_.scss";
import { useRepo } from "@mimik/repo/src/store/AppRootStore";
import WorkSpaceRepo from "@mimik/repo/src/workspaces/Repo";

function Greeting() {
  return <h4>Hello, Good {whatPartOfTimeIsIt()}</h4>;
}

function Header() {
  const workspaceRepo = useRepo(WorkSpaceRepo);

  return (
    <Stack direction="row" justifyContent="space-between" alignItems="center">
      <h5>Workspaces</h5>
      <AppButton
        size="sm"
        content="Add"
        prefix={
          <Icons.addIcon
            size="1.75em"
            style={{ marginLeft: "0px", marginRight: "4px" }}
          />
        }
        onClick={() => {}}
      />
    </Stack>
  );
}

export default function Content() {
  return (
    <Stack>
      <Greeting />
      <Header />
      <HorizontalDivider className="mb-8" />
      <WorkSpacesList />
    </Stack>
  );
}
