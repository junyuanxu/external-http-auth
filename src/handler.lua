local BasePlugin = require "kong.plugins.base_plugin"
local http = require "resty.http"
local http = require "socket.http"
local ltn12 = require "ltn12"
local cjson = require "cjson.safe"

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
    path = "",
    query = "",
    headers = kong.request.get_headers(),
    body = ""
  })


    local response_body = {}
    local res, code, response_headers = http.request{
      url = conf.url,
      method = "POST",
      headers = kong.request.get_headers(),
      sink = ltn12.sink.table(response_body),
    }
    if type(response_body) ~= "table" then
        return nil, "Unexpected response"
    end
      local resp = table.concat(response_body)
      kong.log.err("response body: ", resp)

    if code ~= 200 then
        return nil, resp
    end

  if not res then
     kong.log.err("not res ====== ",err)
     return kong.response.exit(500, { message = "http auth fail error" })
  end

   if err then
          kong.log.err("err ====== ",err)
          return kong.response.exit(500, { message = "An unexpected error occurred err " })
   end

end

ExternalAuthHandler.PRIORITY = 900

return ExternalAuthHandler
