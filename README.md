# Swiftly Shop-Core Guess The Number
A plugin for Swiftly Shop-Core that sends to players an mini-game to guess the number rewarding credits.

## Configuration variables directly into code:

local chanceToStartGame = 25 (Here you can edit the chances between 0-100 for the game to be started at start round)

local function generateRandomNumber()
    targetNumber = math.random(1, 15) (Here you can edit the numbers that could be on the game, an simple math random between 1-15)
    creditReward = math.random(100, 300) (Here you can edit the credits reward randomly)
end
