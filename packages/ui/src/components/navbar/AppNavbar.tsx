import React from "react";

import keys from "@ed/core/src/lang/keys/Keys";
import AppRoutes from "@ed/core/src/routes";
import authRepo from "@ed/repo/src/auth/index";
import CachedUserRole from "@ed/repo/src/user/CachedUserRole";
import UserModel from "@ed/types/src/user/User";
import Logout from "@mui/icons-material/Logout";
import { Account } from "@toolpad/core/Account";
import {
  AuthenticationContext,
  Session,
  SessionContext,
} from "@toolpad/core/AppProvider";
import Navbar from "react-bootstrap/Navbar";
import { useTranslation } from "react-i18next";
import { useNavigate } from "react-router-dom";

import "./_.scss";

// import { Avatar } from "@mui/material";

// function ProfileDropdownMenu() {
//   const navigate = useNavigate();
//   const { t } = useTranslation();

//   return (
//     <div className="profile-section-popup">
//       <Button
//         variant="link"
//         className="profile-section-popup-btn-logout"
//         onClick={() => {
//           authRepo.auth.logout();
//           navigate(AppRoutes.Auth.login);
//         }}
//       >
//         {t(keys.navBar.logOut)}
//       </Button>
//     </div>
//   );
// }

function stringKeyByRole(role: string): string {
  switch (role) {
    case CachedUserRole.admin:
      return keys.user.roles.admin;
    case CachedUserRole.student:
      return keys.user.roles.student;
    case CachedUserRole.staff:
      return keys.user.roles.staff;
    case CachedUserRole.management:
      return keys.user.roles.management;
    case CachedUserRole.parent:
      return keys.user.roles.parent;
    default:
      return " ";
  }
}

// const demoSession = {
//   user: {
//     name: "",
//     email: "",
//     image: "",
//   },
// };

function AccountCustomSlotProps(props: { user: UserModel }) {
  const { user } = props;
  const { t } = useTranslation();
  const navigate = useNavigate();

  // eslint-disable-next-line react/jsx-no-constructed-context-values
  const session = {
    user: {
      id: user.uId.toString(),
      name: `${user.firstName} ${user.lastName}`,
      email: t(stringKeyByRole(user.role)),
      image: user.firstName,
    },
  } as Session;

  const authentication = React.useMemo(() => {
    return {
      signIn: () => {},
      signOut: () => {
        authRepo.auth.logout();
        navigate(AppRoutes.Auth.login);
      },
    };
  }, []);

  return (
    <AuthenticationContext.Provider value={authentication}>
      <SessionContext.Provider value={session}>
        {/* preview-start */}
        <Account
          slotProps={{
            signInButton: {
              color: "success",
            },
            signOutButton: {
              color: "success",
              startIcon: <Logout />,
            },
            preview: {
              variant: "expanded",
              slotProps: {
                avatarIconButton: {
                  sx: {
                    width: "fit-content",
                    margin: "auto",
                  },
                },
                avatar: {
                  variant: "rounded",
                },
              },
            },
          }}
        />
        {/* preview-end */}
      </SessionContext.Provider>
    </AuthenticationContext.Provider>
  );
}

// function ProfileSection(props: { user: UserModel }) {
//   const { user } = props;
//   const [showProfileMenu, setShowProfileMenu] = useState(false);
//   const { t } = useTranslation();

//   const handleMouseEnter = () => {
//     setShowProfileMenu(true);
//   };

//   const handleMouseLeave = () => {
//     setShowProfileMenu(false);
//   };

//   return (
//     <div className="profile-section-parent">
//       <Image
//         src={logo}
//         alt="avatar"
//         className="profile-section-avatar shadow-sm"
//         roundedCircle
//       />
//       <div className="profile-section-details">
//         <p className="profile-section-details-name">
//           {`${user.firstName} ${user.lastName}`}
//         </p>
//         <p className="profile-section-details-role">
//           {t(stringKeyByRole(user.role))}
//         </p>
//       </div>
//       <CgChevronDownR className="profile-section-icon" />
//       {showProfileMenu && <ProfileDropdownMenu />}
//     </div>
//   );
// }

function AppNavbar(props: { userData: UserModel }) {
  const { userData } = props;

  return (
    <Navbar className="app-navbar shadow-sm">
      <Navbar.Toggle />
      <Navbar.Collapse className="justify-content-end app-navbar-profile">
        {/* <ProfileSection user={userData} /> */}
        <AccountCustomSlotProps user={userData} />
      </Navbar.Collapse>
    </Navbar>
  );
}

export default AppNavbar;
