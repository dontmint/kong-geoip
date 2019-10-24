
local typedefs = require "kong.db.schema.typedefs"

return {
    name = "geoip",
    fields = {
        { config = {
            type = "record",
            fields = { 
              { whitelist_countries = { type = "array", elements = {type = "string" } }, },
              { blacklist_countries = { type = "array", elements = {type = "string" } }, },
              { mode = {
                  type = "string",
                  default = "Whitelist",
                  one_of = { "Whitelist", "Blacklist" },
              }, },
            },
          },
        },
    }
}
