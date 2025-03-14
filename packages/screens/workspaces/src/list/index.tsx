import React from "react";
import DrawerScreen from "@mimik/ui/src/components/screen/DrawerScreen";
import NavRailMenuOption from "@mimik/ui/src/components/navrail_menu/NavRailMenuOption";
import Content from "./Content";

export default function WorkspacesListScreen() {
  return (
    <DrawerScreen
      section={NavRailMenuOption.Workspaces}
      title="Workspaces"
      content={<Content />}
    />
  );
}
