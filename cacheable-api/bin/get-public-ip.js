#!/usr/bin/env node

const lib = require('../');

const NAME = "get-public-ip";
const getPublicIp = lib.cacheableRequest(NAME, lib.getJSON);

getPublicIp("https://ifconfig.me/all.json")
  .then(res => {
    const ip = res.ip_addr
    if (ip === "18.182.170.161") {
      console.log(`vpn: #[fg=red,bold]${ip}`);
    } else {
      console.log(`ip: ${ip}`, { fontStyle: "bold" });
    }
  })
  .catch(err => {
    lib.handleError(NAME, err);
  })
