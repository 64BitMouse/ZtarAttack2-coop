gLevelValues.entryLevel = LEVEL_CASTLE_GROUNDS
gLevelValues.exitCastleLevel = 16
gLevelValues.exitCastleArea = 1
gLevelValues.exitCastleWarpNode = 10

gBehaviorValues.KingBobombFVel = 8.625
gBehaviorValues.KingBobombYawVel = 512
gBehaviorValues.KingBobombHealth = 4
gBehaviorValues.KingWhompHealth = 4

gBehaviorValues.KoopaThiAgility = 6.0
gBehaviorValues.KoopaBobAgility = 3.0
gBehaviorValues.KoopaCatchupAgility = 8.0
gBehaviorValues.trajectories.KoopaBobTrajectory = get_trajectory("KoopaBoB_path")
gBehaviorValues.trajectories.KoopaThiTrajectory = get_trajectory("KoopaTHI_path")

gBehaviorValues.MipsStar1Requirement = 89
gBehaviorValues.MipsStar2Requirement = 181
gBehaviorValues.ToadStar3Requirement = 0

gLevelValues.pssSlideStarTime = 630

gLevelValues.wingCapDuration = 45000

gLevelValues.wingCapDurationTotwc = 1
gLevelValues.vanishCapDurationVcutm = 1
gLevelValues.metalCapDurationCotmc = 1

-- STAR_MILESTONES 1, 45, 83, 85, 89, 91

gBehaviorValues.starsNeededForDialog.dialog1 = 1
gBehaviorValues.starsNeededForDialog.dialog2 = 45
gBehaviorValues.starsNeededForDialog.dialog3 = 83
gBehaviorValues.starsNeededForDialog.dialog4 = 85
gBehaviorValues.starsNeededForDialog.dialog5 = 89
gBehaviorValues.starsNeededForDialog.dialog6 = 91

gLevelValues.coinsRequiredForCoinStar = 0

hook_event(HOOK_USE_ACT_SELECT, function () return false end)

-- Reduce red coin requirements
---@param obj Object
function bhv_custom_red_coin_star_loop(obj)
    if obj.oHiddenStarTriggerCounter >= gMarioStates[0].area.numRedCoins - 2 then
        obj.oAction = 1
    end
end

-- These both need to be changed, though they share a lot of the same code so the function can be reused
hook_behavior(id_bhvHiddenRedCoinStar, OBJ_LIST_LEVEL, false, nil, bhv_custom_red_coin_star_loop, "bhvHiddenRedCoinStar")
hook_behavior(id_bhvBowserCourseRedCoinStar, OBJ_LIST_LEVEL, false, nil, bhv_custom_red_coin_star_loop, "bhvBowserCourseRedCoinStar")

-- Faster hangable ceiling speed

---@param num number
---@return number
local function convert_s16(num)
    num = num & 0xFFFF
    return ((num >= 0x7FFF) and (num - 0x10000) or num)
end

---@param m MarioState
local function update_custom_hang_moving(m)
    local stepResult = 0
    local nextPos = {}
    local maxSpeed = 16

    m.forwardVel = m.forwardVel + 1
    if m.forwardVel > maxSpeed then
        m.forwardVel = maxSpeed
    end

    m.faceAngle.y = m.intendedYaw - approach_s32(convert_s16(m.intendedYaw - m.faceAngle.y), 0, 0x800, 0x800)

    m.slideYaw = m.faceAngle.y
    m.slideVelX = m.forwardVel * sins(m.faceAngle.y)
    m.slideVelZ = m.forwardVel * coss(m.faceAngle.y)

    m.vel.x = m.slideVelX
    m.vel.y = 0.0
    m.vel.z = m.slideVelZ

    nextPos.x = m.pos.x - m.ceil.normal.y * m.vel.x
    nextPos.z = m.pos.z - m.ceil.normal.y * m.vel.z
    nextPos.y = m.pos.y

    stepResult = perform_hanging_step(m, nextPos)

    vec3f_copy(m.marioObj.header.gfx.pos, m.pos)
    vec3s_set(m.marioObj.header.gfx.angle, 0, m.faceAngle.y, 0)
    return stepResult
end

---@param m MarioState
function act_custom_hang_moving(m)
    if m.input & INPUT_A_DOWN == 0 then
        return set_mario_action(m, ACT_FREEFALL, 0)
    end

    if m.input & INPUT_Z_PRESSED ~= 0 then
        return set_mario_action(m, ACT_GROUND_POUND, 0)
    end

    if m.ceil == nil or m.ceil.type ~= SURFACE_HANGABLE then
        return set_mario_action(m, ACT_FREEFALL, 0)
    end

    if m.actionArg & 1 ~= 0 then
        set_mario_animation(m, MARIO_ANIM_MOVE_ON_WIRE_NET_RIGHT)
    else
        set_mario_animation(m, MARIO_ANIM_MOVE_ON_WIRE_NET_LEFT)
    end

    if m.marioObj.header.gfx.animInfo.animFrame == 12 then
        play_sound(SOUND_ACTION_HANGING_STEP, m.marioObj.header.gfx.cameraToObject)
        queue_rumble_data_mario(m, 5, 30)
    end

    if is_anim_past_end(m) ~= 0 then
        m.actionArg = m.actionArg ~ 1
        if m.input & INPUT_ZERO_MOVEMENT ~= 0 then
            return set_mario_action(m, ACT_HANGING, m.actionArg)
        end
    end

    if update_custom_hang_moving(m) == 2 --[[HANG_LEFT_CEIL]] then
        set_mario_action(m, ACT_FREEFALL, 0)
    end

    return 0
end

hook_mario_action(ACT_HANG_MOVING, act_custom_hang_moving)