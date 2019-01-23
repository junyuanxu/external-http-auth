package = "external-http-auth"
version = "1.0-26"
supported_platforms = {"linux", "macosx"}
source = {
  url = "git://github.com/junyuanxu/external-http-auth",
  tag = "v26.0"
}
description = {
  summary = "Kong plugin to authenticate requests using http services.",
  license = "MIT",
  homepage = "",
  detailed = [[
      Kong plugin to authenticate requests using http services.
  ]]
}
dependencies = {
}
build = {
  type = "builtin",
  modules = {
    ["kong.plugins.external-http-auth.handler"] = "src/handler.lua",
    ["kong.plugins.external-http-auth.schema"] = "src/schema.lua"
  }
}
