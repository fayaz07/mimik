import CachedUserRole from "@ed/repo/src/user/CachedUserRole";
import NavRailMenuOption from "@ed/ui/src/components/navrail_menu/NavRailMenuOption";

const admin = [
  NavRailMenuOption.Dashboard,
  NavRailMenuOption.ApiKeys,
  NavRailMenuOption.Config,
  NavRailMenuOption.MyProfile,

  NavRailMenuOption.IT_Team,
  NavRailMenuOption.Management,
  NavRailMenuOption.Staff,
  NavRailMenuOption.Students,
  NavRailMenuOption.Designations,

  NavRailMenuOption.AcademicYear,
  NavRailMenuOption.Years,
  NavRailMenuOption.Subjects,
  NavRailMenuOption.Fees,

  NavRailMenuOption.Products,
];

const student = [
  NavRailMenuOption.Dashboard,
  NavRailMenuOption.MyProfile,
  NavRailMenuOption.Subjects,
  NavRailMenuOption.Fees,
  NavRailMenuOption.Years,
  NavRailMenuOption.Products,
];

const management = [
  NavRailMenuOption.Dashboard,
  NavRailMenuOption.Config,
  NavRailMenuOption.MyProfile,

  NavRailMenuOption.IT_Team,
  NavRailMenuOption.Management,
  NavRailMenuOption.Staff,
  NavRailMenuOption.Students,
  NavRailMenuOption.Designations,

  NavRailMenuOption.AcademicYear,
  NavRailMenuOption.Years,
  NavRailMenuOption.Subjects,
  NavRailMenuOption.Fees,

  NavRailMenuOption.Products,
];

const staff = [
  NavRailMenuOption.Dashboard,
  NavRailMenuOption.MyProfile,

  NavRailMenuOption.Staff,
  NavRailMenuOption.Students,

  NavRailMenuOption.Years,
  NavRailMenuOption.Subjects,
];

export default function getRoleBasedMenu(role: string): NavRailMenuOption[] {
  switch (role) {
    case CachedUserRole.admin:
      return admin;
    case CachedUserRole.management:
      return management;
    case CachedUserRole.staff:
      return staff;
    case CachedUserRole.student:
      return student;
    default:
      return [NavRailMenuOption.MyProfile];
  }
}
