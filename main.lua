-- BigBrainTime v1.0.0
-- SmoothSpatula

log.info("Successfully loaded ".._ENV["!guid"]..".")

hooks = {}
hooks["gml_Object_oStartMenu_Step_2"] = function() -- Init
    hooks["gml_Object_oStartMenu_Step_2"] = nil
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
    gm.object_set_sprite_w(gm.constants.oBrain, big_brain_sprite)
    local equipment = gm.variable_global_get("class_equipment")
    for i=1, #equipment do
        if equipment[i][2] == "rottenBrain" then
            gm.array_set(equipment[i], 7, big_brain_sprite)
            gm.array_set(equipment[i], 2, "It's Big Brain Time")
            gm.array_set(equipment[i], 3, "Big Brain")
        end
    end
end

gm.pre_code_execute(function(self, other, code, result, flags)
    if hooks[code.name] then
        hooks[code.name](self)
    end
end)

-- Set size and position of Brain Effect on creation
gm.post_script_hook(gm.constants.instance_create, function(self, other, result, args)
    if result ~= nil and (result.value.object_name == "oEfBrain") then
        result.value.image_xscale, result.value.image_yscale, result.value.y = 3.0, 3.0, result.value.y -40 -- 
    end
end)

-- Set damage and range of explosion
gm.pre_script_hook(gm.constants.fire_explosion, function(self, other, result, args) -- scale 
    if other.object_name == "oEfBrain" then 
        args[4].value, args[8].value, args[9].value  = 18, 2, 2.5 -- damage multiplier, width, height
    end
end)
