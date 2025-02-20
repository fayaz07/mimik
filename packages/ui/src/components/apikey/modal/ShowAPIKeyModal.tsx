import React from "react";

import keys from "@ed/core/src/lang/keys/Keys";
import { CopyAll } from "@mui/icons-material";
import { IconButton, Tooltip } from "@mui/material";
import { Alert, Button, Modal } from "react-bootstrap";
import { useTranslation } from "react-i18next";
import { toast } from "react-toastify";

import "./_.scss";

function ShowAPIKeyModal(props: {
  show: boolean;
  apiKey: string;
  onClose: () => void;
}) {
  const { show, apiKey, onClose } = props;
  const { t } = useTranslation();

  return (
    <Modal show={show} onHide={onClose}>
      <Modal.Header closeButton>
        <Modal.Title>{t(keys.ipAddress.apiKeyGenerated)}</Modal.Title>
      </Modal.Header>

      <Modal.Body>
        <Alert key="apiKey-alert" variant="primary" className="showKey-alert">
          <p>{apiKey}</p>
          <Tooltip title={t(keys.common.copy)}>
            <IconButton
              onClick={() => {
                navigator.clipboard.writeText(apiKey);
                toast.success(t(keys.ipAddress.apiKeyCopied));
              }}
            >
              <CopyAll />
            </IconButton>
          </Tooltip>
        </Alert>
        <p>{t(keys.ipAddress.saveApiKeyMessage)}</p>
      </Modal.Body>

      <Modal.Footer>
        <Button variant="info" onClick={onClose}>
          {t(keys.common.done)}
        </Button>
      </Modal.Footer>
    </Modal>
  );
}

export default ShowAPIKeyModal;
