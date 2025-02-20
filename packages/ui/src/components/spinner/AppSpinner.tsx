import React from "react";
import { CircularProgress } from "@mui/material";
import MacSpinner from "./MacSpinner";

const platform = import.meta.env.PLATFORM;

export default function AppSpinner() {
  if (platform === "darwin") {
    return <MacSpinner />;
  }

  return <CircularProgress />;
}
