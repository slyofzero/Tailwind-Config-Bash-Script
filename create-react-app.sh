# Checking if an app name has been provided.
read -r -p "Enter your app name: " appName;
if [ -z $appName ]; then
  echo -e "Please enter a valid React App name\n(Just add one in the command itself!)";
  exit;
fi

# Open VSCode on completion?
read -r -p "Open VSCode on completion? (y/n): " openCode;

# React with Typescript
echo -e "\nCreating React app with TypeScript and TailwindCSS"
printf -- '-%.0s' {1..75}; echo "";

yarn create vite $appName --template react-ts;

echo -e "\nYour React App is Ready.\nOraganizing files in folders and removing ununsed content.\n";
cd $appName;

npm install;
cd public;
rm logo*;
cd ..;
rm -r src;
mkdir src;
cd src;
mkdir Hooks Components Context Styles;

echo 'import { FC } from "react";

const App: FC = () => {
  return <div></div>;
};

export default App;
' > App.tsx;

echo 'import React from "react";
import ReactDOM from "react-dom/client";
import "./Styles/tailwind.css";
import App from "./App";

const root = ReactDOM.createRoot(
  document.getElementById("root") as HTMLElement
);
root.render(
  <React.StrictMode>
    <App />
  </React.StrictMode>
);
' > index.tsx;

echo '/// <reference types="vite/client" />' > vite-env.d.ts

cd ..;

# Tailwind Stuff
printf -- '-%.0s' {1..75}; echo "";
echo -e "Configuring TailwindCSS.\n"
yarn add tailwindcss postcss postcss-import postcss-cli autoprefixer;
yarn add -D prettier-plugin-tailwindcss;

echo '/** @type {import("tailwindcss").Config} */
module.exports = {
  content: ["./src/**/*.{js,jsx,ts,tsx}"],
  theme: {
    extend: {},
  },
  plugins: [],
}
' > tailwind.config.js;

echo 'module.exports = {
  plugins: {
    "postcss-import": {},
    "tailwindcss/nesting": {},
    tailwindcss: {},
    autoprefixer: {},
  }
}
' > postcss.config.js;

echo '@tailwind base;
@tailwind components;
@tailwind utilities;

/* || Custom CSS */
@layer components {

}
' > ./src/Styles/index.css;

jq '.scripts = {
    "dev": "vite",
    "build": "tsc && vite build",
    "preview": "vite preview"
    "build:css": "yarn postcss ./src/Styles/index.css -o ./src/Styles/tailwind.css --watch",
    "prettier": "yarn prettier --write ./src/**/*.{js,jsx,ts,tsx}"
  }' package.json > temp.json;
mv temp.json package.json;

yarn postcss ./src/Styles/index.css -o ./src/Styles/tailwind.css;

echo -e "\nYour React app has been configured with Typescript and TailwindCSS.\nHappy hacking!!\n"
printf -- '-%.0s' {1..75}; echo "";

if [ $openCode == "y" ]; then
  echo -e "\nOpening VSCode";
  sleep 2s;
  code .
fi