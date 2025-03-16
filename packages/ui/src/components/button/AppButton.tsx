import React from "react";

import Button from "@mui/joy/Button";
import AppSpinner from "../spinner/AppSpinner";
import { CircularProgress } from "@mui/joy";
import "./_.scss";
import { capitalize } from "@mui/material";

// const platform = import.meta.env.PLATFORM;

// function getPlatformStyle() {
//   switch (platform) {
//     case "darwin":
//       return {
//         backgroundColor: "#007AFF",
//         color: "#fff",
//         paddingTop: 6,
//         paddingBottom: 6,
//         paddingLeft: 8,
//         paddingRight: 8,
//       };
//   }
//   return {};
// }

export interface AppButtonProps {
  content: string;
  capitalized?: boolean;
  onClick: () => void;

  variant?: "solid" | "outlined" | "soft" | "plain";
  size?: "sm" | "md" | "lg";
  loading?: boolean;
  enabled?: boolean;
  prefix?: React.ReactNode;
  suffix?: React.ReactNode;

  marginTop?: number;
  marginBottom?: number;
  marginLeft?: number;
  marginRight?: number;

  backgroundColor?: string;
  textColor?: string;
}

// default props
AppButton.defaultProps = {
  capitalized: false,

  variant: "solid",
  size: "md",
  loading: false,
  showLoader: false,
  enabled: true,
  prefix: null,
  suffix: null,

  marginTop: 0,
  marginBottom: 0,
  marginLeft: 0,
  marginRight: 0,
};

function getVariant(variant: string): "solid" | "outlined" | "soft" | "plain" {
  switch (variant) {
    case "outlined":
      return "outlined";
    case "soft":
      return "soft";
    case "plain":
      return "plain";
    default:
      return "solid";
  }
}

function getSize(size: string): {
  btnSize: "sm" | "md" | "lg";
  fontSize: string;
} {
  switch (size) {
    case "sm":
      return { btnSize: "sm", fontSize: "12px" };
    case "lg":
      return { btnSize: "lg", fontSize: "18px" };
    default:
      return { btnSize: "md", fontSize: "14px" };
  }
}

export default function AppButton(props: AppButtonProps) {
  const btnProps = {
    ...AppButton.defaultProps,
    ...props,
    // ...getPlatformStyle(),
  };

  const size = getSize(btnProps.size);

  return (
    <Button
      variant={getVariant(btnProps.variant)}
      disabled={btnProps.loading || !btnProps.enabled}
      onClick={btnProps.onClick}
      size={size.btnSize}
      style={{
        marginTop: btnProps.marginTop,
        marginBottom: btnProps.marginBottom,
        marginLeft: btnProps.marginLeft,
        marginRight: btnProps.marginRight,
        fontSize: size.fontSize,
        height: "fit-content",
        textTransform: btnProps.capitalized ? "capitalize" : "none",
      }}
    >
      {btnProps.prefix && btnProps.prefix}
      {btnProps.loading ? (
        <div className="appBtn_loading">
          <CircularProgress className="appBtn_spinner" />
          {btnProps.content}
        </div>
      ) : (
        btnProps.content
      )}
      {btnProps.suffix && btnProps.suffix}
    </Button>
  );
}
