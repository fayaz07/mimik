import React from "react";

import ApiCallStatus from "@mimik/types/src/api/ApiCallStatus";

import ErrorWithMessage from "../error/Error";
import Loader from "../loader/Loader";
import LoaderWithMessage from "../loader/LoaderWithMessage";

function ApiCallStatusWrapper(props: {
  api: ApiCallStatus;
  message: string;
  content: React.ReactNode;
}) {
  const { api, message, content } = props;
  // eslint-disable-next-line default-case
  switch (api) {
    case ApiCallStatus.loading:
      return <LoaderWithMessage msg={message} />;
    case ApiCallStatus.error:
      return <ErrorWithMessage msg={message} />;
    case ApiCallStatus.idle:
      return content;
  }
  return <Loader />;
}

export default ApiCallStatusWrapper;
