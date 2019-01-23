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
    kong.log.err("conf.url==== ",conf.url)
    kong.log.err("kong.request.get_path()==== ",kong.request.get_path())
    kong.log.err("kong.request.get_raw_query()==== ",kong.request.get_raw_query())
    kong.log.err("kong.request.get_headers()==== ",kong.request.get_headers())

  local res, err = client:request_uri(conf.url, {
    method = "post",
    path = kong.request.get_path(),
    query = kong.request.get_raw_query(),
    headers = kong.request.get_headers(),
    body = ""
  })
    local body = res.body
    kong.log.err("res.body==== ",body)
    kong.log.err("typebody==== ",type(body))
    kong.log.err("typeres.body==== ",type(res.body))
    for key, val in pairs(res.body) do
        if type(val) == "table" then
            kong.log.err("table:"..key, ": ", table.concat(val, ", "))
        else
            kong.log.err("one:"..key, ": ", val)
        end
    end


  if not res then
     kong.log.err("not res ====== ",err)
     return kong.response.exit(500, { message = "http auth fail error" })
  end

   if err then
          kong.log.err("err ====== ",err)
          return kong.response.exit(500, { message = "An unexpected error occurred err " })
   end

   if res.status == 200 then
          return kong.response.exit(500, res.body)
   end
end

ExternalAuthHandler.PRIORITY = 900

return ExternalAuthHandler
