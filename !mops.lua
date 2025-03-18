---@diagnostic disable: assign-type-mismatch, param-type-mismatch
----------------
-----Models-----
----------------

local E_MODEL_FLIPSWAP_PLATFORM = smlua_model_util_get_id("Flipswap_Platform_MOP")
local E_MODEL_FLIPSWAP_PLATFORM_BORDER = smlua_model_util_get_id("Flipswap_Platform_Border_MOP")
local E_MODEL_NOTEBLOCK = smlua_model_util_get_id("Noteblock_MOP")
local E_MODEL_SANDBLOCK = smlua_model_util_get_id("SandBlock_MOP")
local E_MODEL_SHRINK_PLATFORM = smlua_model_util_get_id("Shrink_Platform_MOP")
local E_MODEL_SHRINK_PLATFORM_BORDER = smlua_model_util_get_id("Shrink_Platform_Border_MOP")
local E_MODEL_SWITCHBLOCK = smlua_model_util_get_id("Switchblock_MOP")
local E_MODEL_SWITCHBLOCK_SWITCH = smlua_model_util_get_id("Switchblock_Switch_MOP")
local E_MODEL_SPRING = smlua_model_util_get_id("Spring_MOP")
local E_MODEL_GREEN_SWITCHBOARD = smlua_model_util_get_id("Green_Switchboard_MOP")
local E_MODEL_GREEN_SWITCHBOARD_GEARS = smlua_model_util_get_id("Green_Switchboard_Gears_MOP")
local E_MODEL_MOVING_ROTATING_PLATFORM = smlua_model_util_get_id("Moving_Rotating_Block_MOP")
local E_MODEL_BLARGG = smlua_model_util_get_id("blargg_geo")
local E_MODEL_FRIENDLY_BLARGG = smlua_model_util_get_id("friendly_blargg_geo")

--------------------
-----Collisions-----
--------------------

local COL_NOTEBLOCK_MOP = smlua_collision_util_get("col_Noteblock_MOP_0xaa6444")
local COL_SANDBLOCK_MOP = smlua_collision_util_get("col_Sandblock_MOP_0xaa6444")
local COL_FLIPSWAP_PLATFORM_MOP = smlua_collision_util_get("col_Flipswap_Platform_MOP_0x7d9d88")
local COL_GREEN_SWITCHBOARD_MOP = smlua_collision_util_get("col_Green_Switchboard_MOP_0x7ddc38")
local COL_SHRINK_PLATFORM = smlua_collision_util_get("col_Shrink_Platform_MOP_0xad3720")
local COL_SWITCHBLOCK_MOP = smlua_collision_util_get("col_Switchblock_MOP_0x7d3058")
local COL_SWITCHBLOCK_SWITCH_MOP = smlua_collision_util_get("col_Switchblock_Switch_MOP_0x7d7348")
local COL_MOVING_ROTATING_BLOCK_MOP = smlua_collision_util_get("col_Moving_Rotating_Block_MOP_0x7e3ea0")

-----------------
-----Actions-----
-----------------

local SPRING_ACT_IDLE = 0
local SPRING_ACT_INACTIVE = 1

local NOTEBLOCK_ACT_IDLE = 0
local NOTEBLOCK_ACT_BOUNCE = 1

local SANDBLOCK_ACT_IDLE = 0
local SANDBLOCK_ACT_DISAPPEARING = 1
local SANDBLOCK_ACT_DISAPPEARED = 2

local FLIPSWAP_PLATFORM_ACT_IDLE = 0
local FLIPSWAP_PLATFORM_ACT_FLIPPING = 1

local GREEN_SWITCHBOARD_ACT_IDLE = 0
local GREEN_SWITCHBOARD_ACT_MOVING = 1

local SHRINK_PLATFORM_ACT_IDLE = 0
local SHRINK_PLATFORM_ACT_DISAPPEARING = 1
local SHRINK_PLATFORM_ACT_DISAPPEARED = 2

local SWITCHBLOCK_ACT_ACTIVE = 0
local SWITCHBLOCK_ACT_INACTIVE = 1

