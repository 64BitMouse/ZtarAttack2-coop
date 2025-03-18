purples = 0

sCollectPurpleCoinHitbox = {
    interactType      = INTERACT_COIN,
    downOffset        = 0,
    damageOrCoinValue = 0,
    health            = 0,
    numLootCoins      = 0,
    radius            = 60,
    height            = 60,
    hurtboxRadius     = 0,
    hurtboxHeight     = 0,
}

----------
--models--
----------
E_MODEL_PURPLE_COMET_STAR = smlua_model_util_get_id("purple_comet_star_geo")
E_MODEL_PURPLECOIN = smlua_model_util_get_id("purple_coin_geo")
E_MODEL_PURPLESPARKLES = smlua_model_util_get_id("purple_sparkles_geo")

----------
--sounds--
----------

SOUND_PURPLE_COIN = audio_sample_load("purple_coin.ogg")

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

function bhv_collect_purple_coin_init(o)
    o.oFlags = OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE
    obj_set_hitbox(o, sCollectPurpleCoinHitbox)
    obj_set_model_extended(o, E_MODEL_PURPLECOIN)
    obj_scale(o, 1.25)
end

function bhv_collect_purple_coin_loop(o)
    local oPos = {}
    oPos.x = o.oPosX
    oPos.y = o.oPosY
    oPos.z = o.oPosZ

    o.oFaceAngleYaw = o.oFaceAngleYaw + 0x800
    if (o.oInteractStatus & INT_STATUS_INTERACTED) ~= 0 then
        obj_mark_for_deletion(o)
        spawn_sync_object(id_bhvSparkle, E_MODEL_PURPLESPARKLES, o.oPosX, o.oPosY, o.oPosZ, bhv_collect_purple_coin_loop)
        audio_sample_play(SOUND_PURPLE_COIN, oPos, 2.5)
        purples = purples + 1
        o.oInteractStatus = 0
    end
end

  

function reset()
    if obj_count_objects_with_behavior_id(id_bhvPurpleCoin) == 0 then
        purples = 0
    end
end

function display_coins()
    local x = 10
    local y = 42
    local purples = count_objects_with_behavior(get_behavior_from_id(id_bhvPurpleCoin))
    if gNetworkPlayers[0].currLevelNum == LEVEL_WMOTR then
        djui_hud_set_resolution(RESOLUTION_N64)
        djui_hud_set_font(FONT_HUD)
        djui_hud_render_texture(get_texture_info("purplecoinhud"), x, y, 0.8, 0.8)
        djui_hud_print_text(100 - purples.. "/100", x + 16 , y + 12, 0.8)
       
    end
end

---@param obj Object
local function set_model_on_is_star_collected(obj)
    local star_id = obj.oBehParams >> 24 -- 1st byte
    local course_star_flags = save_file_get_star_flags(get_current_save_file_num() - 1,
        gNetworkPlayers[0].currCourseNum - 1)
    local model = course_star_flags & (1 << star_id) ~= 0 and E_MODEL_TRANSPARENT_STAR or E_MODEL_PURPLE_COMET_STAR
    obj_set_model_extended(obj, model)
end

---@param obj Object
local function bhv_purple_coin_star_init(obj)
    bhv_init_room()
    obj.oHiddenStarTriggerCounter = obj_count_objects_with_behavior_id(id_bhvPurpleCoin)
end

---@param obj Object
local function bhv_purple_coin_star_loop(obj)
    if obj.oAction == 0 then
        if obj_count_objects_with_behavior_id(id_bhvPurpleCoin) == 0 then
            local star = spawn_red_coin_cutscene_star(obj.oPosX, obj.oPosY, obj.oPosZ)
            if star then
                star.oBehParams = obj.oBehParams
            end
            obj.oAction = 1
        end
    end
end

function purplecoinstar()
    local purple_coin_star_spawner = obj_get_nearest_object_with_behavior_id(gMarioStates[0].marioObj, id_bhvPurpleCoinStar)
    local purple_coin_spawner_star = obj_get_nearest_object_with_behavior_id(gMarioStates[0].marioObj, id_bhvStarSpawnCoordinates)
    if purple_coin_star_spawner and purple_coin_spawner_star and purple_coin_star_spawner.oBehParams2ndByte == purple_coin_spawner_star.oBehParams2ndByte then
    
        set_model_on_is_star_collected(purple_coin_spawner_star)
    end
end

id_bhvPurpleCoinStar = hook_behavior(nil, OBJ_LIST_LEVEL, false, bhv_purple_coin_star_init, bhv_purple_coin_star_loop,
    "bhvPurpleCoinStar")


id_bhvPurpleCoin = hook_behavior(id_bhvPurpleCoin, OBJ_LIST_LEVEL, false, bhv_collect_purple_coin_init,
    bhv_collect_purple_coin_loop)

hook_event(HOOK_ON_HUD_RENDER_BEHIND, display_coins)
hook_event(HOOK_ON_LEVEL_INIT, reset)
hook_event(HOOK_UPDATE, purplecoinstar)