import React from "react";

import "./_.scss";

export function ListItemWithCustomContent(props: {
  title: string;
  content: any;
}) {
  const { title, content } = props;
  return (
    <div className="listItem">
      <p className="listItem-title">{title}</p>
      {content}
    </div>
  );
}

export function ListItemWithClass(props: {
  className: string;
  title: string;
  content: string;
}) {
  const { title, content, className } = props;
  return (
    <div className={`${className}`}>
      <p className="listItem-title">{title}</p>
      <p className="listItem-content">{content}</p>
    </div>
  );
}

export default function ListItem(props: { title: string; content: string }) {
  const { title, content } = props;
  return (
    <div className="listItem">
      <p className="listItem-title">{title}</p>
      <p className="listItem-content">{content}</p>
    </div>
  );
}
