package = "kong-geoip"
version = "0.1.0-0" 
local pluginName = package:match("^kong%-(.+)$")
supported_platforms = {"linux", "macosx"}
source = {
  url = "git://github.com/dontmint/kong-geoip.git",
  tag = "master"
}

description = {
  summary = "Working with MaxMind's GeoIP Lib",
  license = "MIT"
}

build = {
  type = "builtin",
  modules = {
    ["kong.plugins."..pluginName..".handler"] = "./handler.lua",
    ["kong.plugins."..pluginName..".schema"] = "./schema.lua",
  }
}
