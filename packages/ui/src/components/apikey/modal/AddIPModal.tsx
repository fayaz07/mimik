import React, { useState } from "react";

import keys from "@mimik/core/src/lang/keys/Keys";
import { TextField } from "@mui/material";
import { Address4, Address6 } from "ip-address";
import { Button, Modal } from "react-bootstrap";
import { useTranslation } from "react-i18next";

const validIPv6 = Address6.isValid;
const validIPv4 = Address4.isValid;

function AddIPModal(props: {
  show: boolean;
  // eslint-disable-next-line no-unused-vars
  onAdd: (ip: string) => void;
  onCancel: () => void;
}) {
  const { show, onAdd, onCancel } = props;
  const { t } = useTranslation();
  const [ip, setIp] = useState("");
  const [errorMsg, setErrorMsg] = useState("");

  return (
    <Modal show={show} onHide={onCancel}>
      <Modal.Header closeButton>
        <Modal.Title>{t(keys.ipAddress.addIpAddress)}</Modal.Title>
      </Modal.Header>

      <Modal.Body>
        <TextField
          id="outlined-basic"
          label={t(keys.ipAddress.ipAddress)}
          variant="outlined"
          value={ip}
          onChange={(e) => {
            setIp(e.target.value);
            setErrorMsg("");
          }}
          error={errorMsg.length > 0}
          helperText={errorMsg}
        />
      </Modal.Body>

      <Modal.Footer>
        <Button variant="light" onClick={onCancel}>
          {t(keys.common.cancel)}
        </Button>
        <Button
          variant="danger"
          onClick={() => {
            if (validIPv4(ip) || validIPv6(ip)) {
              onAdd(ip);
              setIp("");
            } else {
              setErrorMsg(t(keys.ipAddress.invalidIpAddress));
            }
          }}
        >
          {t(keys.common.confirm)}
        </Button>
      </Modal.Footer>
    </Modal>
  );
}

export default AddIPModal;
