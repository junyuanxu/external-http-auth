local BasePlugin = require "kong.plugins.base_plugin"
local http = require "resty.http"

local ExternalAuthHandler = BasePlugin:extend()

function ExternalAuthHandler:new()
  ExternalAuthHandler.super.new(self, "external-http-auth")
end

function ExternalAuthHandler:access(conf)
  ExternalAuthHandler.super.access(self)

  local client = http.new()
  client:set_timeouts(conf.connect_timeout, send_timeout, read_timeout)
    kong.log("conf.url===="+conf.url)
    kong.log("kong.request.get_path()===="+kong.request.get_path())
    kong.log("kong.request.get_raw_query()===="+kong.request.get_raw_query())
    kong.log("kong.request.get_headers()===="+kong.request.get_headers())

  local res, err = client:request_uri(conf.url, {
    method = "post",
    path = kong.request.get_path(),
    query = kong.request.get_raw_query(),
    headers = kong.request.get_headers(),
    body = ""
  })

  if not res then
     kong.log.err("not res ====== ")
     kong.log.err(err)
     return kong.response.exit(500, { message = "http auth fail error" })
  end

   if err then
          kong.log.err("err ====== ")
          kong.log.err(err)
          return kong.response.exit(500, { message = "An unexpected error occurred err " })
   end
end

ExternalAuthHandler.PRIORITY = 900

return ExternalAuthHandler
