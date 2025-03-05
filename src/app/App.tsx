import React, { useEffect } from "react";
import UpdateElectron from "@/components/update";
import { RouterProvider, createBrowserRouter } from "react-router-dom";
// import { connect } from "@mimik/local/src/realm/config";
import routes from "./Routes";

interface ElectronAPI {
  insertItem: (itemName: string) => void;
  onItemInserted: (callback: (itemName: string) => void) => void;
  getItems: () => void;
  onItemsFetched: (callback: (items: any[]) => void) => void;
}

declare global {
  interface Window {
    electronAPI: ElectronAPI;
  }
}

function App() {
  // connect();
  console.log("say hello");
  useEffect(() => {
    window.electronAPI.onItemInserted((newItemName) => {
      console.log(`Item inserted: ${newItemName}`);
      window.electronAPI.getItems();
    });

    window.electronAPI.onItemsFetched((fetchedItems) => {
      console.log("fetched items", fetchedItems);
      // setItems(fetchedItems);
    });

    console.log("inserting name thoughtworks");
    window.electronAPI.insertItem("Thoughtworks");

    window.electronAPI.getItems();
  }, []);

  const router = createBrowserRouter(routes);
  return <RouterProvider router={router} />;
}

export default App;
