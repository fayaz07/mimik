import i18next from "i18next";
import LanguageDetector from "i18next-browser-languagedetector";
import { initReactI18next } from "react-i18next";

import TranslationKeys from "./keys/TranslationKeys";
import en from "./locales/en.json";

const resources = {
  en: { translation: en as TranslationKeys },
};

i18next
  .use(initReactI18next)
  .use(LanguageDetector)
  .init({
    debug: true,
    fallbackLng: "en",
    resources,
    interpolation: {
      escapeValue: false, // Disable escaping to allow HTML rendering
    },
  });
