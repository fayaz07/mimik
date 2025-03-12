import React from "react";
import Stack from "../stack";
import errorImg from "../../assets/images/error.png";
import "./_.scss";

export default function Error(props: { msg: string }) {
  const { msg } = props;

  return (
    <Stack alignItems="center" justifyContent="center">
      <img
        src={errorImg}
        alt="something-went-wrong"
        className="error-img mt-16"
      />
      <p className="error-text">{msg}</p>
    </Stack>
  );
}
