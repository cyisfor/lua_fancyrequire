local path = require('pl.path')
local posix = require('posix')

local modules = {}

table.insert(package.loaders,1,function(name)
    -- parent...require...thisfunction
    local parent = debug.getinfo(3,'S')
    if not parent then return "No relative imports from non-files" end
    parent = parent.short_src
    while true do
        local link = posix.readlink(parent)
        if not link then break end
        parent = path.relpath(path.abspath(link,path.dirname(parent)))
    end
    local location = path.dirname(parent)
    for sub in name:gmatch('[^%.]+') do
        location = path.join(location,sub)
    end
    local src = location..'.lua'
    if modules[src] then
        return function()
            return modules[src]
        end
    end
    if path.isfile(src) then
        -- print('found relative source',src)
        return function()
            modules[src] = dofile(src)
            return modules[src]
        end
    end
    src = location..'.so'
    if path.isfile(src) then
        --print('found relative lib',src)
        return function()
            modules[src] = package.loadlib(src,'luaopen_'..name)()
            return modules[src]
        end
    end
end)
