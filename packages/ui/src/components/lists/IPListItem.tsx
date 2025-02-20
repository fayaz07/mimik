import React from "react";

import { DeleteOutline } from "@mui/icons-material";
import { IconButton } from "@mui/material";

import "./_.scss";

function IPListItem(props: { ip: string; onDel: () => void }) {
  const { ip, onDel } = props;
  return (
    <div className="ipLi">
      <p className="ipLi-ip">{ip}</p>
      <IconButton className="ipLi-button" onClick={onDel}>
        <DeleteOutline color="error" />
      </IconButton>
    </div>
  );
}

export default IPListItem;
