-- BigBrainTime v2.0.0
-- SmoothSpatula

log.info("Successfully loaded ".._ENV["!guid"]..".")

mods["RoRRModdingToolkit-RoRR_Modding_Toolkit"].auto()

local initialize = function()
    -- Duplicate ingame sprite, draw to surface with scale, save to new sprite, delete first sprite
    local scaling = 2
    local sprite = gm.sprite_duplicate(gm.constants.sBrain)
    local sprite_width, sprite_height = gm.sprite_get_width(sprite)*scaling, gm.sprite_get_height(sprite)*scaling
    local surface = gm.surface_create(sprite_width, sprite_height) 

    gm.surface_set_target(surface)
    gm.draw_sprite_ext(sprite,1,sprite_width/2, sprite_height/2,scaling,scaling,0,16777215,1)
    local big_brain_sprite = gm.sprite_create_from_surface(surface, 0, 0, sprite_width, sprite_height, true, false, sprite_width/2, sprite_height/2)
    gm.surface_reset_target()
    gm.surface_free(surface)
    gm.sprite_delete(sprite)

    -- Set values (no localization)
    local Brain = Equipment.find("ror", "rottenBrain")
    Brain:set_sprite(big_brain_sprite)
end

if hot_reloading then
    initialize()
else 
    Initialize(initialize)
end
hot_reloading = true

-- Set size and position of Brain Effect on creation
gm.post_script_hook(gm.constants.instance_create, function(self, other, result, args)
    if result ~= nil and (result.value.object_name == "oEfBrain") then
        result.value.image_xscale, result.value.image_yscale, result.value.y = 3.0, 3.0, result.value.y -40 -- 
    end
end)

-- Set damage and range of explosion
gm.pre_script_hook(gm.constants.fire_explosion, function(self, other, result, args) -- scale 
    if other.object_name == "oEfBrain" then 
        args[4].value, args[8].value, args[9].value  = 20, 2, 2.5 -- damage multiplier, width, height
    end
end)
