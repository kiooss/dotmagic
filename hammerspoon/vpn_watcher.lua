local obj = {}

obj.vpnConnected = false

function obj:init(fnConnected, fnUnconnected)
  obj.vpnConnected = hs.fnutils.contains(hs.network.interfaces(), "ppp0")
  self.timer = hs.timer.doEvery(2, function()
    self:checkVpnConnected(fnConnected, fnUnconnected)
  end)
end

function obj:checkVpnConnected(fnConnected, fnUnconnected)
  local isVpnConnected = hs.fnutils.contains(hs.network.interfaces(), "ppp0")

  if isVpnConnected and not obj.vpnConnected then
    obj.vpnConnected = true
    print("vpn Connected")
    fnConnected()
    return
  end

  if not isVpnConnected and obj.vpnConnected then
    print("vpn not Connected")
    obj.vpnConnected = false
    fnUnconnected()
  end
end

return obj
