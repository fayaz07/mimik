import React, { ReactNode } from "react";

import ArrowBackIcon from "@mui/icons-material/ArrowBack";
import { IconButton } from "@mui/material";
import { useNavigate } from "react-router-dom";

import "./_.scss";

function BackHandler(props: {
  backNavPath: string;
  onBackNav: (() => void) | null;
}) {
  const navigate = useNavigate();
  const { backNavPath, onBackNav } = props;

  const onBackNavClick = () => {
    if (onBackNav !== null && onBackNav !== undefined) {
      onBackNav!();
      return;
    }
    navigate(backNavPath);
  };
  if (
    (!backNavPath || backNavPath.length === 0) &&
    (!onBackNav || onBackNav === null || onBackNav === undefined)
  ) {
    return null;
  }

  return (
    <IconButton className="appBar-icon me-3" onClick={onBackNavClick}>
      <ArrowBackIcon />
    </IconButton>
  );
}

function CustomAppbar(props: {
  backNavPath: string;
  onBackNav: (() => void) | null;
  title: string;
  actions: ReactNode | null;
}) {
  const { backNavPath, onBackNav, title, actions } = props;

  return (
    <div className="appBar">
      <BackHandler backNavPath={backNavPath} onBackNav={onBackNav} />

      <h4 className="appBar-text">{title}</h4>
      {actions && <div>{actions}</div>}
    </div>
  );
}

export default CustomAppbar;
