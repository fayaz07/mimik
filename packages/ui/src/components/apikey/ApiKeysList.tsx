import React from "react";

import tKeys from "@ed/core/src/lang/keys/Keys";
import MinApiKey from "@ed/types/src/response/apikey/MinApiKeyResponse";
import Table from "react-bootstrap/Table";
import { useTranslation } from "react-i18next";

import ApiKeyComponent from "./ApiKey";

function ApiKeysListComponent(props: {
  keys: MinApiKey[];
  // eslint-disable-next-line no-unused-vars
  onViewClicked: (id: number) => void;
}) {
  const { keys, onViewClicked } = props;
  const { t } = useTranslation();

  const list = keys.map((e: MinApiKey) => {
    return (
      <ApiKeyComponent
        apiKey={e}
        key={e.version}
        onViewClicked={onViewClicked}
      />
    );
  });

  return (
    <Table striped bordered hover>
      <thead>
        <tr>
          <th>{t(tKeys.common.versionId)}</th>
          <th>{t(tKeys.common.type)}</th>
          <th>{t(tKeys.common.status)}</th>
          <th>{t(tKeys.common.createdOn)}</th>
          <th>{t(tKeys.common.key)}</th>
          <th>{t(tKeys.common.purpose)}</th>
          <th>{t(tKeys.common.actions)}</th>
        </tr>
      </thead>
      <tbody>{list}</tbody>
    </Table>
  );
}

export default ApiKeysListComponent;
