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
	if not country then
    kong.log.err("Plugin DEBUG message : Country not found : ", ngx.var.remote_addr)
    kong.service.request.set_header(conf.inject_country_header, "VN")
    return
  end

	-- INJECT HEADER 
	if conf.inject_country_header ~= nil then
    kong.service.request.set_header(conf.inject_country_header, country["country_code"])
	end
	
	if conf.inject_isp_header ~= nil then
    kong.service.request.set_header(conf.inject_isp_header, mapISP(country["asnum"]) )
  end
	-- BLOCK IP IF MATCH RULES
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
      end 	
    end
	elseif ( conf.mode == "Whitelist" and conf.whitelist_countries == nil ) then
    block = 1
  end
  	
  if block == 1 then
    kong.response.exit(403, "Access not available in your country : " .. country["country_name"])
  end
end

function mapISP(asnum)
-- https://ipinfo.io/countries/vn
  isp = {
  ["FPT"] = { "AS18403", "AS45894", "AS131402" },
  ["VNPT"] = {"AS45899","AS7643","AS135939","AS135965","AS45898"},
  ["VIETTEL"] = { "AS7552", "AS24086" },
	["SPT"] = { "AS7602" },
}

for isp_name,table in pairs(isp) do 
  if contains(table, asnum) then
    return isp_name
  end	
end
-- IF ISP NOT FOUND, RETURN DEFAULT VALUE
return "other"
end

function contains(list, asn_string)
  for _,v in ipairs(list) do
    if string.match(asn_string, v) then return true end 
  end
return false
end

plugin.PRIORITY = 1994

return plugin
