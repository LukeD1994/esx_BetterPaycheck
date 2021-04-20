ESX.StartPayCheck = function()
	-- new clock system event
	RegisterServerEvent('esx_paycheck:ClockIn')
	AddEventHandler('esx_paycheck:ClockIn', function()
		local ids = GetPlayerIdentifiers(source)
		local identifier = nil
		for k,v in pairs(ids) do
			if string.sub(v, 1, string.len("license:")) == "license:" then
				identifier = v
			elseif string.sub(v, 1, string.len("Char1:")) == "Char1:" then
				identifier = v
			elseif string.sub(v, 1, string.len("Char3:")) == "Char3:" then
				identifier = v
			elseif string.sub(v, 1, string.len("Char4:")) == "Char4:" then
				identifier = v
			end
		end
		print('source: ' .. source .. ' identifier: '..identifier)
		local clockinTime = GetGameTimer()
		MySQL.Async.execute('UPDATE `users` SET `clockin` = @time, `working` = 1 WHERE identifier = @identifier', {
			['@identifier'] = identifier,
			['@time'] = clockinTime
		}, function(rowsChanged)
			--done
			print('player clocked in at: '..clockinTime)
		end)
	end)

	RegisterServerEvent('esx_paycheck:ClockOutAuto')
	AddEventHandler('esx_paycheck:ClockOutAuto', function(identifier)
		MySQL.Async.fetchScalar('SELECT working FROM users WHERE identifier = @identifier',{
			['@identifier'] = identifier
		}, function(res)
			if res == 1 then
				local clockoutTime = GetGameTimer()
				--player is actually clocked in today
				MySQL.Async.execute('UPDATE `users` SET `clockout` = @time, `working` = 0 WHERE identifier = @identifier', {
					['@identifier'] = identifier,
					['@time'] = clockoutTime
				}, function(rowsChanged)
					print('player clocked out at: '..clockoutTime)
				end)
		
				local xPlayer = ESX.GetPlayerFromIdentifier(identifier)
				if xPlayer ~= nil then
					-- calculate hours worked
					MySQL.Async.fetchAll('SELECT clockin, clockout FROM users WHERE identifier = @identifier',{
						['@identifier'] = identifier
					}, function(result)
						local differenceMs = math.abs(result[1].clockin - result[1].clockout)
						if differenceMs ~= nil then
							local differenceHrs = ((differenceMs/1000)/60)/60
							local payout = math.ceil(differenceHrs) * xPlayer.job.grade_salary
		
							-- resume normal checks before paying out
							if Config.EnableSocietyPayouts then -- possibly a society
								TriggerEvent('esx_society:getSociety', xPlayer.job.name, function (society)
									if society ~= nil then -- verified society
										TriggerEvent('esx_addonaccount:getSharedAccount', society.account, function (account)
											if account.money >= payout then -- does the society money to pay its employees?
												xPlayer.addAccountMoney('bank', payout)
												account.removeMoney(payout)
						
												TriggerClientEvent('esx:showAdvancedNotification', xPlayer.source, _U('bank'), _U('received_paycheck'), _U('received_salary', payout), 'CHAR_BANK_MAZE', 9)
											else
												TriggerClientEvent('esx:showAdvancedNotification', xPlayer.source, _U('bank'), '', _U('company_nomoney'), 'CHAR_BANK_MAZE', 1)
											end
										end)
									else -- not a society
										xPlayer.addAccountMoney('bank', payout)
										TriggerClientEvent('esx:showAdvancedNotification', xPlayer.source, _U('bank'), _U('received_paycheck'), _U('received_salary', payout), 'CHAR_BANK_MAZE', 9)
									end
								end)
							else -- generic job
								xPlayer.addAccountMoney('bank', payout)
								TriggerClientEvent('esx:showAdvancedNotification', xPlayer.source, _U('bank'), _U('received_paycheck'), _U('received_salary', payout), 'CHAR_BANK_MAZE', 9)
							end
						else
							print('error with paycheck, difference in ms was nil')
						end
		
					end)
				else
					print('error clocking player paycheck, xPlayer was nil')
				end
			else
				print('player was not working today, no paycheck for them')
			end
		end)
		
		
	end)
	
	RegisterServerEvent('esx_paycheck:ClockOut')
	AddEventHandler('esx_paycheck:ClockOut', function()
		local ids = GetPlayerIdentifiers(source)
				local identifier = nil
				for k,v in pairs(ids) do
					if string.sub(v, 1, string.len("license:")) == "license:" then
						identifier = v
					elseif string.sub(v, 1, string.len("Char1:")) == "Char1:" then
						identifier = v
					elseif string.sub(v, 1, string.len("Char3:")) == "Char3:" then
						identifier = v
					elseif string.sub(v, 1, string.len("Char4:")) == "Char4:" then
						identifier = v
					end
				end
		MySQL.Async.fetchScalar('SELECT working FROM users WHERE identifier = @identifier',{
			['@identifier'] = identifier
		}, function(res)
			if res == 1 then
				local clockoutTime = GetGameTimer()
				MySQL.Async.execute('UPDATE `users` SET `clockout` = @time WHERE identifier = @identifier', {
					['@identifier'] = identifier,
					['@time'] = clockoutTime
				}, function(rowsChanged)
					print('player clocked out at: '..clockoutTime)
				end)
		
				local xPlayer = ESX.GetPlayerFromIdentifier(identifier)
				if xPlayer ~= nil then
					-- calculate hours worked
					MySQL.Async.fetchAll('SELECT `clockin`, `clockout` FROM users WHERE identifier = @identifier',{
						['@identifier'] = identifier
					}, function(result)
						local differenceMs = math.abs(result[1].clockin - result[1].clockout)
						if differenceMs ~= nil then
							local differenceHrs = ((differenceMs/1000)/60)/60
							local payout = math.ceil(differenceHrs) * xPlayer.job.grade_salary
		
							-- resume normal checks before paying out
							if Config.EnableSocietyPayouts then -- possibly a society
								TriggerEvent('esx_society:getSociety', xPlayer.job.name, function (society)
									if society ~= nil then -- verified society
										TriggerEvent('esx_addonaccount:getSharedAccount', society.account, function (account)
											if account.money >= payout then -- does the society money to pay its employees?
												xPlayer.addAccountMoney('bank', payout)
												account.removeMoney(payout)
						
												TriggerClientEvent('esx:showAdvancedNotification', xPlayer.source, _U('bank'), _U('received_paycheck'), _U('received_salary', payout), 'CHAR_BANK_MAZE', 9)
											else
												TriggerClientEvent('esx:showAdvancedNotification', xPlayer.source, _U('bank'), '', _U('company_nomoney'), 'CHAR_BANK_MAZE', 1)
											end
										end)
									else -- not a society
										xPlayer.addAccountMoney('bank', payout)
										TriggerClientEvent('esx:showAdvancedNotification', xPlayer.source, _U('bank'), _U('received_paycheck'), _U('received_salary', payout), 'CHAR_BANK_MAZE', 9)
									end
								end)
							else -- generic job
								xPlayer.addAccountMoney('bank', payout)
								TriggerClientEvent('esx:showAdvancedNotification', xPlayer.source, _U('bank'), _U('received_paycheck'), _U('received_salary', payout), 'CHAR_BANK_MAZE', 9)
							end
						else
							print('error with paycheck, difference in ms was nil')
						end
		
					end)
				else
					print('error clocking player paycheck, xPlayer was nil')
				end
			else
				print('player was not actually working today')
			end
		end)

	end)

	function payCheck()
		local xPlayers = ESX.GetPlayers()
	
		for i=1, #xPlayers, 1 do
			local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
			local job     = xPlayer.job.grade_name
			local salary  = xPlayer.job.grade_salary
	
			if salary > 0 then
				-- in paycheck we ONLY want to check for unemployment, as you cannot clock in and out of unemployment
				if job == 'unemployed' then -- unemployed
					xPlayer.addAccountMoney('bank', salary)
					TriggerClientEvent('esx:showAdvancedNotification', xPlayer.source, _U('bank'), _U('received_paycheck'), _U('received_help', salary), 'CHAR_BANK_MAZE', 9)
				end
				
			end
	
		end
	
		SetTimeout(Config.PaycheckInterval, payCheck)
	end
	SetTimeout(Config.PaycheckInterval, payCheck)
