package="fancyrequire"
version="0.1-1"
source = {
    url="git@github.com:cyisfor/lua_fancyrequire.git"
}
description = {
   summary = "Fancy ways to require things",
   homepage = "http://github.com/cyisfor/lua_fancyrequire/",   
   detailed = [[
       download exports a function that acts like require, but when the module is not found it attempts to download it via luarocks.
       compile also exports a require, but when the module is a ".c" source file, it attempts to compile that file, creating a .so that may be required.
   ]]
}
dependencies = {
   "lua >= 5.1",
   "luafilesystem"
}

build = {
   type="builtin",
   modules = {
       ["fancyrequire.download"] = "download.lua",
       ["fancyrequire.compile"] = "compile.lua",
   }
}
