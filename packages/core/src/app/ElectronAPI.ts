import WorkspaceEntity from "@mimik/local/src/entity/Workspace";
import DBResult from "@mimik/types/src/api/DBResult";

export default interface ElectronAPI {
  workspaces: {
    getAll: () => Promise<DBResult<WorkspaceEntity[]>>;
    create: (name: string, desc: string) => Promise<DBResult<WorkspaceEntity>>;
    onAccessed: (id: number) => Promise<DBResult<WorkspaceEntity>>;
  };
}
