const { App } = require("@slack/bolt");
const path = require("path");
const envalid = require("envalid");
const result = require("dotenv").config({
  path: path.resolve(__dirname, ".env"),
});

const env = envalid.cleanEnv(process.env, {
  SLACK_SIGNING_SECRET: envalid.str(),
  SLACK_BOT_TOKEN: envalid.str(),
  SLACK_APP_TOKEN: envalid.str(),
  PORT: envalid.num(),
});

const app = new App({
  token: env.SLACK_BOT_TOKEN,
  signingSecret: env.SLACK_SIGNING_SECRET,
  // appToken: env.SLACK_APP_TOKEN,
  socketMode: false,
});

app.message("hello", async ({ message, say }) => {
  await say(`Hey there <@${message.user}>!`);
});

(async () => {
  // Start your app
  await app.start(env.PORT);

  console.log("⚡️ Bolt app is running!");
})();
