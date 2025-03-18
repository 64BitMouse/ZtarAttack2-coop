-------------------------------------------
-- Custom Hud Written by Squishy6094 >.< --
-------------------------------------------


local function lerp(a, b, t)
    return a * (1 - t) + b * t
end

WORLD_SELECT_DEFAULT = -2
WORLD_SELECT = -1
WORLD_OTHER = 0
WORLD_1 = 1
WORLD_2 = 2
WORLD_3 = 3
WORLD_4 = 4
WORLD_5 = 5
WORLD_SPECIAL = 6
WORLD_NEGITIVE = 7

local levelWorlds = {
    [LEVEL_BOB]      = WORLD_1,
    [LEVEL_WF]       = WORLD_1,
    [LEVEL_JRB]      = WORLD_1,
    [LEVEL_BITDW]    = WORLD_1,
    [LEVEL_BOWSER_1] = WORLD_1,

    [LEVEL_CCM]      = WORLD_2,
    [LEVEL_BBH]      = WORLD_2,
    [LEVEL_HMC]      = WORLD_2,
    [LEVEL_BITFS]    = WORLD_2,
    [LEVEL_BOWSER_2] = WORLD_2,

    [LEVEL_LLL]      = WORLD_3,
    [LEVEL_SSL]      = WORLD_3,
    [LEVEL_DDD]      = WORLD_3,
    [LEVEL_COTMC]    = WORLD_3,

    [LEVEL_SL]       = WORLD_4,
    [LEVEL_WDW]      = WORLD_4,
    [LEVEL_TTM]      = WORLD_4,
    [LEVEL_VCUTM]    = WORLD_4,

    [LEVEL_THI]      = WORLD_5,
    [LEVEL_TTC]      = WORLD_5,
    [LEVEL_RR]       = WORLD_5,
    [LEVEL_BITS]     = WORLD_5,
    [LEVEL_BOWSER_3] = WORLD_5,
    [LEVEL_TOTWC]    = WORLD_5,

    [LEVEL_SA]       = WORLD_SPECIAL,

    [LEVEL_WMOTR]    = WORLD_NEGITIVE
}

local levelNames = {
    [LEVEL_BOB]      = "1-1",
    [LEVEL_WF]       = "1-2",
    [LEVEL_JRB]      = "1-3",
    [LEVEL_BITDW]    = "1-4",
    [LEVEL_BOWSER_1] = "1-4",

    [LEVEL_CCM]      = "2-1",
    [LEVEL_BBH]      = "2-2",
    [LEVEL_HMC]      = "2-3",
    [LEVEL_BITFS]    = "2-4",
    [LEVEL_BOWSER_2] = "2-4",

    [LEVEL_LLL]      = "3-1",
    [LEVEL_SSL]      = "3-2",
    [LEVEL_DDD]      = "3-3",
    [LEVEL_COTMC]    = "3-4",

    [LEVEL_SL]       = "4-1",
    [LEVEL_WDW]      = "4-2",
    [LEVEL_TTM]      = "4-3",
    [LEVEL_VCUTM]    = "4-4",

    [LEVEL_THI]      = "5-1",
    [LEVEL_TTC]      = "5-2",
    [LEVEL_RR]       = "5-3",
    [LEVEL_BITS]     = "5-4",
    [LEVEL_BOWSER_3] = "5-4",
    [LEVEL_TOTWC]    = "5-5",

    [LEVEL_SA]       = "S",

    [LEVEL_WMOTR]    = string.upper("Negative Realm")
}

local worldHudColors = {
    [WORLD_SELECT_DEFAULT]    = {r = 91, g = 91, b = 91},
    [WORLD_SELECT]    = {r = 91, g = 91, b = 91},
    [WORLD_OTHER]    = {r = 255, g = 255, b = 255},
    [WORLD_1]        = {r = 162, g = 54, b = 175},
    [WORLD_2]        = {r = 228, g = 167, b = 27},
    [WORLD_3]        = {r = 35, g = 160, b = 38},
    [WORLD_4]        = {r = 36, g = 44, b = 161},
    [WORLD_5]        = {r = 255, g = 26, b = 26},
    [WORLD_SPECIAL]  = {r = 35, g = 140, b = 140},
    [WORLD_NEGITIVE] = {r = 255 - 162, g = 255 - 54, b = 255 -175},
}

local lifeIcons = {
    [CT_MARIO] = gTextures.mario_head,
    [CT_LUIGI] = gTextures.luigi_head,
    [CT_TOAD] = gTextures.toad_head,
    [CT_WALUIGI] = gTextures.waluigi_head,
    [CT_WARIO] = gTextures.wario_head,
}

local TEX_HEALTH_METER = get_texture_info("za2-health-meter-remake")