-----------------------------
-----Localized Functions-----
-----------------------------

local play_sound = play_sound
local spawn_non_sync_object = spawn_non_sync_object
local obj_copy_pos_and_angle = obj_copy_pos_and_angle
local obj_set_model_extended = obj_set_model_extended
local obj_check_if_collided_with_object = obj_check_if_collided_with_object
local set_mario_action = set_mario_action
local load_object_collision_model = load_object_collision_model
local cur_obj_is_mario_on_platform = cur_obj_is_mario_on_platform
local spawn_mist_particles = spawn_mist_particles
local cur_obj_play_sound_1 = cur_obj_play_sound_1
local cur_obj_hide = cur_obj_hide
local cur_obj_unhide = cur_obj_unhide
local nearest_mario_state_to_object = nearest_mario_state_to_object
local coss = coss
local sins = sins
local obj_copy_pos = obj_copy_pos
local math_abs = math.abs
local cur_obj_rotate_face_angle_using_vel = cur_obj_rotate_face_angle_using_vel
local cur_obj_move_using_vel = cur_obj_move_using_vel
local cur_obj_scale = cur_obj_scale

local string_pack = string.pack
local string_unpack = string.unpack
---@param value number
---@param pack_fmt string
---@param unpack_fmt string
local repack = function (value, pack_fmt, unpack_fmt)
    return string_unpack(unpack_fmt, string_pack(pack_fmt, value))
end

--------------------------
-----Helper Variables-----
--------------------------

local id_bhvFlipswap_Platform_Border_MOP = id_bhvUnused05A8
local id_bhvShrink_Platform_Border_MOP = id_bhvUnused05A8
local id_bhvGreen_Switchboard_Gears_MOP = id_bhvUnused05A8

--------------------------
-----Helper Functions-----
--------------------------

--- Moves Mario to the top of the object, then sets his Y speed and resets his fall.
---@param m MarioState
---@param obj Object
---@param vel_y integer
local function bounce_off_object(m, obj, vel_y)
    m.pos.y = obj.oPosY + obj.hitboxHeight
    m.vel.y = vel_y

    -- MARIO_UNKNOWN_8 is the flag that controls Mario's screaming when he falls from a high place
    -- This removes the flag so he can scream again
    m.flags = m.flags & ~MARIO_UNKNOWN_08

    play_sound(SOUND_ACTION_BOUNCE_OFF_OBJECT, m.marioObj.header.gfx.cameraToObject)
end

--- Gets closer to a goal value by the increment when ran
---@param goal integer
---@param src integer
---@param inc integer
local function approach_by_increment(goal, src, inc)
    local diff = goal - src
    if diff > inc then
        return src + inc
    elseif diff < -inc then
        return src - inc
    else
        return goal
    end
end

---@param m MarioState
---@return boolean
local function is_bubbled(m)
    if m.action == ACT_BUBBLED then
        return true
    end
    return false
end

---@param parent Object
---@param model ModelExtendedId
---@param behaviorId BehaviorId
local function spawn_object_attached_to_parent(parent, model, behaviorId)
    local obj = spawn_non_sync_object(behaviorId, model, 0, 0, 0, nil)
    if not obj then return nil end

    obj_copy_pos_and_angle(obj, parent)
    return obj
end

---@param num number
---@return number
local function convert_s16(num)
    num = num & 0xFFFF
    return ((num >= 0x7FFF) and (num - 0x10000) or num)
end

---@param start_point number
---@param end_point number
---@param time number
---@return number
local function lerp(start_point, end_point, time)
    return start_point * (1 - time) + end_point * time
end

-------------------
-----Functions-----
-------------------

------ Spring ------
-- Upon touching the spring, get launched in a set direction with a set speed, both horizontal and vertical.

---@param obj Object
function bhv_Spring_init(obj)
    obj.oFlags = OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE
    obj.hitboxRadius = 160
    obj.hitboxHeight = 160
    obj.oInteractType = INTERACT_COIN
    obj.oIntangibleTimer = 0
