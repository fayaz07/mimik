import { ipcRenderer, contextBridge } from "electron";
import { events as workspaceEvents } from "@mimik/local/src/dao/Workspace";
import ElectronAPI from "@mimik/core/src/app/ElectronAPI";

contextBridge.exposeInMainWorld("electronAPI", {
  workspaces: {
    getAll: () => ipcRenderer.invoke(workspaceEvents.fetchAll),
    create: (name: string) => ipcRenderer.invoke(workspaceEvents.create, name),
    onAccessed: (id: number) =>
      ipcRenderer.invoke(workspaceEvents.accessed, id),
  },
} as ElectronAPI);
