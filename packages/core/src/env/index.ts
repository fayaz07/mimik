interface AppEnv {
  env: string;
  isProd: boolean;
}

const ENVIRONMENTS = Object.freeze({
  dev: "dev",
  prod: "prod",
  stage: "stage",
  test: "test",
});

function checkIfEnvIsValid(env: string) {
  const isValid =
    env &&
    (env === ENVIRONMENTS.dev ||
      env === ENVIRONMENTS.prod ||
      env === ENVIRONMENTS.stage ||
      env === ENVIRONMENTS.test);
  if (!isValid) {
    console.error("[env-check]", `Invalid environment value found - ${env}`);
    process.exit(-1);
  }
}

let currentEnv = {} as AppEnv;

export function getEnv(): AppEnv {
  if (currentEnv.env && currentEnv.env.length > 0) {
    return currentEnv;
  }

  const env = import.meta.env.VITE_ENV;
  checkIfEnvIsValid(env);
  currentEnv = {
    env: env,
    isProd: env == ENVIRONMENTS.prod,
  } as AppEnv;
  return currentEnv;
}

export { ENVIRONMENTS };
export default AppEnv;
