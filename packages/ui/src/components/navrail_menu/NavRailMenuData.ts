import React from "react";

import keys from "@mimik/core/src/lang/keys/Keys";
import AppRoutes from "@mimik/core/src/routes";
import { HiOutlineHome } from "react-icons/hi";
import { HiOutlineSquares2X2 } from "react-icons/hi2";
import { MdOutlinePeopleAlt } from "react-icons/md";
import { MdSettings } from "react-icons/md";
import NavRailMenuOption from "./NavRailMenuOption";
import { IconType } from "react-icons";

interface NavRailMenuData {
  menuId: string;
  title: string;
  icon: IconType;
  route: string;
}

const dashboard = {
  menuId: "dashboard",
  title: keys.navRailMenu.dashboard,
  icon: HiOutlineHome,
  route: AppRoutes.home,
} as NavRailMenuData;

const workspaces = {
  menuId: "workspaces",
  title: keys.navRailMenu.workspaces,
  icon: HiOutlineSquares2X2,
  route: AppRoutes.home,
};

const teams = {
  menuId: "teams",
  title: keys.navRailMenu.teams,
  icon: MdOutlinePeopleAlt,
  route: AppRoutes.home,
};

const settings = {
  menuId: "settings",
  title: keys.navRailMenu.settings,
  icon: MdSettings,
  route: AppRoutes.home,
};

function getNavRailMenuData(menu: NavRailMenuOption): NavRailMenuData {
  switch (menu) {
    case NavRailMenuOption.Dashboard:
      return dashboard;
    case NavRailMenuOption.Workspaces:
      return workspaces;
    case NavRailMenuOption.Teams:
      return teams;
    case NavRailMenuOption.Settings:
      return settings;

    default:
      return dashboard;
  }
}

export default getNavRailMenuData;
export type { NavRailMenuData };
