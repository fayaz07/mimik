import React from "react";
import Card from "@mimik/ui/src/components/card";
import Stack from "@mimik/ui/src/components/stack";
import Space from "@mimik/ui/src/components/space";
import { AppSpinnerWithMsg } from "@mimik/ui/src/components/spinner/AppSpinner";

export default function WorkSpacesList() {
  return (
    <Stack>
      <Space spacing={16} />
      <AppSpinnerWithMsg msg="Loading workspaces" />
    </Stack>
  );
}
