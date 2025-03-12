import React from "react";

import keys from "@mimik/core/src/lang/keys/Keys";
import { Spinner } from "react-bootstrap";
import { useTranslation } from "react-i18next";

function Loader() {
  const { t } = useTranslation();

  return (
    <div className="users-scr-loader">
      <Spinner animation="border" role="status">
        <span className="visually-hidden">{t(keys.common.loading)}</span>
      </Spinner>
    </div>
  );
}

export default Loader;