end

---@param obj Object
function bhv_Spring_loop(obj)
    obj_set_model_extended(obj, E_MODEL_SPRING)

    local m = gMarioStates[0]
    if is_bubbled(m) then return end

    local Yspd = 56.0
    local y_vel = nil
    local forward_vel = nil

    if obj.oAction == SPRING_ACT_IDLE then
        if obj_check_if_collided_with_object(obj, m.marioObj) ~= 0 then
            set_mario_action(m, ACT_DOUBLE_JUMP, 0)
            -- m.actionTimer = 1000 --Really doubt this is necessary
            m.faceAngle.y = obj.oFaceAngleYaw

            y_vel = repack(Yspd, "f", "I")
            -- Calculates how fast Mario should go using oBehParams2ndByte
            forward_vel = repack(y_vel + (obj.oBehParams & 0x00FF0000), "I", "f")
            m.forwardVel = forward_vel

            -- Calculates how high Mario should go using the 1st byte
            y_vel = y_vel + (((obj.oBehParams >> 24) & 0xFF) << 16)
            bounce_off_object(m, obj, repack(y_vel, "I", "f"))

            -- Prevent interaction for some time
            obj.oAction = SPRING_ACT_INACTIVE
        end
    else
        -- Prevent interaction until half a second later
        if obj.oTimer == 15 then
            obj.oAction = SPRING_ACT_IDLE
        end
    end
end

id_bhvSpring_MOP = hook_behavior(nil, OBJ_LIST_LEVEL, false, bhv_Spring_init, bhv_Spring_loop, "bhvSpring_MOP")

------ Noteblock ------
-- Jumping onto this block will cause Mario to jump higher.

---@param obj Object
function bhv_noteblock_init(obj)
    obj.oFlags = OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE
    obj.collisionData = COL_NOTEBLOCK_MOP
    obj.oHomeX = obj.oPosX
    obj.oHomeY = obj.oPosY
    obj.oHomeZ = obj.oPosZ

    -- I guess it's slightly larger than intended
    cur_obj_scale(0.64)
end

---@param obj Object
function bhv_noteblock_loop(obj)
    obj_set_model_extended(obj, E_MODEL_NOTEBLOCK)

    load_object_collision_model()

    local m = gMarioStates[0]
    local y_spd = 64

    if cur_obj_is_mario_on_platform() == 1 and not is_bubbled(m) then
         --this is awful -- It really is -Sunk
        -- Jump. If A is pressed during the jump, increase y_spd.
        if m.controller.buttonPressed & A_BUTTON ~= 0 then
            y_spd = y_spd + 12
            spawn_mist_particles()
        end
        set_mario_action(m, ACT_DOUBLE_JUMP, 0)

        -- Calculates y speed
        calc_speed = repack(y_spd, "f", "I")
		calc_speed = calc_speed + (obj.oBehParams2ndByte << 16)
		y_spd = repack(calc_speed, "I", "f")
		m.vel.y = y_spd

        obj.oAction = NOTEBLOCK_ACT_BOUNCE
        -- do_fall_damage = true
    end

    if obj.oAction == NOTEBLOCK_ACT_BOUNCE then
        if obj.oTimer == 4 then
            obj.oAction = NOTEBLOCK_ACT_IDLE
            obj.oPosY = obj.oHomeY
        else
            -- Moves the noteblock slightly up and down, to give it a "bounce"
            if obj.oTimer > 2 then
                obj.oPosY = obj.oHomeY + (obj.oTimer % 3) * 6
            else
                obj.oPosY = obj.oHomeY - obj.oTimer * 6
            end
        end
    end
end

id_bhvNoteblock_MOP = hook_behavior(nil, OBJ_LIST_SURFACE, false, bhv_noteblock_init, bhv_noteblock_loop, "bhvNoteblock_MOP")

------ Sandblock ------
-- Standing on this block causes it to slowly fall to pieces, eventually no longer becoming a platform.

