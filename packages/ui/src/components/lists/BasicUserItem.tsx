import React from "react";

import keys from "@mimik/core/src/lang/keys/Keys";
import { BasicUserData } from "@mimik/types/src/response/apikey/FullApiKeyResponse";
import { DeleteOutline } from "@mui/icons-material";
import { IconButton } from "@mui/material";
import { Table } from "react-bootstrap";
import { useTranslation } from "react-i18next";

import "./_user.scss";

function BasicUserItem(props: { id: number; name: string }) {
  const { id, name } = props;
  return (
    <tr className="basicUser">
      <td>{id}</td>
      <td>
        <a className="basicUser-name" href={`/${id}`}>
          {name}
        </a>
      </td>
      <td>
        <IconButton className="basicUser-button" onClick={() => {}}>
          <DeleteOutline color="error" />
        </IconButton>
      </td>
    </tr>
  );
}

function BasicUserItemList(props: { users: BasicUserData[] }) {
  const { users } = props;
  const { t } = useTranslation();

  const userList = users.map((e: BasicUserData) => {
    return <BasicUserItem id={e.id} name={e.name} key={`ui-apikey-${e.id}`} />;
  });
  return (
    <>
      {userList.length > 0 && (
        <Table striped bordered hover responsive>
          <thead>
            <tr>
              <th>{t(keys.common.userId)}</th>
              <th>{t(keys.common.name)}</th>
              <th>{t(keys.common.actions)}</th>
            </tr>
          </thead>
          <tbody>{userList}</tbody>
        </Table>
      )}
      {userList.length === 0 && <div>{t(keys.common.listIsEmpty)}</div>}
    </>
  );
}

export default BasicUserItemList;
