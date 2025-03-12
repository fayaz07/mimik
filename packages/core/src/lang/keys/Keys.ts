import TranslationKeys from "./TranslationKeys";

// this file contains keys for translation objects
// used in the application
// refer to [./TranslationKeys.ts] for the structure of the object
// why keys? to avoid hardcoding strings in the application and
// error prone typos
const translationKeys = {
  navRailMenu: {
    dashboard: "navRailMenu.dashboard",
    workspaces: "navRailMenu.workspaces",
    teams: "navRailMenu.teams",
    settings: "navRailMenu.settings",
  },
} as TranslationKeys;

export default translationKeys;
