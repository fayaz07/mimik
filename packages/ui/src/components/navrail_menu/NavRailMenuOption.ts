/* eslint-disable no-unused-vars */
import keys from "@ed/core/src/lang/keys/Keys";

/*
 * ------------------------IMPORTANT-------------------
 * Please add data for newly added menu option in the other file (NavRailMenuData.ts)
 */
enum NavRailMenuOption {
  Dashboard = 1,
  ApiKeys,
  Config,
  MyProfile,

  // Users
  IT_Team,
  Management,
  Staff,
  Students,
  Designations,

  // Academics
  // Courses,
  Subjects,
  Fees,
  Years,
  AcademicYear,
  Exams,
  // Results,
  // Timetable,
  // Attendance,
  // Assignments,
  // Homework,
  // Library,
  // Transportation,
  // Hostel,
  // Certificates,
  // Reports,
  // Complaints,

  // Inventory
  Products,
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
      NavRailMenuOption.ApiKeys,
      NavRailMenuOption.Config,
      NavRailMenuOption.MyProfile,
    ],
  } as NavRailMenuDataMap,

  users: {
    title: keys.navRailMenu.users,
    menu: [
      NavRailMenuOption.IT_Team,
      NavRailMenuOption.Management,
      NavRailMenuOption.Staff,
      NavRailMenuOption.Students,
      NavRailMenuOption.Designations,
    ],
  } as NavRailMenuDataMap,

  academics: {
    title: keys.navRailMenu.academics,
    menu: [
      // NavRailMenuOption.Exams,
      NavRailMenuOption.AcademicYear,
      NavRailMenuOption.Years,
      // NavRailMenuOption.Courses,
      NavRailMenuOption.Subjects,
      NavRailMenuOption.Fees,
    ],
  } as NavRailMenuDataMap,

  inventory: {
    title: keys.navRailMenu.inventory,
    menu: [NavRailMenuOption.Products],
  } as NavRailMenuDataMap,
};

export { menuOptionsMap };

export default NavRailMenuOption;
