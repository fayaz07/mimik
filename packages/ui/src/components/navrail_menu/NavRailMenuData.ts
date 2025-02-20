import React from "react";

import keys from "@ed/core/src/lang/keys/Keys";
import AppRoutes from "@ed/core/src/routes";
import CachedUserRole from "@ed/repo/src/user/CachedUserRole";
import { AiFillAppstore } from "react-icons/ai";
import { BsPersonSquare } from "react-icons/bs";
import { CiMoneyBill } from "react-icons/ci";
import { FaChalkboardTeacher } from "react-icons/fa";
import { GrDocumentConfig, GrUserAdmin } from "react-icons/gr";
import { HiOutlineHome } from "react-icons/hi";
import { IoCalendarOutline } from "react-icons/io5";
import {
  // MdMenuBook,
  MdInventory,
  MdPerson,
} from "react-icons/md";
// eslint-disable-next-line no-unused-vars
import { PiExam, PiStudentBold } from "react-icons/pi";
import { RiAdminLine, RiBookMarkedFill } from "react-icons/ri";
import { SiGoogleclassroom } from "react-icons/si";

import NavRailMenuOption from "./NavRailMenuOption";

interface NavRailMenuData {
  menuId: string;
  title: string;
  icon: React.ComponentType;
  route: string;
}

const dashboard = {
  menuId: "dashboard",
  title: keys.navRailMenu.dashboard,
  icon: HiOutlineHome,
  route: AppRoutes.Dashboard,
} as NavRailMenuData;

const applications = {
  menuId: "applications",
  title: keys.navRailMenu.applications,
  icon: AiFillAppstore,
  route: AppRoutes.APIKey.list,
} as NavRailMenuData;

const config = {
  menuId: "config",
  title: keys.navRailMenu.config,
  icon: GrDocumentConfig,
  route: AppRoutes.Config.home,
};

const myProfile = {
  menuId: "myProfile",
  title: keys.navRailMenu.myProfile,
  icon: MdPerson,
  route: AppRoutes.Users.myProfile,
};

// Users
const itTeam = {
  menuId: "it_team",
  title: keys.navRailMenu.administrators,
  icon: GrUserAdmin,
  route: AppRoutes.Users.list(CachedUserRole.admin),
} as NavRailMenuData;

const management = {
  menuId: "management",
  title: keys.navRailMenu.management,
  icon: RiAdminLine,
  route: AppRoutes.Users.list(CachedUserRole.management),
} as NavRailMenuData;

const staff = {
  menuId: "staff",
  title: keys.navRailMenu.staff,
  icon: FaChalkboardTeacher,
  route: AppRoutes.Users.list(CachedUserRole.staff),
} as NavRailMenuData;

const students = {
  menuId: "students",
  title: keys.navRailMenu.students,
  icon: PiStudentBold,
  route: AppRoutes.Users.list(CachedUserRole.student),
} as NavRailMenuData;

const designations = {
  menuId: "designations",
  title: keys.navRailMenu.designations,
  icon: BsPersonSquare,
  route: AppRoutes.Users.Designation.home,
} as NavRailMenuData;

// Academics
// const exams = {
//   menuId: "exams",
//   title: keys.navRailMenu.exams,
//   icon: PiExam,
//   route: AppRoutes.Exams.home,
// } as NavRailMenuData;

const years = {
  menuId: "years",
  title: keys.navRailMenu.years,
  icon: SiGoogleclassroom,
  route: AppRoutes.Years.home,
} as NavRailMenuData;

// const courses = {
//   menuId: "courses",
//   title: keys.navRailMenu.courses,
//   icon: MdMenuBook,
//   route: AppRoutes.Users.home,
// } as NavRailMenuData;

const subjects = {
  menuId: "subjects",
  title: keys.navRailMenu.subjects,
  icon: RiBookMarkedFill,
  route: AppRoutes.Subjects.home,
} as NavRailMenuData;

const fees = {
  menuId: "fees",
  title: keys.navRailMenu.fees,
  icon: CiMoneyBill,
  route: AppRoutes.Fee.home,
} as NavRailMenuData;

const academicYears = {
  menuId: "academic_years",
  title: keys.navRailMenu.academicYears,
  icon: IoCalendarOutline,
  route: AppRoutes.AcademicYear.home,
} as NavRailMenuData;

// Inventory
const products = {
  menuId: "products",
  title: keys.navRailMenu.products,
  icon: MdInventory,
  route: AppRoutes.Users.home,
} as NavRailMenuData;

function getNavRailMenuData(menu: NavRailMenuOption): NavRailMenuData {
  switch (menu) {
    case NavRailMenuOption.Dashboard:
      return dashboard;
    case NavRailMenuOption.ApiKeys:
      return applications;
    case NavRailMenuOption.Config:
      return config;
    case NavRailMenuOption.MyProfile:
      return myProfile;

    // Users
    case NavRailMenuOption.IT_Team:
      return itTeam;
    case NavRailMenuOption.Management:
      return management;
    case NavRailMenuOption.Staff:
      return staff;
    case NavRailMenuOption.Students:
      return students;
    case NavRailMenuOption.Designations:
      return designations;

    // Academics
    // case NavRailMenuOption.Exams:
    //   return exams;
    case NavRailMenuOption.Years:
      return years;
    // case NavRailMenuOption.Courses:
    //   return courses;
    case NavRailMenuOption.Subjects:
      return subjects;
    case NavRailMenuOption.Fees:
      return fees;
    case NavRailMenuOption.AcademicYear:
      return academicYears;

    // Inventory
    case NavRailMenuOption.Products:
      return products;

    default:
      return dashboard;
  }
}

export default getNavRailMenuData;
export type { NavRailMenuData };