---@param obj Object
function bhv_sandblock_init(obj)
    obj.oFlags = OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE
    obj.collisionData = COL_SANDBLOCK_MOP
    obj.oHomeX = obj.oPosX
    obj.oHomeY = obj.oPosY
    obj.oHomeZ = obj.oPosZ
end

---@param obj Object
function bhv_sandblock_loop(obj)
    obj_set_model_extended(obj, E_MODEL_SANDBLOCK)

    -- Only activate collision if the sandblock has not disappeared
    if obj.oAction < SANDBLOCK_ACT_DISAPPEARED then
        load_object_collision_model()
    end
    -- Disappearing
    switch(obj.oAction, {
        [SANDBLOCK_ACT_DISAPPEARING] = function()
            if obj.oTimer == 300 then
                obj.oAction = SANDBLOCK_ACT_DISAPPEARED
            end
            -- Causes the sandblock to become smaller and smaller on the y axis
            obj.header.gfx.scale.y = ((300 - obj.oTimer) / 300.0)
            -- Makes the sandblock not move the player vertically as it's breaking
            obj.oPosY = obj.oPosY + 1.025

            -- Spawn effects
            spawn_non_sync_object(id_bhvDirtParticleSpawner, E_MODEL_NONE, obj.oPosX, obj.oPosY, obj.oPosZ, nil)
            cur_obj_play_sound_1(SOUND_ENV_MOVINGSAND)
        end,
        -- Respawns the block after it disappears
        [SANDBLOCK_ACT_DISAPPEARED] = function()
            cur_obj_hide()
            if obj.oTimer == 301 then
                obj.oPosY = obj.oHomeY
                obj.oAction = SANDBLOCK_ACT_IDLE
                obj.header.gfx.scale.y = 1.0
                cur_obj_unhide()
            end
        end
    })

    if cur_obj_is_mario_on_platform() == 1 and obj.oAction == SANDBLOCK_ACT_IDLE and not is_bubbled(gMarioStates[0]) then
        obj.oAction = SANDBLOCK_ACT_DISAPPEARING
    end
end

id_bhvSandBlock_MOP = hook_behavior(nil, OBJ_LIST_SURFACE, false, bhv_sandblock_init, bhv_sandblock_loop, "bhvSandBlock_MOP")

------ Flipswap platform ------
-- Jumping will cause this platform to spin, moving the land somewhere else.

local FLIP_SPEED_MULTIPLIER = 0.5

---@param obj Object
function bhv_flipswap_init(obj)
    obj.oFlags = OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE
    obj.oFaceAngleRoll = 0
    obj.collisionData = COL_FLIPSWAP_PLATFORM_MOP
    -- Spawns the border
    local childObj = spawn_non_sync_object(id_bhvFlipswap_Platform_Border_MOP, E_MODEL_FLIPSWAP_PLATFORM_BORDER, obj.oPosX, obj.oPosY, obj.oPosZ,
    ---@param o Object
    function (o)
        o.oFaceAngleYaw = obj.oFaceAngleYaw
    end)
    childObj.parentObj = obj
end

---@param obj Object
function bhv_flipswap_loop(obj)
    obj_set_model_extended(obj, E_MODEL_FLIPSWAP_PLATFORM)
    load_object_collision_model()

    local m = gMarioStates[0]

    switch(obj.oAction, {
        [FLIPSWAP_PLATFORM_ACT_IDLE] = function ()
            -- If Mario enters an air action, start flipping
            if m.prevAction & ACT_GROUP_MASK ~= ACT_GROUP_AIRBORNE and m.action & ACT_GROUP_MASK == ACT_GROUP_AIRBORNE then
                --sloth brain it
                if obj.oFaceAngleRoll == 0 then
                    obj.oMoveAngleRoll = -2048 * FLIP_SPEED_MULTIPLIER
                else
                    obj.oMoveAngleRoll = 2048 * FLIP_SPEED_MULTIPLIER
                end
                obj.oAction = FLIPSWAP_PLATFORM_ACT_FLIPPING
                -- Not syncing it so people can have their own platforms
            end
        end,
        [FLIPSWAP_PLATFORM_ACT_FLIPPING] = function ()
            -- Flip the platform
            if obj.oTimer < 16 * FLIP_SPEED_MULTIPLIER ^ -1 then
                obj.oFaceAngleRoll = obj.oFaceAngleRoll + obj.oMoveAngleRoll
            -- Disallow flipping again until Mario lands
            elseif m.action & ACT_GROUP_MASK ~= ACT_GROUP_AIRBORNE then
                obj.oAction = FLIPSWAP_PLATFORM_ACT_IDLE
            end
        end
    })