local function hud_render()
    local m = gMarioStates[0]
    local np = gNetworkPlayers[0]
    local levelInfo = levelNames[np.currLevelNum]
    djui_hud_set_resolution(RESOLUTION_N64)
    local width = djui_hud_get_screen_width()
    local height = djui_hud_get_screen_height()

    hud_hide()

    local currWorld = levelWorlds[np.currLevelNum] ~= nil and levelWorlds[np.currLevelNum] or WORLD_OTHER
    if np.currLevelNum == LEVEL_CASTLE and m.pos.y < -4500 and m.pos.z < -2500 then
        
        local targetWorld = WORLD_SELECT_DEFAULT
        if m.pos.x < -7040 then
            targetWorld = WORLD_SPECIAL
            if m.pos.z > -7220 then
                targetWorld = WORLD_NEGITIVE
            end
        elseif m.pos.x > 5350 then
            targetWorld = WORLD_5
        elseif m.pos.x > -5920 then
            if m.pos.z > -6975 then
                targetWorld = WORLD_1
                if m.pos.x > -1000 then
                    targetWorld = WORLD_3
                end
            elseif m.pos.z < -7650 then
                targetWorld = WORLD_2
                if m.pos.x > -1000 then
                    targetWorld = WORLD_4
                end
            end
        end
        worldHudColors[WORLD_SELECT] = {
            r = lerp(worldHudColors[WORLD_SELECT].r, worldHudColors[targetWorld].r, 0.05),
            g = lerp(worldHudColors[WORLD_SELECT].g, worldHudColors[targetWorld].g, 0.05),
            b = lerp(worldHudColors[WORLD_SELECT].b, worldHudColors[targetWorld].b, 0.05),
        }
        currWorld = WORLD_SELECT
    else
        worldHudColors[WORLD_SELECT] = worldHudColors[WORLD_SELECT_DEFAULT]
    end
    local color = worldHudColors[currWorld]
    djui_hud_set_color(color.r, color.g, color.b, 255)
    djui_hud_set_font(FONT_RECOLOR_HUD)

    local x = 10
    local y = 15
    -- Lives indicator
    djui_hud_set_color(255, 255, 255, 255)
    if _G.charSelectExists then
        _G.charSelect.character_render_life_icon(0, x, y, 1.5)
    else
        djui_hud_render_texture(lifeIcons[gMarioStates[0].character.type], x, y, 1.5, 1.5)
    end
    if _G.OmmEnabled then 
        djui_hud_set_color(color.r, color.g, color.b, 255)
    djui_hud_print_text("INFINITE", x + 16, y + 5, 0.8)
    else
    djui_hud_set_color(color.r, color.g, color.b, 255)
    djui_hud_print_text(tostring(hud_get_value(HUD_DISPLAY_LIVES)), x + 16, y + 5, 0.8)
    end
    local x = 10
    local y = 42
    if levelWorlds[np.currLevelNum] ~= nil  and gNetworkPlayers[0].currLevelNum ~= LEVEL_WMOTR then
        -- Coins indicator
        djui_hud_set_color(255, 255, 255, 255)
        djui_hud_render_texture(gTextures.coin, x, y, 1.5, 1.5)
        djui_hud_set_color(color.r, color.g, color.b, 255)
        djui_hud_print_text(tostring(hud_get_value(HUD_DISPLAY_COINS)), x + 16, y + 5, 0.8)
    end

    local x = 10
    local y = levelWorlds[np.currLevelNum] ~= nil and 69 or 42
    -- Stars indicator
    djui_hud_set_color(255, 255, 255, 255)
    if _G.charSelectExists then
        _G.charSelect.character_render_star_icon(0, x, y, 1.5)
    else
        djui_hud_render_texture(gTextures.star, x, y, 1.5, 1.5)
    end
    djui_hud_set_color(color.r, color.g, color.b, 255)
    djui_hud_print_text(tostring(hud_get_value(HUD_DISPLAY_STARS)), x + 16, y + 5, 0.8)

    local x = width - 48 - 10
    local y = 15
    djui_hud_set_color(255, 255, 255, 255)
    local health = math.floor(m.health/0x100)
    djui_hud_render_texture_tile(TEX_HEALTH_METER, x, y, 1, 1, 49*health, 0, 48, 48)
    --djui_hud_render_texture(TEX_HEALTH_METER, x, y, 1, 1)
    djui_hud_set_color(color.r, color.g, color.b, 255)
    djui_hud_print_text(tostring(health), x + 16, y + 7, 1)

    djui_hud_set_color(color.r, color.g, color.b, 255)
    local text = "WORLD " .. (levelInfo and levelInfo or "???")
    if np.currLevelNum == LEVEL_WMOTR then
        text = levelInfo
    end
    local x = width*0.5 - djui_hud_measure_text(text)*0.5
    local y = 4
    -- World Indicator
    if levelInfo --[[and not is_game_paused()]] then
        djui_hud_print_text(text, x, y, 1)
    end

    local timer = hud_get_value(HUD_DISPLAY_TIMER)
    if timer ~= 0 then
        local text = string.format("%s:%s.%s", string.format("%02d", math.floor(timer/30/60)), string.format("%02d", math.floor(timer/30)%60), string.format("%02d", math.floor((timer*(10/3))%100)))
        local x = width*0.5 - djui_hud_measure_text(text)*0.5
        local y = height - 20 - 11
        -- Timer
        if levelInfo --[[and not is_game_paused()]] then
            djui_hud_print_text(text, x, y, 1)
        end
    end
end


hook_event(HOOK_ON_HUD_RENDER_BEHIND, hud_render)