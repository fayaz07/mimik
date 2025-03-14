import Card, { CardContent } from "@mimik/ui/src/components/card";
import "./workspace.scss";
import { Typography } from "@mimik/ui/src/components/modal";
import Icons from "@mimik/ui/src/components/icons";

export default function AddWorkSpaceCard(props: { onClick: () => void }) {
  const { onClick } = props;
  return (
    <Card
      className="workspace_add"
      variant="outlined"
      role="button"
      onClick={onClick}
    >
      <CardContent className="workspace_add_content">
        <Icons.addIcon className="workspace_add_content_icon" />
        <Typography>Create new workspace</Typography>
      </CardContent>
    </Card>
  );
}
