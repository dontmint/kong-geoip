local schemas_validation = require "kong.dao.schemas_validation"
local schema             = require "kong.plugins.geoip.schema"


local v = schemas_validation.validate_entity


describe("Plugin: whitelist_ips (schema)", function()
  it("should accept a valid whitelist", function()
    assert(v({whitelist_ips = {"127.0.0.1", "127.0.0.2"}}, schema))
  end)
  it("should accept a valid blacklist_countries", function()
    assert(v({blacklist_countries = {"RU", "UA"}}, schema))
  end)

  describe("errors", function()
    it("whitelist_ips should not accept invalid types", function()
      local ok, err = v({whitelist_ips = 12}, schema)
      assert.False(ok)
      assert.same({whitelist_ips = "whitelist_ips is not an array"}, err)
    end)
    it("whitelist should not accept invalid IPs", function()
      local ok, err = v({whitelist_ips = "hello"}, schema)
      assert.False(ok)
      assert.same({whitelist_ips = "cannot parse 'hello': Invalid IP"}, err)

      ok, err = v({whitelist_ips = {"127.0.0.1", "127.0.0.2", "hello"}}, schema)
      assert.False(ok)
      assert.same({whitelist_ips = "cannot parse 'hello': Invalid IP"}, err)
    end)
    it("blacklist_countries should not accept invalid types", function()
      local ok, err = v({blacklist_countries = 12}, schema)
      assert.False(ok)
      assert.same({blacklist_countries = "blacklist_countries is not an array"}, err)
    end)
    it("should not accept both empty whitelist_ips and blacklist", function()
      local t = {blacklist_countries = {}, whitelist_ips = {}}
      local ok, err, self_err = v(t, schema)
      assert.False(ok)
      assert.is_nil(err)
      assert.equal("you must set at least a whitelist_ips or blacklist_countries", self_err.message)
    end)
  end)
end)