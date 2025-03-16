import React from "react";
import Card, {
  CardContent,
  CardOverflow,
  AspectRatio,
} from "@mimik/ui/src/components/card";
import WorkspaceEntity from "@mimik/local/src/entity/WorkSpace";
import workspaceCoverImg from "@mimik/ui/src/assets/images/workspace_cover_def.webp";
import "./workspace.scss";
import Icons from "@mimik/ui/src/components/icons";

export default function WorkspaceCard(props: {
  item: WorkspaceEntity;
  onClick: (id: number) => void;
}) {
  const { item, onClick } = props;
  return (
    <Card
      variant="outlined"
      className="workspace_item"
      role="button"
      onClick={() => {
        onClick(item.id);
      }}
    >
      <CardOverflow>
        <AspectRatio ratio="3">
          <img className="workspace_item_img" src={workspaceCoverImg} />
        </AspectRatio>
      </CardOverflow>
      <CardContent>
        <div>
          <p className="m-0 p-0 subheading-2 workspace_item_name">
            {item.name}
          </p>
          <p className="m-0 p-0 body-1 workspace_item_desc">{item.desc}</p>
        </div>
        <div className="workspace_item_md">
          <div className="workspace_item_md_projects">
            <Icons.stack />
            <p className="m-0 p-0">0 projects</p>
          </div>
        </div>
      </CardContent>
    </Card>
  );
}
