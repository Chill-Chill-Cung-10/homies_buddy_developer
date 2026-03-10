module.exports = {
  root: true,
  env: {
    es6: true,
    node: true,
  },
  rules: {
    "linebreak-style": "off",      // tắt CRLF check
    "require-jsdoc":"off",      // tắt JSDoc requirement
    "valid-jsdoc":     "off",      // tắt JSDoc validation
    "camelcase":       "off",      // cho phép snake_case
    "max-len":         "off",      // tắt max line length
    "object-curly-spacing": "off", // tắt spacing trong object
    "key-spacing":     "off",      // tắt key spacing
    "no-multi-spaces": "off",
    "quotes": ["error", "double"],
    "import/no-unresolved": 0,
    "indent": ["error", 2],
  },
  extends: [
    "eslint:recommended",
    "plugin:import/errors",
    "plugin:import/warnings",
    "plugin:import/typescript",
    "google",
    "plugin:@typescript-eslint/recommended",
  ],
  parser: "@typescript-eslint/parser",
  parserOptions: {
    project: [
      __dirname + "/tsconfig.json",
      __dirname + "/tsconfig.dev.json",
    ],
    sourceType: "module",
  },
  ignorePatterns: [
    "/lib/**/*", // Ignore built files.
    "/generated/**/*", // Ignore generated files.
  ],
  plugins: [
    "@typescript-eslint",
    "import",
  ],
};
