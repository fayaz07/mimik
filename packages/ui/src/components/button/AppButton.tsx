import React from "react";

import { Button, Spinner } from "react-bootstrap";

import "./_.scss";

export default function AppButton(props: {
  loading: boolean;
  content: string;
  onClick: () => void;
  variant: string;
  // eslint-disable-next-line react/require-default-props
  className?: string | undefined;
}) {
  const { loading, content, onClick, variant, className } = props;
  return (
    <Button
      variant={variant}
      disabled={loading}
      onClick={onClick}
      className={`${className || ""} appButton`}
    >
      {loading && (
        <Spinner animation="border" className="loading_btn_spinner" />
      )}
      {content}
    </Button>
  );
}

function AppButtonWithSize(props: {
  loading: boolean;
  content: string;
  onClick: () => void;
  variant: string;
  size: "sm" | "lg";
  // eslint-disable-next-line react/require-default-props
  className?: string | undefined;
}) {
  const { loading, content, onClick, variant, className, size } = props;
  return (
    <Button
      variant={variant}
      disabled={loading}
      onClick={onClick}
      size={size}
      className={`${className || ""} appButton`}
    >
      {loading && (
        <Spinner animation="border" className="loading_btn_spinner" />
      )}
      {content}
    </Button>
  );
}

export function AppButtonLG(props: {
  loading: boolean;
  content: string;
  onClick: () => void;
  variant: string;
  // eslint-disable-next-line react/require-default-props
  className?: string | undefined;
}) {
  const { loading, content, onClick, variant, className } = props;

  return (
    <AppButtonWithSize
      loading={loading}
      content={content}
      onClick={onClick}
      variant={variant}
      size="lg"
      className={className}
    />
  );
}

export function AppButtonSM(props: {
  loading: boolean;
  content: string;
  onClick: () => void;
  variant: string;
  // eslint-disable-next-line react/require-default-props
  className?: string | undefined;
}) {
  const { loading, content, onClick, variant, className } = props;

  return (
    <AppButtonWithSize
      loading={loading}
      content={content}
      onClick={onClick}
      variant={variant}
      size="sm"
      className={className}
    />
  );
}
