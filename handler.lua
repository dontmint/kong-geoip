local plugin_name = ({...})[1]:match("^kong%.plugins%.([^%.]+)")

local plugin = require("kong.plugins.base_plugin"):extend()
local inspect = require 'inspect'
local geoip_module = require 'geoip'
local geoip_country = require 'geoip.country'
local geoip_country_filename = '/usr/share/GeoIP/GeoIP.dat'
local singletons = require "kong.singletons"

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
  local current_ip = ngx.var.remote_addr
  local country_code = geoip_country.open(geoip_country_filename):query_by_addr(current_ip).code
--[DEBUG]  kong.log.err("Plugin config type : ", type(conf))

  if conf.mode == "Blacklist" then 
    for i,line in ipairs(conf.blacklist_countries) do
      if line == country_code then
        block = 1
      end
    end
  elseif conf.mode == "Whitelist" then
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
