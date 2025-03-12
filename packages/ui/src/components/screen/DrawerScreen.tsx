import React, { ReactNode, useEffect } from "react";

import navMenuRepo from "@mimik/repo/src/navMenu";
import { useNavMenuState } from "@mimik/repo/src/store/AppRootStore";
import AppNavbar from "@mimik/ui/src/components/navbar/AppNavbar";
import NavRailMenu from "@mimik/ui/src/components/navrail_menu";
import getNavRailMenuData from "@mimik/ui/src/components/navrail_menu/NavRailMenuData";
import NavRailMenuOption from "@mimik/ui/src/components/navrail_menu/NavRailMenuOption";

import "./_.scss";

function Content(props: {
  section: NavRailMenuOption;
  content: ReactNode;
  title: string;
}) {
  const { section, content, title } = props;

  const state = useNavMenuState();

  return (
    <div>
      <AppNavbar title={title} showMenu={state.showMenu} />
      <div className="home-content">
        <NavRailMenu
          activeRouteId={getNavRailMenuData(section).menuId}
          showMenu={state.showMenu}
          onToggleMenu={navMenuRepo.setShowMenu}
        />
        <div className="home-content-body">{content}</div>
      </div>
    </div>
  );
}

export default function DrawerScreen(props: {
  section: NavRailMenuOption;
  content: ReactNode;
  title: string;
}) {
  const { content, title, section } = props;

  useEffect(() => {
    document.title = title;
  }, []);

  return <Content section={section} content={content} title={title} />;
}
