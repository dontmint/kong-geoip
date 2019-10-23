return {
    {
      name = "2018-05-30-init",
      up = function(_, _, factory)
        local plugins, err = factory.plugins:find_all {name = "geoip"}
        if err then
          return err
        end
  
        for _, plugin in ipairs(plugins) do
          plugin.config._whitelist_cache = nil
          plugin.config._blacklist_cache = nil
          local _, err = factory.plugins:update(plugin, plugin, {full = true})
          if err then
            return err
          end
        end
      end,
      down = function()
        -- Do nothing
      end
    }
  }