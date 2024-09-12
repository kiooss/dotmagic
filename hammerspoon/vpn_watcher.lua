local obj = {}
local util = require("util")

obj.vpnConnected = false

function obj:init(localIp, fnConnected, fnUnconnected)
  self.menubar = hs.menubar.new()
  if self:getVpnLocalIp() ~= nil then
    -- VPN tunnel is up
    self.menubar:setTitle("󰖂 🔐🈲🈲🈲🈲🈲🈲🈲🈲")
  else
    -- VPN tunnel is down
    self.menubar:setTitle("󰖂")
  end

  hs.network.reachability
    .forAddress(localIp)
    :setCallback(function(_, flags)
      -- note that because having an internet connection at all will show the remote network
      -- as "reachable", we instead look at whether or not our specific address is "local" instead
      -- if (flags & hs.network.reachability.flags.isLocalAddress) > 0 then
      if self:getVpnLocalIp() ~= nil then
        -- VPN tunnel is up
        self.menubar:setTitle("󰖂 🔐🈲🈲🈲🈲🈲🈲🈲🈲")
        fnConnected()
      else
        -- VPN tunnel is down
        fnUnconnected()
        self.menubar:setTitle("󰖂")
      end
    end)
    :start()
end

function obj:getVpnLocalIp()
  return hs.fnutils.find(hs.network.addresses(), function(addr)
    return string.match(addr, "^10.212.135.%d") ~= nil
  end)
end

return obj
