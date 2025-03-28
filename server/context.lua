Context = {
    amountOfRuns = {},
    oxyRunCooldown = {},
}

RegisterNetEvent("oxy:server:TriggerCooldown", function(data)
    local player = QBCore.Functions.GetPlayer(source)

    Context.oxyRunCooldown[source] = os.time()
end)

lib.callback.register("oxy:server:GetCooldown", function(source, data)
	local cooldown = 0
	local savedTimestamp = Context.oxyRunCooldown[source]

	if savedTimestamp == nil then
		savedTimestamp = -1
	end

	local runCooldownInSeconds = Config.CoreInfo.CooldownBetweenRunsInMinutes * 60
	local timeExpires = savedTimestamp + runCooldownInSeconds
	local remainingTime = timeExpires - os.time()

	cooldown = remainingTime > 0 and remainingTime or 0

	if cooldown <= 0 then
		Context.oxyRunCooldown[source] = -1
	end
	
	return cooldown
end)