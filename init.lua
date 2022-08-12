local modpath = minetest.get_modpath("sound_api")

sound_api = dofile(modpath .. "/sound_api_core/init.lua")

local function override_sounds(name, def)
    if name and def and def._sound_def and def._sound_def.key then
        if sound_api[def._sound_def.key] then
            minetest.override_item(name, {
                sounds = sound_api[def._sound_def.key](def._sound_def.input)
            })
        else
            minetest.log("warning", "missing sound_api function for node _sound_def key: "..def._sound_def.key)
        end
    end
end

minetest.register_on_mods_loaded(function()
    for name, def in pairs(minetest.registered_nodes) do
        override_sounds(name, def)
    end

    local old_reg_node = minetest.register_node
    function minetest.register_node(name, def)
        override_sounds(name, def)
        old_reg_node(name, def)
    end
end)
