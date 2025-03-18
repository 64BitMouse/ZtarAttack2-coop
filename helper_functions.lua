function switch(param, case_table)
    local case = case_table[param]
    if case then return case() end
    local def = case_table['default']
    return def and def() or nil
end

--- Moves Mario to the top of the object, then sets his Y speed and resets his fall.
---@param m MarioState
---@param obj Object
---@param vel_y integer
function bounce_off_object(m, obj, vel_y)
    m.pos.y = obj.oPosY + obj.hitboxHeight
    m.vel.y = vel_y

    -- MARIO_UNKNOWN_8 is the flag that controls Mario's screaming when he falls from a high place
    -- This removes the flag so he can scream again
    m.flags = m.flags & ~MARIO_UNKNOWN_08

    play_sound(SOUND_ACTION_BOUNCE_OFF_OBJECT, m.marioObj.header.gfx.cameraToObject)
end

---@param goal integer
---@param src integer
---@param inc integer
function approach_by_increment(goal, src, inc)
    new_val = 0

    if (src <= goal) then
        if (goal - src < inc) then
            new_val = goal
        else
            new_val = src + inc
        end
    elseif (goal - src > -inc) then
        new_val = goal
    else
        new_val = src - inc
    end

    return new_val
end