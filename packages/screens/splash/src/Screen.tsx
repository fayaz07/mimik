import React, { useEffect } from "react";
import AppConfig from "@mimik/core/src/app/Config";

export default function SplashScreen() {
  useEffect(() => {
    document.title = AppConfig.name;
  }, []);

  return <div>Screen</div>;
}
