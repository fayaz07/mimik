/*
 * ------------------------IMPORTANT-------------------
 * Please add data for newly added menu option in the other file (NavRailMenuData.ts)
 */
enum NavRailMenuOption {
  Dashboard = 1,
  Workspaces,
  Teams,
  Settings,
}

export type NavRailMenuDataMap = {
  title: string;
  menu: NavRailMenuOption[];
};

const menuOptionsMap = {
  default: {
    title: "",
    menu: [
      NavRailMenuOption.Dashboard,
      NavRailMenuOption.Workspaces,
      NavRailMenuOption.Teams,
      NavRailMenuOption.Settings,
    ],
  } as NavRailMenuDataMap,
};

export { menuOptionsMap };

export default NavRailMenuOption;
