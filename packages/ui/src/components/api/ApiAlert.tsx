/* eslint-disable react/require-default-props */
import React from "react";

import keys from "@mimik/core/src/lang/keys/Keys";
import ApiCallStatus, {
  isError,
  isLoading,
} from "@mimik/types/src/api/ApiCallStatus";
import { Alert } from "@mui/material";
import { useTranslation } from "react-i18next";

export default function ApiAlert(props: {
  className?: string;
  api: ApiCallStatus;
}) {
  const { className, api } = props;
  const { t } = useTranslation();
  const msglen = api.msg.length > 0;

  if (isLoading(api) && msglen) {
    return (
      <Alert severity="info" className={className}>
        {api.msg}
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
        {t(api.msg)}
      </Alert>
    );
  }

  if (msglen) {
    return (
      <Alert severity="success" className={className}>
        {t(api.msg)}
      </Alert>
    );
  }

  return <> </>;
}
