import React, { useEffect } from "react";
import AppConfig from "@mimik/core/src/app/Config";
import logo from "@mimik/ui/src/assets/logo.png";
import AppSpinner from "@mimik/ui/src/components/spinner/AppSpinner";
import "./_.scss";

export default function SplashScreen() {
  useEffect(() => {
    document.title = AppConfig.name;
  }, []);

  return (
    <div className="splashScr">
      <img src={logo} alt="app-logo" className="splashScr_logo" />
      <AppSpinner />
    </div>
  );
}
