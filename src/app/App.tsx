import React, { useEffect } from "react";
import UpdateElectron from "@/components/update";
import store from "@mimik/repo/src/store/AppRootStore";
import { RouterProvider, createBrowserRouter } from "react-router-dom";
import routes from "./Routes";
import { Provider } from "react-redux";
import ElectronAPI from "@mimik/core/src/app/ElectronAPI";
import "@mimik/ui/src/styles/fonts.scss";
import "@mimik/ui/src/styles/common.scss";
import "@mimik/ui/src/styles/colors.scss";

declare global {
  interface Window {
    electronAPI: ElectronAPI;
  }
}

function setupFont() {
  const currPlatform = import.meta.env.PLATFORM;
  let customFont = "";
  if (currPlatform === "win32") {
    customFont = "Ubuntu";
  } else if (currPlatform === "darwin") {
    customFont = "SF-Pro-Display";
  } else if (currPlatform === "linux") {
    customFont = "Ubuntu";
  }
  document.body.style.fontFamily = customFont;
}

function App() {
  const router = createBrowserRouter(routes);

  setupFont();

  return (
    <Provider store={store}>
      <RouterProvider router={router} />
    </Provider>
  );
}

export default App;
