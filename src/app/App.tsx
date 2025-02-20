import React, { useEffect } from "react";
import UpdateElectron from "@/components/update";
import { RouterProvider, createBrowserRouter } from "react-router-dom";
import routes from "./Routes";

function App() {
  const router = createBrowserRouter(routes);
  return <RouterProvider router={router} />;
}

export default App;
