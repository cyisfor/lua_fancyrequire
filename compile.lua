local path = require('pl.path')

local myexecute = function(command)
    print('> '..command)
    return os.execute(command)
end

function needUpdate(target,source)
    tattr = path.getmtime(target)
    if not tattr then return true end
    sattr = path.getmtime(source)
    -- this is for intermediate dependencies, which may have gotten deleted.
    if not sattr then return false end
    if sattr > tattr then return true end
    return false
end

local function compilerequire(name, options)
    dest = name .. ".so"

    source = (options and options.source) or name .. ".c"
    object = (options and options.object) or source .. ".o"

    if needUpdate(dest,object) or needUpdate(dest,source) then
        local cargs = ''
        local largs = ''
        if options then
            if options.cargs then
                cargs = options.cargs
            end
            if options.largs then
                largs = options.largs
            end
        end
        assert(0==myexecute("gcc -O2 -fPIC -I/usr/include/luajit-2.0 -c "..source.." -o "..object.." "..cargs))
        assert(0==myexecute("gcc -shared -o "..dest.." "..object.." "..largs))
    end

    return require(name)
end

return compilerequire
