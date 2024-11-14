import React from "react";
import { createBrowserRouter, RouterProvider } from "react-router-dom";
import SplashScreen from "@mimik/splash-screen";

export default function AppRouter() {
  const routes = createBrowserRouter([
    {
      path: "/",
      element: <SplashScreen />,
    },
  ]);

  return <RouterProvider router={routes} />;
}
