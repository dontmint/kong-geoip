local plugin_name = ({...})[1]:match("^kong%.plugins%.([^%.]+)")
local plugin = require("kong.plugins.base_plugin"):extend()
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
	local country = gi:lookup_addr(ngx.var.remote_addr)
	--[DEBUG] 
	kong.log.err("Plugin DEBUG message : ", type(country))
        for k,v in pairs(country) do
		kong.log.err("Plugin DEBUG message : ", k .. " AND " .. v)
	end
	--[END DEBUG]
	if not country then
		kong.log.err("Plugin DEBUG message : Country not found")
		return
  	end 

  	local block = 0
  	if ( conf.mode == "Blacklist" and conf.blacklist_countries ~= nil ) then 
		local country_code = country["country_code"]
  		for i,line in ipairs(conf.blacklist_countries) do
  			if line == country_code then
        			block = 1
      			end
    		end
  	elseif ( conf.mode == "Whitelist" and conf.whitelist_countries ~= nil ) then
    		block = 1
		local country_code = country["country_code"]
    		for i,line in ipairs(conf.whitelist_countries) do
      			if line == country_code then
        			block = 0
				kong.log.err("Plugin DEBUG message : Unblock")
      			end
    		end
	elseif ( conf.mode == "Whitelist" and conf.whitelist_countries == nil ) then
		block = 1
  	end
  	if block == 1 then
  		kong.response.exit(403, "Access not available in your country : " .. country["country_name"])
  	end
end

plugin.PRIORITY = 991

return plugin