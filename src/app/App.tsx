import React, { useEffect } from "react";
import UpdateElectron from "@/components/update";
import { RouterProvider, createBrowserRouter } from "react-router-dom";
import logo from "./assets/logo.png";

function App() {
  const router = createBrowserRouter([]);
  return <RouterProvider router={router} />;
}

export default App;