end

id_bhvFlipswap_Platform_MOP = hook_behavior(nil, OBJ_LIST_SURFACE, false, bhv_flipswap_init, bhv_flipswap_loop, "bhvFlipswap_Platform_MOP")

------ Green switchboard ------
-- The platform moves depending on where the player is on it. Similar to the rolling log.
-- ! Prone to desyncs

---@param obj Object
function bhv_green_switchboard_init(obj)
    obj.oFlags = OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE | OBJ_FLAG_MOVE_XZ_USING_FVEL
    obj.collisionData = COL_GREEN_SWITCHBOARD_MOP
    -- Spawns gears
    -- Don't know why it uses intro lakitu cloud
    obj.oIntroLakituCloud = spawn_object_attached_to_parent(obj, E_MODEL_GREEN_SWITCHBOARD_GEARS, id_bhvGreen_Switchboard_Gears_MOP)
    --cur_obj_set_home_once()
end

---@param obj Object
function bhv_green_switchboard_loop(obj)
    obj_set_model_extended(obj, E_MODEL_GREEN_SWITCHBOARD)

    load_object_collision_model()

    local MAX_SPEED = 20.0
    local SPEED_INC = 2.0
    local child = obj.oIntroLakituCloud
    local dot = 0
    local dotH = 0

    switch(obj.oAction, {
        [GREEN_SWITCHBOARD_ACT_MOVING] = function ()
            -- Hopefully makes sure the Mario the object is referencing is the Mario that's on
            local m = nearest_mario_state_to_object(obj)

            local dx = m.pos.x - obj.oPosX
            local dz = m.pos.z - obj.oPosZ
            local dHx = obj.oPosX - obj.oHomeX
            local dHz = obj.oPosZ - obj.oHomeZ
            local facingZ = coss(obj.oFaceAngleYaw)
            local facingX = sins(obj.oFaceAngleYaw)

            --if dot is positive, mario is on front arrow
            dot = facingZ * dz + facingX * dx
            dotH = facingZ * dHz + facingX * dHx

            if dot > 0 then
                -- 1st byte determines how far the switchboard can go forwards
                if dotH < ((obj.oBehParams >> 24) & 0xFF) * 16 then
                    obj.oForwardVel = approach_by_increment(MAX_SPEED, obj.oForwardVel, SPEED_INC)
                else
                    obj.oForwardVel = 0
                end
                obj.oFaceAnglePitch = approach_by_increment(2048.0, obj.oFaceAnglePitch, 128.0)
            else
                -- 2nd byte determines how far the switchboard can go backwards
                if dotH > obj.oBehParams2ndByte * -16 then
                    obj.oForwardVel = approach_by_increment(-MAX_SPEED, obj.oForwardVel, SPEED_INC)
                else
                    obj.oForwardVel = 0
                end
                --this function doesn't work well with negatives thanks nintendo
                if (obj.oFaceAnglePitch > -2048) then
                    obj.oFaceAnglePitch = approach_by_increment( -2048.0, obj.oFaceAnglePitch, 128.0)
                end
            end

            if m.marioObj.platform ~= obj then
                obj.oAction = GREEN_SWITCHBOARD_ACT_IDLE
            end
        end,
        [GREEN_SWITCHBOARD_ACT_IDLE] = function ()
            -- Slowly resets the pitch and speed back to 0
            obj.oForwardVel = approach_by_increment(0.0, obj.oForwardVel, SPEED_INC)
            obj.oFaceAnglePitch = approach_by_increment(0.0, obj.oFaceAnglePitch, 128.0)
        end
    })
    -- Moves the gears along with the platform
    child.oFaceAnglePitch = child.oFaceAnglePitch + (obj.oForwardVel * 200)
    obj_copy_pos(child, obj)

    -- Using actions to make syncing faster
    if cur_obj_is_mario_on_platform() == 1 and not is_bubbled(gMarioStates[0]) then
        obj.oAction = GREEN_SWITCHBOARD_ACT_MOVING
    end
