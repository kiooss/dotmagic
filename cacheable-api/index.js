"use strict";

const https = require("https");
const path = require("path");
const os = require("os");
const fs = require("fs");

const cacheDir = path.join(os.homedir(), ".cache", "cacheable-api");

if (!fs.existsSync(cacheDir)) {
  try {
    fs.mkdirSync(cacheDir);
  } catch (err) {
    console.error(err);
  }
}

function handleError(key, err) {
  let p = path.join(cacheDir, `${key}.error`);
  let log = fs.createWriteStream(p);
  log.write(new Date() + "\n");
  log.write(err.stack + "\n");
  console.log(`#[fg=red]${p.replace(os.homedir(), "~")}`);
}

function minutesAgo(minutes) {
  let d = new Date();
  d.setMinutes(d.getMinutes() - minutes);
  return d;
}

function getJSON(url) {
  return new Promise((resolve, _reject) => {
    https
      .get(url, res => {
        let body = "";
        res.setEncoding("utf-8");
        res
          .on("error", e => {
            throw e;
          })
          .on("data", data => {
            body += data;
          })
          .on("end", () => {
            if (res.statusCode !== 200) {
              throw new Error(body);
            } else {
              resolve(JSON.parse(body));
            }
          });
      })
      .on("error", e => {
        throw e;
      });
  });
}

function cacheableRequest(key, fn, expiredInMinutes) {
  const f = path.join(cacheDir, `${key}.json`);

  return function(url) {
    return new Promise((resolve, _reject) => {
      fs.stat(f, (_, stat) => {
        if (stat && minutesAgo(expiredInMinutes) < stat.mtime) {
          fs.readFile(f, (err, data) => {
            if (err) {
              throw err;
            }
            resolve(JSON.parse(data));
          });
        } else {
          fn(url)
            .then(res => {
              fs.writeFile(f, JSON.stringify(res), err => {
                if (err) {
                  throw err;
                }
              });
              resolve(res);
            })
            .catch(err => {
              throw err;
            });
        }
      });
    });
  };
}

module.exports = {
  cacheableRequest,
  getJSON,
  handleError
};
