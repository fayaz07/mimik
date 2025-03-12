import React from "react";

import keys from "@mimik/core/src/lang/keys/Keys";
import { Spinner } from "react-bootstrap";
import { useTranslation } from "react-i18next";

import "./_.scss";

function LoaderWithMessage(props: { msg: string }) {
  const { msg } = props;
  const { t } = useTranslation();

  return (
    <div className="loader-wMsg mt-3">
      <Spinner animation="border" role="status" className="loader-wMsg-spinner">
        <span className="visually-hidden">{t(keys.common.loading)}</span>
      </Spinner>
      <p className="loader-wMsg-text">{msg}</p>
    </div>
  );
}

export default LoaderWithMessage;
