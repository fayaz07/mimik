/* eslint-disable react/require-default-props */
import React from "react";

import keys from "@ed/core/src/lang/keys/Keys";
import ApiCallStatus, {
  isError,
  isLoading,
} from "@ed/types/src/api/ApiCallStatus";
import { Alert } from "@mui/material";
import { useTranslation } from "react-i18next";

export default function ApiAlert(props: {
  className?: string;
  message: string;
  api: ApiCallStatus;
}) {
  const { className, message, api } = props;
  const { t } = useTranslation();
  const msglen = message.length > 0;

  if (isLoading(api) && msglen) {
    return (
      <Alert severity="info" className={className}>
        {message}
      </Alert>
    );
  }

  if (isError(api)) {
    if (!msglen) {
      return (
        <Alert severity="error" className={className}>
          {t(keys.common.unknownError)}
        </Alert>
      );
    }
    return (
      <Alert severity="error" className={className}>
        {t(message)}
      </Alert>
    );
  }

  if (msglen) {
    return (
      <Alert severity="success" className={className}>
        {t(message)}
      </Alert>
    );
  }

  return <> </>;
}
