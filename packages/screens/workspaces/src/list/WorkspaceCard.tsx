import React from "react";
import Card, {
  CardContent,
  CardOverflow,
  AspectRatio,
} from "@mimik/ui/src/components/card";
import WorkspaceEntity from "@mimik/local/src/entity/WorkSpace";
import { Typography } from "@mimik/ui/src/components/modal";
import workspaceCoverImg from "@mimik/ui/src/assets/images/workspace_cover_def.webp";
import "./workspace.scss";

export default function WorkspaceCard(props: { item: WorkspaceEntity }) {
  const { item } = props;
  return (
    <Card variant="soft" className="workspace_item">
      <CardOverflow>
        <AspectRatio ratio="3">
          <img className="workspace_item_img" src={workspaceCoverImg} />
        </AspectRatio>
      </CardOverflow>
      <CardContent>
        <Typography typography="title-md" className="m-0 p-0">
          {item.name}
        </Typography>
        <Typography typography="body-sm" className="m-0 p-0">
          {item.desc}
        </Typography>
      </CardContent>
    </Card>
  );
}
