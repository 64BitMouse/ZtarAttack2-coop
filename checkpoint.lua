-- this file handles the checkpoint system

-- stars in each area (some courses have nodes oob, so if another file is used it would kill them without this)
local checkpoint_valid = {
    -- World 1
    [1] = 2, 
    [2] = 2,
    [3] = 3,
    [16] = 4,
    -- World 2
    [4] = 2,
    [5] = 4,
    [6] = 5,
    [17] = 5,
    -- World 3
    [7] = 4,
    [8] = 3,
    [9] = 3,
    [20] = 6,
    -- World 4
    [10] = 2,
    [11] = 6,
    [12] = 3,
    [22] = 5,
    -- World 5,
    [13] = 4,
    [14] = 6,
    [15] = 6,
    [18] = 6,
}
local disableCheckpoint = false
function checkpoint_command(msg)
    if msg == nil then
        return false
    elseif msg:lower() == "on" then
        disableCheckpoint = false
        djui_chat_message_create("Time star checkpoints have been enabled")
        return true
    elseif msg:lower() == "off" then
        disableCheckpoint = true
        djui_chat_message_create("Time star checkpoints have been disabled")
        return true
    end
end
hook_chat_command("checkpoint","[ON|OFF] - Enable/disable time star checkpoints",checkpoint_command)


function do_checkpoint()
    if disableCheckpoint then return end

    local course = gNetworkPlayers[0].currCourseNum
    --djui_chat_message_create(tostring(level))
    if not checkpoint_valid[course] then
        return
    end

    -- both of these are used as the start, so check both
    local startWarp = area_get_warp_node(10)
    local startWarp2 = area_get_warp_node(32)
    if ((not startWarp) or dist_between_objects(startWarp.object, gMarioStates[0].marioObj) ~= 0) and ((not startWarp2) or dist_between_objects(startWarp2.object, gMarioStates[0].marioObj) ~= 0) then
        return
    end

    local file = get_current_save_file_num() - 1
    local starFlags = save_file_get_star_flags(file, course - 1)
    for i=checkpoint_valid[course]-1,0, -1 do
        if starFlags & (1 << i) ~= 0 then
            local checkWarp = area_get_warp_node(33+i) -- I would just dynos warp, but that breaks stuff
            if checkWarp then
                gMarioStates[0].pos.x = checkWarp.object.oPosX
                gMarioStates[0].pos.y = checkWarp.object.oPosY
                gMarioStates[0].pos.z = checkWarp.object.oPosZ
                gMarioStates[0].faceAngle.y = checkWarp.object.oFaceAngleYaw
                break
            end
        end
    end
    return false
end

hook_event(HOOK_ON_LEVEL_INIT, do_checkpoint)