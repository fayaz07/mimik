import React, { useEffect } from "react";
import UpdateElectron from "@/components/update";
import logo from "./assets/logo.png";

function App() {
  useEffect(() => {
    document.title = "Electron React App";
  }, []);

  return <div className="App"></div>;
}

export default App;
