local plugin_name = ({...})[1]:match("^kong%.plugins%.([^%.]+)")

local plugin = require("kong.plugins.base_plugin"):extend()
-- local geoip_country = require 'geoip.country'
-- local geoip_country_filename = '/usr/share/GeoIP/GeoIP.dat'
-- local singletons = require "kong.singletons"

--
local geoip_module = require 'geoip'
gi = geoip_module.GeoIP()
gi:load_databases("memory")

function plugin:new()
  plugin.super.new(self, plugin_name)
end

-- Header_filter Phase
function plugin:header_filter(conf)
  plugin.super.access(self)
  if not conf then
  kong.response.exit(500, "Cannot read plugin config")
  end
end

-- Access Phase
function plugin:access(conf)
  plugin.super.access(self)
  local country_code = gi:lookup_addr(ngx.var.remote_addr).country_code
--[DEBUG] kong.log.err("Plugin config type : ", country_code)
  block = 0
  if ( conf.mode == "Blacklist" and conf.blacklist_countries ~= nil ) then 
    for i,line in ipairs(conf.blacklist_countries) do
      if line == country_code then
        block = 1
      end
    end
  elseif ( conf.mode == "Whitelist" and conf.whitelist_countries ~= nil ) then
    block = 1
    for i,line in ipairs(conf.whitelist_countries) do
      if line == country_code then
        block = 0
      end
    end
  end
  
  if block == 1 then 
    kong.response.exit(403, "Access Forbiden")
  end
end

plugin.PRIORITY = 991

return plugin
