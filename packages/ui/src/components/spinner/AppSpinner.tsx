import React from "react";
import { CircularProgress } from "@mui/joy";
import MacSpinner from "./MacSpinner";
import "./_.scss";

const platform = import.meta.env.PLATFORM;

export default function AppSpinner() {
  if (platform === "darwin") {
    return <MacSpinner />;
  }

  return <CircularProgress size="sm" />;
}

export function AppSpinnerWithMsg(props: { msg: string }) {
  const { msg } = props;

  if (platform === "darwin") {
    return (
      <div className="appSpinnerWithText">
        <MacSpinner />
        <p className="appSpinnerWithText_content">{msg}</p>
      </div>
    );
  }

  return (
    <div className="appSpinnerWithText">
      <CircularProgress size="sm" />
      <p className="appSpinnerWithText_content">{msg}</p>
    </div>
  );
}
