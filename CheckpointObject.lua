----------
--models--
----------
local E_MODEL_CHECKPOINT = smlua_model_util_get_id("za2_checkpoint_geo")

----------
--sounds--
----------

--- @param obj Object
function obj_set_hitbox(obj, hitbox)
    if obj == nil or hitbox == nil then return end
    if (obj.oFlags & OBJ_FLAG_30) == 0 then
        obj.oFlags = obj.oFlags | OBJ_FLAG_30

        obj.oInteractType = hitbox.interactType
        obj.oDamageOrCoinValue = hitbox.damageOrCoinValue
        obj.oHealth = hitbox.health
        obj.oNumLootCoins = hitbox.numLootCoins

        cur_obj_become_tangible()
    end

    obj.hitboxRadius = obj.header.gfx.scale.x * hitbox.radius
    obj.hitboxHeight = obj.header.gfx.scale.y * hitbox.height
    obj.hurtboxRadius = obj.header.gfx.scale.x * hitbox.hurtboxRadius
    obj.hurtboxHeight = obj.header.gfx.scale.y * hitbox.hurtboxHeight
    obj.hitboxDownOffset = obj.header.gfx.scale.y * hitbox.downOffset
end

local function bhv_checkpoint_init(o)
    o.oFlags = OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE
    --obj_set_hitbox(o, sCollectPurpleCoinHitbox)
    obj_set_model_extended(o, E_MODEL_CHECKPOINT)
    obj_scale(o, 1)

    o.oWallHitboxRadius = 40
    o.oGravity = 2
    o.oBounciness = -0.75
    o.oDragStrength = 0
    o.oFriction = 0.5
    o.oBuoyancy = -2

    o.hitboxRadius = 100
    o.hitboxHeight = 100

    network_init_object(o, true, nil)

    local m = nearest_mario_state_to_object(o)

    o.oMoveAngleYaw = m.faceAngle.y
    o.oForwardVel = m.forwardVel*0.75
    o.oVelY = math.max(m.vel.y, 30)
end

local function bhv_checkpoint_loop(o)
    object_step()
    local floor = cur_obj_update_floor_height_and_get_floor()

    if floor ~= nil and o.oPosY ~= floor.upperY then
        spawn_non_sync_object(id_bhvSparkleSpawn, E_MODEL_SPARKLES, o.oPosX, o.oPosY, o.oPosZ, nil)
    end
end

id_bhvCheckpoint = hook_behavior(nil, OBJ_LIST_LEVEL, false, bhv_checkpoint_init, bhv_checkpoint_loop, "bhvCheckpoint")

local CHECKPOINT = audio_sample_load("SMW_Checkpoint.ogg")

local function on_interact(m, o, type)
    if type == INTERACT_STAR_OR_KEY and get_id_from_behavior(o.behavior) ~= id_bhvBowserKey then
        audio_sample_play(CHECKPOINT, m.pos, 5)
        spawn_sync_object(id_bhvCheckpoint, E_MODEL_CHECKPOINT, m.pos.x, m.pos.y, m.pos.z, bhv_checkpoint_init)
    end
end

hook_event(HOOK_ON_INTERACT, on_interact)