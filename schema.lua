
local typedefs = require "kong.db.schema.typedefs"

return {
    name = "geoip",
    fields = {
        { config = {
            type = "record",
            fields = { 
              { inject_country_header = { type = "string" }, },
	      { inject_isp_header = { type = "string" }, },
              { whitelist_countries = { type = "array", elements = {type = "string" } }, },
              { blacklist_countries = { type = "array", elements = {type = "string" } }, },
              { mode = {
                  type = "string",
                  default = "Blacklist",
                  one_of = { "Whitelist", "Blacklist" },
              }, },
            },
          },
        },
    }
}
