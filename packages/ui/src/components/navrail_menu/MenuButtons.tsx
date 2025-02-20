import React from "react";

import {
  Divider,
  List,
  ListItem,
  ListItemButton,
  ListItemIcon,
  ListItemText,
} from "@mui/material";
import { useTranslation } from "react-i18next";
import { useNavigate } from "react-router-dom";

import getNavRailMenuData from "./NavRailMenuData";
import NavRailMenuOption, { menuOptionsMap } from "./NavRailMenuOption";
import getRoleBasedMenu from "./RoleSpecificMenu";

const listItemBtnStyle = (showMenu: boolean) => [
  {
    minHeight: 48,
    px: 2.5,
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
        opacity: 1,
      }
    : {
        opacity: 0,
      },
];

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
              onClick={() => {
                navigate(data.route);
              }}
              selected={data.menuId === activeRouteId}
              sx={listItemBtnStyle(showMenu)}
            >
              <ListItemIcon sx={listItemIconStyle(showMenu)}>
                <data.icon />
              </ListItemIcon>
              <ListItemText
                primary={t(data.title)}
                sx={listItemTextStyle(showMenu)}
              />
            </ListItemButton>
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
  userRole: string;
  activeRouteId: string;
  showMenu: boolean;
}) {
  const { userRole, activeRouteId, showMenu } = props;

  const allowedOptions = getRoleBasedMenu(userRole);

  // show only allowed options
  const defMenu = menuOptionsMap.default.menu.filter((menu) =>
    allowedOptions.includes(menu)
  );

  const usersMenu = menuOptionsMap.users.menu.filter((menu) =>
    allowedOptions.includes(menu)
  );

  const academicsMenu = menuOptionsMap.academics.menu.filter((menu) =>
    allowedOptions.includes(menu)
  );

  const inventoryMenu = menuOptionsMap.inventory.menu.filter((menu) =>
    allowedOptions.includes(menu)
  );

  return (
    <List>
      <MenuList
        activeRouteId={activeRouteId}
        showMenu={showMenu}
        menuList={defMenu}
      />

      {usersMenu.length > 0 && (
        <Header title={menuOptionsMap.users.title} showMenu={showMenu} />
      )}
      <MenuList
        activeRouteId={activeRouteId}
        showMenu={showMenu}
        menuList={usersMenu}
      />

      {academicsMenu.length > 0 && (
        <Header title={menuOptionsMap.academics.title} showMenu={showMenu} />
      )}
      <MenuList
        activeRouteId={activeRouteId}
        showMenu={showMenu}
        menuList={academicsMenu}
      />

      {inventoryMenu.length > 0 && (
        <Header title={menuOptionsMap.inventory.title} showMenu={showMenu} />
      )}

      <MenuList
        activeRouteId={activeRouteId}
        showMenu={showMenu}
        menuList={inventoryMenu}
      />
    </List>
  );
}

export default NavMenuByCategory;