end

id_bhvGreen_Switchboard_MOP = hook_behavior(nil, OBJ_LIST_SURFACE, false, bhv_green_switchboard_init, bhv_green_switchboard_loop, "bhvGreen_Switchboard_MOP")

------ Shrink platform ------
-- Upon being stood on, shrinks platform over time until it no longer exists.

local SHRINK_TIME = 150

---@param obj Object
function bhv_shrinkplatform_init(obj)
    obj.oFlags = OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE
    obj.collisionData = COL_SHRINK_PLATFORM
    -- Spawns border
    local childObj = spawn_non_sync_object(id_bhvShrink_Platform_Border_MOP, E_MODEL_SHRINK_PLATFORM_BORDER, obj.oPosX, obj.oPosY, obj.oPosZ, nil)
    childObj.parentObj = obj
end

---@param obj Object
function bhv_shrinkplatform_loop(obj)
    obj_set_model_extended(obj, E_MODEL_SHRINK_PLATFORM)

    -- Only activate collision if the model is still visible
    if obj.oAction < SHRINK_PLATFORM_ACT_DISAPPEARED then
        load_object_collision_model()
    end

    switch(obj.oAction, {
        --disappearing
        [SHRINK_PLATFORM_ACT_DISAPPEARING] = function()
            if obj.oTimer == SHRINK_TIME then
                obj.oAction = SHRINK_PLATFORM_ACT_DISAPPEARED
            end

            -- Slowly shrinks the size of the platform horizontally
            obj.header.gfx.scale.x = (SHRINK_TIME - obj.oTimer) / SHRINK_TIME
            obj.header.gfx.scale.z = (SHRINK_TIME - obj.oTimer) / SHRINK_TIME
        end,
        [SHRINK_PLATFORM_ACT_DISAPPEARED] = function()
            -- Reset after the platform has fully disappeared
            cur_obj_hide()
            if obj.oTimer == SHRINK_TIME + 1 then
                obj.oAction = SHRINK_PLATFORM_ACT_IDLE
                obj.header.gfx.scale.x = 1.0
                obj.header.gfx.scale.z = 1.0
                cur_obj_unhide()
            end
        end
    })

    -- Start disappearing once Mario gets on it
    if cur_obj_is_mario_on_platform() == 1 and obj.oAction == SHRINK_PLATFORM_ACT_IDLE and not is_bubbled(gMarioStates[0]) then
        obj.oAction = SHRINK_PLATFORM_ACT_DISAPPEARING
        cur_obj_play_sound_1(SOUND_OBJ_UNK23)
    end
end

id_bhvShrink_Platform_MOP = hook_behavior(nil, OBJ_LIST_SURFACE, false, bhv_shrinkplatform_init, bhv_shrinkplatform_loop, "bhvShrink_Platform_MOP")

------ Switchblock ------
-- This block is either red or blue. If the corresponding switch is pressed, activate blocks of one color and deactivate blocks of another color.
-- The color of each block and switch depends ont the 2nd byte.
-- 2nd byte of 0 spawns red 2nd byte of 2 spawns blue.
-- Anim state 0 is red, 1 is red deactivated, 2 is blue, 3 is blue deactivated.

gGlobalSyncTable.switchBlockState = 0

---@param obj Object
function bhv_Switchblock_init(obj)
    obj.oFlags = OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE
    obj.collisionData = COL_SWITCHBLOCK_MOP
end

