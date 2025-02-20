import React from "react";

import { Badge } from "react-bootstrap";

import "./_.scss";

export default function BBadge(props: {
  danger: boolean | false;
  text: string;
}) {
  const { danger, text } = props;

  let bg = "success";
  if (danger) {
    bg = "danger";
  }

  return (
    <Badge className="bbadge" bg={bg}>
      {text}
    </Badge>
  );
}
