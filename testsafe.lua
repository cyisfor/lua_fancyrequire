require('luarocks.loader')
local saferequire = require('safe')
local withTests = require('minitest')
local assert = require('luassert')

withTests(function (c)
    c:describe("saferequire",function(c)
        c:it("global scramming",function(c)
            function importantThing()
                return 42
            end
            require('testsafe2')
            assert(23==importantThing())

            package.loaded['testsafe2'] = nil

            function importantThing()
                return 42
            end
            local derp = saferequire('testsafe2','importantThing')
            assert(42==importantThing())
            assert(23==derp())
        end)
    end)
end)
