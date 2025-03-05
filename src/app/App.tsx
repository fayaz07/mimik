import React, { useEffect } from "react";
import UpdateElectron from "@/components/update";
import { RouterProvider, createBrowserRouter } from "react-router-dom";
// import { connect } from "@mimik/local/src/realm/config";
import routes from "./Routes";

function App() {
  // connect();
  const router = createBrowserRouter(routes);
  return <RouterProvider router={router} />;
}

export default App;
