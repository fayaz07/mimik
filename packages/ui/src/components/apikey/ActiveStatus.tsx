import React from "react";

import BBadge from "../badge/BBadge";
import "./_.scss";

export default function ActiveStatus(props: { deprecated: boolean }) {
  const { deprecated } = props;
  return (
    <BBadge danger={deprecated} text={deprecated ? "Inactive" : "Active"} />
  );
}
