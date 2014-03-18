local lfs = require('lfs')

local myexecute = function(command)
    print('> '..command)
    return os.execute(command)
end

function needUpdate(target,source)
    tattr = lfs.attributes(target,'modification')
    if not tattr then return true end
    sattr = lfs.attributes(source,'modification')
    -- this is for intermediate dependencies, which may have gotten deleted.
    if not sattr then return false end
    if sattr > tattr then return true end
    return false
end

local function compilerequire(name, options)
    dest = name .. ".so"

    source = (options and options.source) or name .. ".c"
    object = name..".o"

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
        assert(0==myexecute("gcc -shared -o "..dest.." "..name..".o "..largs))
    end

    return require(name)
end

return compilerequire
