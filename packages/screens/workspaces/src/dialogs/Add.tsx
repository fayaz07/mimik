import React from "react";
import Modal, { Typography } from "@mimik/ui/src/components/modal";
import AppButton from "@mimik/ui/src/components/button/AppButton";
import Space from "@mimik/ui/src/components/space";
import TextField from "@mimik/ui/src/components/textField";
import ApiCallStatus, { isLoading } from "@mimik/types/src/api/ApiCallStatus";

// TODO: need field validation
export default function AddWorkspaceDialog(props: {
  show: boolean;
  name: string;
  desc: string;
  api: ApiCallStatus;
  onNameChange: (value: string) => void;
  onDescChange: (value: string) => void;
  onClose: () => void;
  onSave: () => void;
}) {
  const { show, onClose, name, desc, onNameChange, onDescChange, onSave, api } =
    props;

  return (
    <Modal show={show} onHide={onClose}>
      <Modal.Header closeButton>
        <Modal.Title>Add Workspace</Modal.Title>
      </Modal.Header>
      <Modal.Body>
        <Typography textColor="text.tertiary">
          Fill the form below to add a new workspace
        </Typography>
        <Space spacing={8} />
        <TextField
          label="Name"
          helperText="A simple name"
          value={name}
          onChange={onNameChange}
        />
        <Space spacing={4} />
        <TextField
          label="Description"
          helperText="A brief description"
          value={desc}
          onChange={onDescChange}
        />
      </Modal.Body>
      <Modal.Footer>
        <AppButton variant="outlined" onClick={onClose} content="Close" />
        <Space spacing={4} />
        <AppButton onClick={onSave} content="Save" loading={isLoading(api)} />
      </Modal.Footer>
    </Modal>
  );
}
