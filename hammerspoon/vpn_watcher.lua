local obj = {}

obj.vpnConnected = false

function obj:init(localIp, fnConnected, fnUnconnected)
  self.menubar = hs.menubar.new()
  self.menubar:setTitle("󰖂")

  hs.network.reachability
    .forAddress(localIp)
    :setCallback(function(_, flags)
      -- note that because having an internet connection at all will show the remote network
      -- as "reachable", we instead look at whether or not our specific address is "local" instead
      if (flags & hs.network.reachability.flags.isLocalAddress) > 0 then
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

return obj
