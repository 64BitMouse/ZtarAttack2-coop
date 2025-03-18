-- name: \\#0c33c2\\Ztar Attack \\#c20c0c\\2 \\#dcdcdc\\ v1.3
-- description: Mario must travel back in time to when the very first Ztar Attack began on the Mushroom Kingdom to stop it before it reaches the present (\\#0c33c2\\Ztar Attack \\#deb307\\1.5\\#ffffff\\). Collect the 91 Time Stars in this linear 2D platformer-styled adventure to rid the positive realm of the Ztars!\n\n Original Hack by TheGael95\n\n Port by \\#2d851c\\Mr.Needlemouse\\#ffffff\\\n\nKaze MOPs and other custom behaviors done by \\#de8ad1\\Sunk
-- incompatible: romhack




local first_run = true
local function mario_life_update()
    if first_run then
        gMarioStates[0].numLives = 10
        first_run = false
    end
end


---@param m MarioState
local function general_stuff_update(m)
    if m.playerIndex ~= 0 then return end
    ---@type NetworkPlayer
    local np = gNetworkPlayers[0]
    -- This hack is naturally nonstop like this, so this is required
    gServerSettings.stayInLevelAfterStar = 2
    -- However, some stars do indeed take you out of the level
    if np.currLevelNum == LEVEL_COTMC then
        local obj = obj_get_first_with_behavior_id(id_bhvKingBobomb)
        if obj and obj.oAction == 8 then
            gServerSettings.stayInLevelAfterStar = 0
        end
    elseif np.currLevelNum == LEVEL_VCUTM then
        local obj = obj_get_first_with_behavior_id(id_bhvWhompKingBoss)
        if obj and obj.oAction == 9 then
            gServerSettings.stayInLevelAfterStar = 0
        end
    elseif np.currLevelNum == LEVEL_TOTWC then
        local obj = obj_get_first_with_behavior_id(id_bhvGhostHuntBigBoo)
        if not obj then
            gServerSettings.stayInLevelAfterStar = 0
        end
    elseif np.currLevelNum == LEVEL_SA then
        local obj = obj_get_first_with_behavior_id(id_bhvKoopa)
        if obj and dist_between_objects(m.marioObj, obj) < 2000 then
            gServerSettings.stayInLevelAfterStar = 0
        end
    end

    -- Fixes pipe softlock
    local obj = obj_get_nearest_object_with_behavior_id(m.marioObj, id_bhvWarpPipe)
    if obj then
        if m.action == ACT_EMERGE_FROM_PIPE and m.actionTimer < 2 then
            m.pos.y = m.pos.y + 100
        end
    end

    -- Every 50 coins collected is an extra life
    if m.numCoins >= 50 then
        m.numCoins = m.numCoins - 50
        hud_set_value(HUD_DISPLAY_COINS, 0)
        spawn_non_sync_object(id_bhvHidden1upInPole, E_MODEL_1UP, m.pos.x, m.pos.y + 200, m.pos.z, nil)
    end
end



-- C13 spawns you in vertical wind, so the player needs control immediately
local function entered_c13()
    if gNetworkPlayers[0].currLevelNum == LEVEL_THI then
        set_mario_action(gMarioStates[0], ACT_FREEFALL, 0)
    end
end



-- Collecting the grand star warps the player to the wing cap switch
---@param obj Object
function bhv_custom_grand_star_init(obj)
    obj.oFlags = OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE
    obj.oInteractType = INTERACT_WARP
    obj.oIntangibleTimer = 0
    cur_obj_set_home_once()
end

---@param obj Object
function bhv_custom_grand_star_loop(obj)
    bhv_warp_loop()
    bhv_grand_star_loop()
end

hook_behavior(id_bhvGrandStar, OBJ_LIST_LEVEL, true, bhv_custom_grand_star_init, bhv_custom_grand_star_loop,
    "bhvGrandStar")

--------------------------
-----Global functions-----
--------------------------

---@param param any
---@param case_table table
---@return function | nil
function switch(param, case_table)
    local case = case_table[param]
    if case then return case() end
    local def = case_table['default']
    return def and def() or nil
end

--- @param obj Object
--- @param hitbox ObjectHitbox
function obj_set_hitbox(obj, hitbox)
    if not obj or not hitbox then return end
    -- As far as I can tell, this is used to
    -- force the hitboxes to be set only once
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

wingcaplevel = {
    [LEVEL_WMOTR] = true,
    [LEVEL_TOTWC] = true

}

function on_interact(m, o, type, value)
    if get_id_from_behavior(o.behavior) == id_bhvWingCap and wingcaplevel then
        stop_cap_music()
    end
end

ShowReward = true
for i in pairs(gActiveMods) do
    if (gActiveMods[i].incompatible ~= nil and gActiveMods[i].incompatible:find("gamemode")) and not (gActiveMods[i].name:find("Personal Star Counter")) then
        ShowReward = false
    end
end

function true_ending_reward(m)
    if m.numStars >= 91 and ShowReward then
        if not gNetworkPlayers[m.playerIndex].connected then return end
        if gNetworkPlayers[m.playerIndex].currLevelNum ~= gNetworkPlayers[0].currLevelNum or gNetworkPlayers[m.playerIndex].currAreaIndex ~= gNetworkPlayers[0].currAreaIndex then return end
        m.particleFlags = m.particleFlags | PARTICLE_SPARKLES
    end
end

function over_the_amount(m)
    if m.numStars >= 92 then
        djui_popup_create(
            "Wait hold on. Looks like you have a bit more \\#deb307\\stars\\#ffffff\\ than you should... Hmm, I guess it isn't a HUGE deal... alright, go on, get outta here.",
            3)
    end
end

function no_fall_damage(m)
    m.peakHeight = m.pos.y
end

function mario_update(m)
    no_fall_damage(m)
    true_ending_reward(m)
    general_stuff_update(m)
    mario_life_update()
end

hook_event(HOOK_MARIO_UPDATE, mario_update)
hook_event(HOOK_ON_WARP, entered_c13)
hook_event(HOOK_ON_PLAYER_CONNECTED, over_the_amount)
hook_event(HOOK_ON_INTERACT, on_interact)
