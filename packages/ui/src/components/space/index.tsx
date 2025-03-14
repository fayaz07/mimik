import React from "react";

export interface SpaceProps {
  spacing: number;
}

Space.defaultProps = {
  spacing: 4,
};

export default function Space(props: SpaceProps) {
  const { spacing } = props;

  return <div style={{ height: `${spacing}px`, width: `${spacing}px` }} />;
}
