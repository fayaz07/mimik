import React, { useEffect } from "react";
import AppConfig from "@mimik/core/src/app/Config";
import logo from "@mimik/ui/src/assets/images/logo.png";
import AppSpinner from "@mimik/ui/src/components/spinner/AppSpinner";
import { useNavigate } from "react-router-dom";
import AppRoutes from "@mimik/core/src/routes/AppRoutes";
import "./_.scss";

export default function SplashScreen() {
  const navigate = useNavigate();

  useEffect(() => {
    document.title = AppConfig.name;

    setTimeout(() => {
      navigate(AppRoutes.home);
    }, 200);
  }, []);

  return (
    <div className="splashScr">
      <img src={logo} alt="app-logo" className="splashScr_logo" />
      <AppSpinner />
    </div>
  );
}
