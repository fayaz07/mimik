import React from "react";
import Modal, {
  ModalClose,
  Typography,
  Sheet,
} from "@mimik/ui/src/components/modal";

export default function AddWorkspaceDialog(props: {
  show: boolean;
  onClose: () => void;
}) {
  const { show, onClose } = props;

  return (
    <Modal
      aria-labelledby="add-workspace-modal-title"
      aria-describedby="add-workspace-modal-desc"
      open={show}
      onClose={onClose}
      sx={{ display: "flex", justifyContent: "center", alignItems: "center" }}
    >
      <Sheet
        variant="outlined"
        sx={{ maxWidth: 500, borderRadius: "md", p: 3, boxShadow: "lg" }}
      >
        <ModalClose variant="plain" sx={{ m: 1 }} />
        <Typography
          component="h2"
          id="add-workspace-modal-title"
          level="h4"
          textColor="inherit"
          sx={{ fontWeight: "lg", mb: 1 }}
        >
          Add Workspace
        </Typography>
        <Typography id="add-workspace-modal-desc" textColor="text.tertiary">
          Fill the form below to add a new workspace
        </Typography>
      </Sheet>
    </Modal>
  );
}
