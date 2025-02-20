import React from "react";

import logo from "@ed/ui/src/assets/logo.png";
import ChevronLeftIcon from "@mui/icons-material/ChevronLeft";
import MenuIcon from "@mui/icons-material/Menu";
import { CssBaseline, Divider, IconButton } from "@mui/material";
import MuiDrawer from "@mui/material/Drawer";
import { CSSObject, Theme, styled } from "@mui/material/styles";

import NavMenuByCategory from "./MenuButtons";
import "./_.scss";

const drawerWidth = 200;

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
  role: string;
  activeRouteId: string;
  showMenu: boolean;
  // eslint-disable-next-line no-unused-vars
  onToggleMenu: (show: boolean) => void;
}) {
  const { role, activeRouteId, showMenu, onToggleMenu } = props;

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
          <IconButton
            className="navRailMenu_closeIcon"
            onClick={() => onToggleMenu(false)}
          >
            <ChevronLeftIcon />
          </IconButton>
          <img src={logo} alt="logo" className="navRailMenu_logo" />
        </div>
      ) : (
        <div className="navRailMenu_collapsed">
          <IconButton onClick={() => onToggleMenu(true)}>
            <MenuIcon />
          </IconButton>
        </div>
      )}
      <Divider />
      <NavMenuByCategory
        userRole={role}
        activeRouteId={activeRouteId}
        showMenu={showMenu}
      />
    </Drawer>
  );
}

export default NavRailMenu;
