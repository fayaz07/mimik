import React from "react";

import { Divider, List, ListItem } from "@mui/material";
import { useTranslation } from "react-i18next";
import { useNavigate } from "react-router-dom";

import getNavRailMenuData from "./NavRailMenuData";
import NavRailMenuOption, { menuOptionsMap } from "./NavRailMenuOption";
import { Button, IconButton, Typography } from "@mui/joy";
import { IconType } from "react-icons";
import { CgChevronRight } from "react-icons/cg";

const listItemBtnStyle = (showMenu: boolean) => [
  {
    minHeight: 32,
    px: 1.0,
  },
  showMenu
    ? {
        justifyContent: "initial",
      }
    : {
        justifyContent: "center",
      },
];

const listItemIconStyle = (showMenu: boolean) => [
  {
    minWidth: 0,
    justifyContent: "center",
  },
  showMenu
    ? {
        mr: 3,
      }
    : {
        mr: "auto",
      },
];
const listItemTextStyle = (showMenu: boolean) => [
  showMenu
    ? {
        fontSize: "small",
        opacity: 1,
      }
    : {
        opacity: 0,
      },
];

function ListItemButton(props: {
  menuShown: boolean;
  onClick: () => void;
  selected: boolean;
  IconS: IconType;
  title: string;
}) {
  const { onClick, selected, IconS, title, menuShown } = props;

  if (!menuShown) {
    return (
      <div className="w-100 d-flex justify-content-center align-items-center mt-1 mb-1">
        <IconButton onClick={onClick} variant={selected ? "soft" : "plain"}>
          <IconS color={selected ? "primary" : "neutral"} />
        </IconButton>
      </div>
    );
  }

  return (
    <Button
      onClick={onClick}
      variant={selected ? "soft" : "plain"}
      sx={{
        width: "100%",
        display: "flex",
        justifyContent: "start",
        alignItems: "center",
        marginLeft: "8px",
        marginRight: "8px",
        gap: "8px",
        marginBottom: "8px",
      }}
    >
      {/* // TODO: fix the color */}
      <IconS color={selected ? "blue" : "gray"} />
      <Typography level="body-xs" color={selected ? "primary" : "neutral"}>
        {title}
      </Typography>
      {selected && <CgChevronRight />}
    </Button>
  );
}

function MenuList(props: {
  activeRouteId: string;
  showMenu: boolean;
  menuList: NavRailMenuOption[];
}) {
  const { activeRouteId, showMenu, menuList } = props;
  const { t } = useTranslation();
  const navigate = useNavigate();

  return (
    <List>
      {menuList.map((menu: NavRailMenuOption) => {
        const data = getNavRailMenuData(menu);

        return (
          <ListItem key={data.menuId} disablePadding>
            <ListItemButton
              menuShown={showMenu}
              IconS={data.icon}
              onClick={() => {
                console.log("navigating to ", data.route);
                navigate(data.route);
              }}
              selected={data.menuId === activeRouteId}
              title={t(data.title)}
            />
          </ListItem>
        );
      })}
    </List>
  );
}

function Header(props: { title: string; showMenu: boolean }) {
  const { title, showMenu } = props;
  const { t } = useTranslation();
  return (
    <div>
      {showMenu && <p className="navRailMenu_header">{t(title)}</p>}
      <Divider />
    </div>
  );
}

function NavMenuByCategory(props: {
  activeRouteId: string;
  showMenu: boolean;
}) {
  const { activeRouteId, showMenu } = props;

  return (
    <MenuList
      activeRouteId={activeRouteId}
      showMenu={showMenu}
      menuList={menuOptionsMap.default.menu}
    />
  );
}

export default NavMenuByCategory;