---@param obj Object
function bhv_Switchblock_loop(obj)
    obj_set_model_extended(obj, E_MODEL_SWITCHBLOCK)

    -- Determines which block color this becomes
    local params_2nd_byte = obj.oBehParams2ndByte
    obj.oAnimState = params_2nd_byte + obj.oAction -- Changes anim states

    -- Only loads collision if the corresponding switch is pressed
    -- Switchblocks have a second byte of 0 and 2, while switches have a second byte of 0 and 1
    if gGlobalSyncTable.switchBlockState == params_2nd_byte * 0.5 then
        load_object_collision_model()
        obj.oAction = SWITCHBLOCK_ACT_ACTIVE
    else
        obj.oAction = SWITCHBLOCK_ACT_INACTIVE
    end
end

id_bhvSwitchblock_MOP = hook_behavior(nil, OBJ_LIST_SURFACE, false, bhv_Switchblock_init, bhv_Switchblock_loop, "bhvSwitchblock_MOP")

---@param obj Object
function bhv_Switchblock_Switch_init(obj)
    obj.oFlags = OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE
    obj.collisionData = COL_SWITCHBLOCK_SWITCH_MOP
end

local scalar_timer = 0

---@param obj Object
function bhv_Switchblock_Switch_loop(obj)
    obj_set_model_extended(obj, E_MODEL_SWITCHBLOCK_SWITCH)

    local params_2nd_byte = obj.oBehParams2ndByte
    load_object_collision_model()

    obj.oAnimState = params_2nd_byte
    if cur_obj_is_mario_on_platform() == 1 then
        gGlobalSyncTable.switchBlockState = params_2nd_byte
    end

    local scalar = 0
    if gGlobalSyncTable.switchBlockState ~= params_2nd_byte then
        scalar = 1
    end

    -- Uses to slowly raise and lower the switch
    scalar_timer = scalar_timer + 1
    if scalar_timer > 100 then
        scalar_timer = 100
    end

    local result = scalar * 0.9 + 0.1
    local current_scale = obj.header.gfx.scale.y

    -- Make smaller if the switch is pressed
    obj.header.gfx.scale.y = lerp(current_scale, result, scalar_timer * 0.01)
end

hook_on_sync_table_change(gGlobalSyncTable, "switchBlockState", "tag",
function (tag, oldVal, newVal)
    scalar_timer = 0
end)

id_bhvSwitchblock_Switch_MOP = hook_behavior(nil, OBJ_LIST_SURFACE, false, bhv_Switchblock_Switch_init, bhv_Switchblock_Switch_loop, "bhvSwitchblock_Switch_MOP")

------ Moving Rotating Block ------
-- Moves on a square path. Occationally flips.
-- ! Currently broken and I don't know why

local ZPLUS = 0
local ZMINUS = 1
local XPLUS = 2
local XMINUS = 3
local LOOP = 4

local MoveRotatePath1 = {
    ZPLUS,
    XPLUS,
    ZMINUS,
    XMINUS,
    LOOP
}

local MoveRotatePath2 = {
    ZPLUS,
    ZPLUS,
    ZPLUS,
    ZMINUS,
    ZMINUS,
    ZMINUS,
    LOOP
}

local MoveRotatePath3 = {
    XPLUS,
    XPLUS,
    XPLUS,
    XMINUS,
    XMINUS,
    XMINUS,
    LOOP
}

local Paths = {
    MoveRotatePath1,
    MoveRotatePath2,
    MoveRotatePath3
}

--speeds are 8 in each dir
--red is bparam1 =1, offset timer by 0x80 on frame 1
--rotates every 0x110 frames aka ~9s or 272 frames
--rotate for pitch vel of 0x0400 for 0x20 frames
--advanced forward a direction every 0x3C frames

---@param obj Object
function bhv_move_rotate_init(obj)
    obj.oFlags = OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE
    obj.collisionData = COL_MOVING_ROTATING_BLOCK_MOP
    -- Co-op always draws everything on screen
    obj.oDrawingDistance = 19455

    obj.oTimer = obj.oTimer + 0x80 * (obj.oBehParams >> 24)
	obj.oAnimState = (obj.oBehParams >> 24)
    obj.oUnk1A8 = 0
    -- Forces the default case
    obj.oUnk94 = 0
