import React from "react";

import keys from "@mimik/core/src/lang/keys/Keys";
import MinApiKey from "@mimik/types/src/response/apikey/MinApiKeyResponse";
import { Button } from "react-bootstrap";
import { useTranslation } from "react-i18next";

import ActiveStatus from "./ActiveStatus";
import "./_.scss";

const keyPrefix = "xxxxxxxx";

function ApiKeyComponent(props: {
  apiKey: MinApiKey;
  // eslint-disable-next-line no-unused-vars
  onViewClicked: (id: number) => void;
}) {
  const { apiKey, onViewClicked } = props;
  const formattedDate = new Date(apiKey.createdAt).toLocaleString();
  const { t } = useTranslation();

  return (
    <tr className="apikey-row">
      <td>{apiKey.version}</td>
      <td>{apiKey.type}</td>
      <td>
        <ActiveStatus deprecated={apiKey.deprecated} />
      </td>
      <td>{formattedDate}</td>
      <td>{keyPrefix + apiKey.tail}</td>
      <td>{apiKey.purpose}</td>
      <td>
        <Button variant="info" onClick={() => onViewClicked(apiKey.version)}>
          {t(keys.common.view)}
        </Button>
      </td>
    </tr>
  );
}

export default ApiKeyComponent;