end



	



--[[if job == 'unemployed' then -- unemployed
				xPlayer.addAccountMoney('bank', salary)
				TriggerClientEvent('esx:showAdvancedNotification', xPlayer.source, _U('bank'), _U('received_paycheck'), _U('received_help', salary), 'CHAR_BANK_MAZE', 9)
			elseif Config.EnableSocietyPayouts then -- possibly a society
				TriggerEvent('esx_society:getSociety', xPlayer.job.name, function (society)
					if society ~= nil then -- verified society
						TriggerEvent('esx_addonaccount:getSharedAccount', society.account, function (account)
							if account.money >= salary then -- does the society money to pay its employees?
								xPlayer.addAccountMoney('bank', salary)
								account.removeMoney(salary)

								TriggerClientEvent('esx:showAdvancedNotification', xPlayer.source, _U('bank'), _U('received_paycheck'), _U('received_salary', salary), 'CHAR_BANK_MAZE', 9)
							else
								TriggerClientEvent('esx:showAdvancedNotification', xPlayer.source, _U('bank'), '', _U('company_nomoney'), 'CHAR_BANK_MAZE', 1)
							end
						end)
					else -- not a society
						xPlayer.addAccountMoney('bank', salary)
						TriggerClientEvent('esx:showAdvancedNotification', xPlayer.source, _U('bank'), _U('received_paycheck'), _U('received_salary', salary), 'CHAR_BANK_MAZE', 9)
					end
				end)
			else -- generic job
				xPlayer.addAccountMoney('bank', salary)
				TriggerClientEvent('esx:showAdvancedNotification', xPlayer.source, _U('bank'), _U('received_paycheck'), _U('received_salary', salary), 'CHAR_BANK_MAZE', 9)
			end]]--