end

local PLAT_SPEED = 8
local PLAT_FLIP_START_TIMER = 0x110
local PLAT_FLIP_END_TIMER = 0x130
local PLAT_MOVEMENT_FRAMES = 0x3C

---@param obj Object
function bhv_move_rotate_loop(obj)
    load_object_collision_model()
    obj_set_model_extended(obj, E_MODEL_MOVING_ROTATING_PLATFORM)

    local direction = 0
    -- After a while, flip the platform
	if obj.oTimer >= PLAT_FLIP_START_TIMER and obj.oTimer <= PLAT_FLIP_END_TIMER then
		obj.oAngleVelPitch = 0x400
    else
		obj.oAngleVelPitch = 0
        obj.oTimer = obj.oTimer % PLAT_FLIP_END_TIMER + 1
        -- Forces the platform to have the correct pitches
        if obj.oFaceAnglePitch ~= 0 then
            if math_abs(obj.oFaceAnglePitch) <= math_abs(convert_s16(obj.oFaceAnglePitch + 32768)) then
                obj.oFaceAnglePitch = 0
            else
                obj.oFaceAnglePitch = 32768
            end
        end
    end
    -- Adding 1 since lua uses 1 index rather than c which uses 0 index
	direction = Paths[obj.oBehParams2ndByte + 1][obj.oUnk94 + 1] -- oUnk1A4 was replaced with oSyncDeath

	switch(direction, {
        [ZPLUS] = function ()
            obj.oUnk1A8 = obj.oUnk1A8 + 1
			obj.oVelZ = PLAT_SPEED
			obj.oVelX = 0
        end,
		[ZMINUS] = function ()
			obj.oUnk1A8 = obj.oUnk1A8 + 1
			obj.oVelZ = -PLAT_SPEED
			obj.oVelX = 0
        end,
		[XPLUS] = function ()
            obj.oUnk1A8 = obj.oUnk1A8 + 1
			obj.oVelX = PLAT_SPEED
			obj.oVelZ = 0
        end,
		[XMINUS] = function ()
            obj.oUnk1A8 = obj.oUnk1A8 + 1
			obj.oVelX = -PLAT_SPEED
			obj.oVelZ = 0
        end,
		["default"] = function ()
            obj.oUnk94 = 0
        end
	})

    -- After moving in a direction for a while, move in the next
	if obj.oUnk1A8 == PLAT_MOVEMENT_FRAMES then
		obj.oUnk94 = obj.oUnk94 + 1
		obj.oUnk1A8 = 0
    end

	cur_obj_rotate_face_angle_using_vel()
	cur_obj_move_using_vel()
end

id_bhvMoving_Rotating_Block_MOP = hook_behavior(nil, OBJ_LIST_SURFACE, false, bhv_move_rotate_init, bhv_move_rotate_loop, "bhvMoving_Rotating_Block_MOP")

-----------------
-----Emitter-----
-----------------

---@param obj Object
function bhv_emitter_init(obj)
    obj.oFlags = obj.oFlags | OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE | OBJ_FLAG_COMPUTE_DIST_TO_MARIO
    obj.oDrawingDistance = 5120
end

---@param obj Object
function bhv_emitter_loop(obj)
    if (obj.oBehParams >> 24) & 0xFF > obj.oDistanceToMario then
        spawn_object_attached_to_parent(obj, 0, id_bhvSparkleSpawn)
    end
end

id_bhvEmitter_MOP = hook_behavior(nil, OBJ_LIST_GENACTOR, false, bhv_emitter_init, bhv_emitter_loop, "bhvEmitter_MOP")

-- No known code for the jukebox nor is it that important
hook_behavior(nil, OBJ_LIST_UNIMPORTANT, false, function (obj) obj_mark_for_deletion(obj) end, nil, "bhvJukebox_MOP")