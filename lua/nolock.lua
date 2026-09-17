_addon.name = 'nolock'
_addon.author = 'TypedDiff'
_addon.version = '0.9.0'
_addon.commands = { }

local addon_path = windower.addon_path:gsub('\\', '/')	
package.cpath = package.cpath .. ';' .. addon_path .. '/libs/?.dll'
require('memorylib')

local nolock = { };
nolock.pattern = '66FF81????????66C781????????0807C3'
nolock.pointer = memorylib.findPattern('FFXiMain.dll', nolock.pattern)
nolock.backup = 0

local function msg(s)
    local txt = '[NoLock] ' .. s;
    print(txt);
end

windower.register_event('load', function()
    if (nolock.pointer == 0) then
        msg('Failed to find required pointer.');
        return;
    end

    nolock.backup = memorylib.read(nolock.pointer, 7)
    memorylib.write(nolock.pointer, '90909090909090')
    msg('Function patched; should no longer be animation locked during engage/disengage');
end)

windower.register_event('unload', function()
    if (nolock.pointer ~= 0 and nolock.backup ~= 0) then
        memorylib.write(nolock.pointer, nolock.backup)
        msg('Orignal engage function restored.')
    end
end)