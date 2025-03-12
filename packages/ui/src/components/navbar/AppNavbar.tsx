import React from "react";
import Navbar from "react-bootstrap/Navbar";

import "./_.scss";

function AppNavbar(props: { title: string; showMenu: boolean }) {
  const { title, showMenu } = props;
  return (
    <Navbar className="app-navbar shadow-sm">
      <Navbar.Toggle />
      <p
        className={showMenu ? "app-navbar-title" : "app-navbar-title-collapsed"}
      >
        {title}
      </p>
      <Navbar.Collapse className="justify-content-end app-navbar-profile"></Navbar.Collapse>
    </Navbar>
  );
}

export default AppNavbar;
