import AppRoutes from "@mimik/core/src/routes/AppRoutes";
import SplashScreen from "@mimik/splash-screen";
import HomeScreen from "@mimik/home-screen";

const routes = [
  {
    path: AppRoutes.splash,
    element: <SplashScreen />,
  },
  {
    path: AppRoutes.home,
    element: <HomeScreen />,
  },
];

export default routes;
