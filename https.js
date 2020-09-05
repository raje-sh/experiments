const app = require("./app");
const https = require("https");
const fs = require("fs");

https
  .createServer(
    {
      key: fs.readFileSync("secret/privatekey.pem"),
      cert: fs.readFileSync("secret/cert_signed.pem"),
    },
    app
  )
  .listen(process.env.PORT || 3000, () => {
    console.log("server started over https");
  });
