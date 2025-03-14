import AppRoutes from "@mimik/core/src/routes/AppRoutes";
import SplashScreen from "@mimik/splash-screen";
import HomeScreen from "@mimik/home-screen";
import WorkspacesListScreen from "@mimik/workspaces-screen/src/list";

const routes = [
  {
    path: AppRoutes.splash,
    element: <SplashScreen />,
  },
  {
    path: AppRoutes.home,
    element: <HomeScreen />,
  },
  {
    path: AppRoutes.workspaces,
    element: <WorkspacesListScreen />,
  },
];

export default routes;
