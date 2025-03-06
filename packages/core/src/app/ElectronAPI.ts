import WorkSpace from "packages/data/local/src/entity/WorkSpace";

export default interface ElectronAPI {
  workspaces: {
    getAll: () => WorkSpace[];
    create: (name: string) => WorkSpace;
  };
}
