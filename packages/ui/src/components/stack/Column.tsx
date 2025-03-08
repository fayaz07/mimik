import React from "react";
import Stack from "@mui/material/Stack";

export interface ColumnProps {
  gap?: number;
  alignItems?:
    | "normal"
    | "start"
    | "center"
    | "end"
    | "stretch"
    | "baseline"
    | "flex-start"
    | "flex-end";
  justifyContent?:
    | "unset"
    | "start"
    | "center"
    | "end"
    | "stretch"
    | "space-between"
    | "space-around"
    | "space-evenly";
  children: React.ReactNode[];
}

Column.defaultProps = {
  gap: 0,
  alignItems: "normal",
  justifyContent: "unset",
};

export default function Column(props: ColumnProps) {
  const { gap, alignItems, justifyContent } = props;

  return (
    <div
      style={{
        display: "flex",
        flexDirection: "column",
        gap,
        alignItems,
        justifyContent,
      }}
    >
      {...props.children}
    </div>
  );
}
