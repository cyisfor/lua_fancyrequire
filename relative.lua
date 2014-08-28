local path = require('pl.path')

table.insert(package.loaders,1,function(name)
    -- parent...require...thisfunction
    local parent = debug.getinfo(3,'S')
    if not parent then return "No relative imports from non-files" end
    local location = path.join(path.dirname(parent),name)
    local src = location..'.lua'
    if path.isfile(src) then
        return function()
            return dofile(src)
        end
    end
    src = location..'.so'
    if path.isfile(src) then
        return function()
            return package.loadlib(src,'luaopen_'..name)
        end
    end
end)
