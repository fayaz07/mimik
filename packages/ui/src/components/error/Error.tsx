import React from "react";

import error from "../../assets/error.png";
import "./_.scss";

function ErrorWithMessage(props: { msg: string }) {
  const { msg } = props;
  return (
    <div className="eError-wMsg">
      <img src={error} alt="error" className="eError-ig" />
      <p className="eError-wMsg-text">{msg}</p>
    </div>
  );
}

export default ErrorWithMessage;
