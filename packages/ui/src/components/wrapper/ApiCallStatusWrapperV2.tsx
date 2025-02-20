import React from "react";

import ErrorWithMessage from "../error/Error";
import LoaderWithMessage from "../loader/LoaderWithMessage";

function ApiCallStatusWrapperV2(props: {
  showContent: boolean;
  loadingMsg: string;
  error: boolean;
  errorMsg: string;
  content: React.ReactNode;
}) {
  const { showContent, errorMsg, content, loadingMsg, error } = props;

  if (error) {
    return <ErrorWithMessage msg={errorMsg} />;
  }
  if (!showContent) {
    return <LoaderWithMessage msg={loadingMsg} />;
  }
  return content;
}

export default ApiCallStatusWrapperV2;
