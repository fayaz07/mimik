import React from "react";

import { ViewState, ViewStatus } from "@mimik/utils/src/view/ViewStatus";

import ErrorWithMessage from "../error/Error";
import Loader from "../loader/Loader";
import LoaderWithMessage from "../loader/LoaderWithMessage";

function LoadingError(props: { viewState: ViewStatus }) {
  const { viewState } = props;
  // eslint-disable-next-line default-case
  switch (viewState.state) {
    case ViewState.LOADING:
      return <LoaderWithMessage msg={viewState.message} />;
    case ViewState.ERROR:
      return <ErrorWithMessage msg={viewState.message} />;
  }
  return <Loader />;
}

export default LoadingError;
