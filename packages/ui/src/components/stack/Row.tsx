import React from "react";

export interface RowProps {
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

Row.defaultProps = {
  gap: 0,
  alignItems: "normal",
  justifyContent: "unset",
};

export default function Row(props: RowProps) {
  const { gap, alignItems, justifyContent } = props;

  return (
    <div
      style={{
        display: "flex",
        flexDirection: "row",
        gap,
        alignItems,
        justifyContent,
      }}
    >
      {...props.children}
    </div>
  );
}
