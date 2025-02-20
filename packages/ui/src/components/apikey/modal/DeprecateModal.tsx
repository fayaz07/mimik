import React from "react";

import keys from "@ed/core/src/lang/keys/Keys";
import { Button, Modal } from "react-bootstrap";
import { useTranslation } from "react-i18next";

function DeprecateAPIKeyModal(props: {
  show: boolean;
  onConfirm: () => void;
  onCancel: () => void;
}) {
  const { show, onConfirm, onCancel } = props;
  const { t } = useTranslation();

  return (
    <Modal show={show} onHide={onCancel}>
      <Modal.Header closeButton>
        <Modal.Title>{t(keys.ipAddress.confirmDeprecate)}</Modal.Title>
      </Modal.Header>

      <Modal.Body>
        <p>{t(keys.ipAddress.confirmDeprecateMessage)}</p>
      </Modal.Body>

      <Modal.Footer>
        <Button variant="light" onClick={onCancel}>
          {t(keys.common.cancel)}
        </Button>
        <Button variant="danger" onClick={onConfirm}>
          {t(keys.common.confirm)}
        </Button>
      </Modal.Footer>
    </Modal>
  );
}

export default DeprecateAPIKeyModal;
