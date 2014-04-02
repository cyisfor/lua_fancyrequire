if not table.clone then
    function table.clone(self) 
        other = {}
        for n,v in pairs(self) do
            other[n] = v
        end
        return other
    end
end

return function (name,exportNames,globals)
    globals = globals or _G
    local savedglobals = table.clone(globals)
    _G = globals
    local ok,result = pcall(require,name)
    _G = savedglobals
    local exports = nil
    if ok and exportNames then
        if type(exportNames)=='string' then
            exports = globals[exportNames]
        else
            exports = {}
            exports.result = result
            for _,n in ipairs(exportNames) do
                exports[n] = globals[n]
            end
        end
    end
    for n,v in pairs(savedglobals) do
        globals[n] = v
    end
    assert(ok,result)
    return exports or result
end
