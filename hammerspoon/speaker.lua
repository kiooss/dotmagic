local speaker = hs.speech.new("Alex")
speaker:speak("Hammerspoon is online")
hs.notify.new({ title = "Hammerspoon launch", informativeText = "Boss, at your service" }):send()
