local helpers = require "spec.helpers"

for _, strategy in helpers.each_strategy() do
  describe("Plugin: geoip (access)", function()
    local client
    local plugin
    local dao

    setup(function()
      local bp, _
      bp, _, dao = helpers.get_db_utils(strategy)

      local api1 = assert(dao.apis:insert { 
          name = "api-1", 
          hosts = { "test1.com" }, 
          upstream_url = "http://mockbin.com",
      })

      assert(dao.plugins:insert {
        api_id = api1.id,
        name = "geoip",
        config = {
          blacklist_countries = {'RU', 'UA'},
          whitelist_ips = {'212.120.189.11'}
        }
      })

      assert(helpers.start_kong {custom_plugins = "geoip"})
    end)

    teardown(function()
      helpers.stop_kong()
    end)

    before_each(function()
      client = helpers.proxy_client()
    end)

    after_each(function()
      if client then client:close() end
    end)
  end)
end