import store from "../store/AppRootStore";
import NavMenuRepo from "./Repo";

const repo = new NavMenuRepo(store.dispatch);

export default repo;
