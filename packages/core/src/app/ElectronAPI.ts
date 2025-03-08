import WorkSpaceEntity from "packages/data/local/src/entity/WorkSpace";

export default interface ElectronAPI {
  workspaces: {
    getAll: () => WorkSpaceEntity[];
    create: (name: string) => WorkSpaceEntity;
  };
}
