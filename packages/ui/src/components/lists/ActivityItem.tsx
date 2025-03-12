import React from "react";

import keys from "@mimik/core/src/lang/keys/Keys";
import { Activity } from "@mimik/types/src/response/apikey/FullApiKeyResponse";
import { getFormattedDate } from "@mimik/utils/src/Date";
import { Table } from "react-bootstrap";
import { useTranslation } from "react-i18next";

function ActivityItem(props: { activity: Activity }) {
  const { activity } = props;
  return (
    <tr>
      <td>{activity.event}</td>
      <td>
        <a href={`/${activity.author.id}`}>{activity.author.name}</a>
      </td>
      <td>{activity.data}</td>
      <td>{getFormattedDate(activity.on)}</td>
    </tr>
  );
}

function ActivityList(props: { activity: Activity[] }) {
  const { activity } = props;
  const { t } = useTranslation();

  const list = activity.map((e: Activity) => {
    return <ActivityItem key={`act-item-${e.on}`} activity={e} />;
  });
  return (
    <Table striped bordered hover responsive>
      <thead>
        <tr>
          <th>{t(keys.common.event)}</th>
          <th>{t(keys.common.author)}</th>
          <th>{t(keys.common.data)}</th>
          <th>{t(keys.common.timestamp)}</th>
        </tr>
      </thead>
      <tbody>{list}</tbody>
    </Table>
  );
}

export default ActivityList;
