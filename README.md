compile - require local .so extensions, automatically compiling them if they're uncompiled or out of date
download - require but request name from luarocks if it fails, then require again
safe - require that doesn't let modules smash the global namespace

to use install this rock then 
local compilerequire = require('fancyrequire.compile')
etc...

compile:

local result = require('cmodule') 
=> dies because no cmodule.so found

local result = compilerequire('cmodule')
gcc -fPIC ... -c -o cmodule.o cmodule.c
gcc -fPIC -shared -o cmodule.so cmodule.so
=> OK

download:

local assert = require('luassert') 
=> dies because luassert not installed.

local assert = downloadrequire('luassert')
installing luassert in /home/.../.luarocks/...
=> OK

safe:

lfs = 'linux from scratch'
local fs = require('lfs')
assert(lfs == 'linux from scratch')
=> fail! lfs sets the lfs global

lfs = 'linux from scratch'
local fs = saferequire('lfs','lfs')
assert(lfs=='linux from scratch')
fs.mkdir("success!")
