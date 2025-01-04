function GetPluginAuthor()
    return "Karp & rocobalt"
end
function GetPluginVersion()
    return "v1.0.0"
end
function GetPluginName()
    return "Random Number"
end
function GetPluginWebsite()
    return ""
end


local targetNumber = 0
local creditReward = 0
local playerTries = {}
local gameEnded = true
local messageSent = {}

local chanceToStartGame = 25

local function generateRandomNumber()
    targetNumber = math.random(1, 15)
    creditReward = math.random(100, 300)
end

local function handleGuess(playerid, message)
    local guessedNumber = tonumber(message)
    if guessedNumber then
        if guessedNumber == targetNumber then
            local playerName = GetPlayer(playerid)
            playermanager:SendMsg(MessageType.Chat, "{silver}[{gold}Haos{silver}] {default}Jucatorul {green}" .. playerName:CBasePlayerController().PlayerName .. "{default} a ghicit numarul, acesta fiind{red} " ..targetNumber.. " {default}si a castigat{green} " .. creditReward .. " credite!")
            exports["shop-core"]:GiveCredits(playerid, creditReward)
            gameEnded = true
            playerTries[playerid] = nil
        else
            if playerTries[playerid] and playerTries[playerid] < 3 then
                playerTries[playerid] = playerTries[playerid] + 1
                local remainingTries = 3 - playerTries[playerid]
                if remainingTries > 0 then
                    ReplyToCommand(playerid, "{silver}[{gold}Haos{silver}]", "{red}Nu ai ghicit numarul.{default} Mai ai {red}" .. remainingTries .. " incercari.")
                else
                    ReplyToCommand(playerid, "{silver}[{gold}Haos{silver}]", "{red}Ai pierdut.{green} Incearca data urmatoare!")
                end
            end
        end
    end
end

AddEventHandler("OnRoundStart", function()
    local randomChance = math.random(0, 100)
    if randomChance <= chanceToStartGame then
        if gameEnded then
            generateRandomNumber()
            playermanager:SendMsg(MessageType.Chat, "◇─◇──◇─◇ ◇─◇──◇─◇{gold}「 ✦ {gold}GUESS THE NUMBER{gold} ✦ 」{default}◇─◇──◇─◇ ◇─◇──◇─◇")
            playermanager:SendMsg(MessageType.Chat, "{default}[{yellow}Haos{default}]{default} Ma gandesc la un numar de la 1 la 15.{default} {red} Ai 3 incercari.")
            playermanager:SendMsg(MessageType.Chat, "{default}[{yellow}Haos{default}] Reward: {red}" ..creditReward .." credite")
            playermanager:SendMsg(MessageType.Chat, "◇─◇──◇─◇ ◇─◇──◇─◇{gold}「 ✦ {gold}GUESS THE NUMBER{gold} ✦ 」{default}◇─◇──◇─◇ ◇─◇──◇─◇")
            for playerid, _ in pairs(playerTries) do
                playerTries[playerid] = 0
            end
            for playerid, _ in pairs(messageSent) do
                messageSent[playerid] = nil
            end
            gameEnded = false
        end
    end
end)

AddEventHandler("OnRoundEnd", function()
    if not gameEnded then
        gameEnded = true
        playermanager:SendMsg(MessageType.Chat, "◇─◇──◇─◇ ◇─◇──◇─◇{gold}「 ✦ {gold}GUESS THE NUMBER{gold} ✦ 」{default}◇─◇──◇─◇ ◇─◇──◇─◇")
        playermanager:SendMsg(MessageType.Chat, "{silver}[{gold}Haos{silver}]{red} Numarul nu a fost ghicit.{default} Tura s-a incheiat. {green}Numarul era: " ..targetNumber.."")
        playermanager:SendMsg(MessageType.Chat, "◇─◇──◇─◇ ◇─◇──◇─◇{gold}「 ✦ {gold}GUESS THE NUMBER{gold} ✦ 」{default}◇─◇──◇─◇ ◇─◇──◇─◇")
    end
end)

AddEventHandler("OnClientChat", function(event, playerid, text)
    local guessedNumber = tonumber(text)
    if guessedNumber and guessedNumber >= 1 and guessedNumber <= 15 then
        if not playerTries[playerid] then
            playerTries[playerid] = 0
        end
        if gameEnded then
            return ""
        end
        if playerTries[playerid] < 3 then
            handleGuess(playerid, text)
        end
        return ""
    end
end)