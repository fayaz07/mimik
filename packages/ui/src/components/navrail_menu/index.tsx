import React from "react";

import logo from "@mimik/ui/src/assets/images/logo.png";
import { MdChevronLeft } from "react-icons/md";
import { CgMenuLeftAlt } from "react-icons/cg";
import { CssBaseline, Divider, IconButton } from "@mui/material";
import MuiDrawer from "@mui/material/Drawer";
import { CSSObject, Theme, styled } from "@mui/material/styles";

import NavMenuByCategory from "./MenuButtons";
import "./_.scss";

// note: check in constants.scss for the value of drawerWidth
const drawerWidth = 160;

const openedMixin = (theme: Theme): CSSObject => ({
  width: drawerWidth,
  transition: theme.transitions.create("width", {
    easing: theme.transitions.easing.sharp,
    duration: theme.transitions.duration.enteringScreen,
  }),
  overflowX: "hidden",
});

const closedMixin = (theme: Theme): CSSObject => ({
  transition: theme.transitions.create("width", {
    easing: theme.transitions.easing.sharp,
    duration: theme.transitions.duration.leavingScreen,
  }),
  overflowX: "hidden",
  width: `calc(${theme.spacing(7)} + 1px)`,
  [theme.breakpoints.up("sm")]: {
    width: `calc(${theme.spacing(8)} + 1px)`,
  },
});

const Drawer = styled(MuiDrawer, {
  shouldForwardProp: (prop) => prop !== "open",
})(({ theme }) => ({
  width: drawerWidth,
  flexShrink: 0,
  whiteSpace: "nowrap",
  boxSizing: "border-box",
  variants: [
    {
      props: ({ open }) => open,
      style: {
        ...openedMixin(theme),
        "& .MuiDrawer-paper": openedMixin(theme),
      },
    },
    {
      props: ({ open }) => !open,
      style: {
        ...closedMixin(theme),
        "& .MuiDrawer-paper": closedMixin(theme),
      },
    },
  ],
}));

function NavRailMenu(props: {
  activeRouteId: string;
  showMenu: boolean;
  // eslint-disable-next-line no-unused-vars
  onToggleMenu: (show: boolean) => void;
}) {
  const { activeRouteId, showMenu, onToggleMenu } = props;

  return (
    <Drawer
      variant="permanent"
      // sx={{
      //   width: drawerWidth,
      //   flexShrink: 0,
      //   [`& .MuiDrawer-paper`]: { width: drawerWidth, boxSizing: "border-box" },
      // }}
      open={showMenu}
    >
      <CssBaseline />
      {showMenu ? (
        <div className="navRailMenu_logoContainer">
          <img src={logo} alt="logo" className="navRailMenu_logo" />
          <IconButton
            className="navRailMenu_closeIcon"
            onClick={() => onToggleMenu(false)}
          >
            <MdChevronLeft />
          </IconButton>
        </div>
      ) : (
        <div className="navRailMenu_collapsed">
          <IconButton
            className="navRailMenu_closeIcon"
            onClick={() => onToggleMenu(true)}
          >
            <CgMenuLeftAlt />
          </IconButton>
        </div>
      )}
      <Divider />
      <NavMenuByCategory activeRouteId={activeRouteId} showMenu={showMenu} />
    </Drawer>
  );
}

export default NavRailMenu;
