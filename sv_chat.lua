local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP","vRP_chatroles")
vRPsp = Proxy.getInterface("vRP_sponsor")

RegisterServerEvent('chat:init')
RegisterServerEvent('chat:addTemplate')
RegisterServerEvent('chat:addMessage')
RegisterServerEvent('chat:addSuggestion')
RegisterServerEvent('chat:removeSuggestion')
RegisterServerEvent('_chat:muitzaqmessageEntered')
RegisterServerEvent('chat:clear')
RegisterServerEvent('__cfx_internal:commandFallback')

RegisterServerEvent('chat:kickSpammer')
AddEventHandler('chat:kickSpammer', function()
	TriggerClientEvent('chatMessage', -1, "^1[SPAM] ^2"..GetPlayerName(source).."^8 a primit kick pentru spam!")
	DropPlayer(source, 'You have been kicked for spamming!')
end)

local mute = {}
local timpmute = {}
--local mutevoice = {}
--local timpmutevoice = {}
local cooldown = {}
local cooldownTime = 0
local chatwebhook = "https://discord.com/api/webhooks/xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
local function cooldownChat(user_id)
	if vRP.isUserMod({user_id}) then
		cooldown[user_id] = nil
	else
		cooldown[user_id] = true
		cooldownTime = 5
		Wait(1000)
		cooldownTime = 4
		Wait(1000)
		cooldownTime = 3
		Wait(1000)
		cooldownTime = 2
		Wait(1000)
		cooldownTime = 1
		Wait(1000)
		cooldown[user_id] = nil
	end
end

function repeats(s,c)
    local _,n = s:gsub(c,"")
    return n
end

AddEventHandler('_chat:muitzaqmessageEntered', function(author, color, message)
	if (repeats(message,":") > 7) then
		TriggerClientEvent('chatMessage', source, "[^5Aries^0] Prea multe emoji-uri in mesaj!")
		return
	end
	if  (string.len(message) > 150) then
		TriggerClientEvent('chatMessage', source, "[^5Aries^0] Prea multe caractere in mesaj!")
		return	
	end
	if (string.find(message,":90:")) then
		TriggerClientEvent('chatMessage', source, "[^5Aries^0] Nu ai voie sa folosesti acest emoji!")
		return
	end
	if (string.find(message,"CONSOLA") or string.find(message,"consola") ) then
		TriggerClientEvent('chatMessage', source, "[^5Aries^0] Caca, nu e voie!!!")
		return
	end
	if (string.find(message,"discord.gg")) then
		TriggerClientEvent('chatMessage', source, "[^5Aries^0] Ce faci prietene?")
		return
	end
    if not message or not author then
        return
	end
	if source ~= nil then
		local user_id = vRP.getUserId({source})
		if user_id ~= nil then
			if not vRP.isUserTrialHelper({user_id}) or not vRP.hasGroup({user_id,"youtuber"}) or not vRP.hasGroup({user_id,"sponsors"}) or not vRP.isUserVip({user_id}) then
				author = sanitizeString(author, "^", false)
				message = sanitizeString(message, "^", false)
			end
			
			TriggerEvent('chatMessage', source, author, message)
			if disabled then
				if vRP.isUserTrialHelper({user_id}) then
					tag = "^9[ ^8"..user_id.." ^9] ^8STAFF ^9| ^8"..author.."^9 » ^0"
					TriggerClientEvent('chatMessage', -1, tag.." "..message)
				elseif vRP.isUserBronzeVip({user_id}) then
					tag = "^9[ ^5"..user_id.." ^9] ^5VIP "..vRP.getUserVipTitle({user_id}).." ^9| ^5"..author.."^9 » ^0"
					TriggerClientEvent('chatMessage', -1, tag.." "..message)
				elseif vRP.hasGroup({user_id,"sponsors"}) then
					local theTag = vRPsp.getSponsorTag({user_id})
					if(theTag ~= false)then
						tag = "^0[ ^5"..user_id.." ^0] ^5"..theTag.." ^0| ^5"..author.."^0 » ^0"
					else
						tag = "^0[ ^5"..user_id.." ^0] ^5🔥Sponsor🔥 ^0| ^5"..author.."^0 » ^0"
					end
					TriggerClientEvent('chatMessage', -1, tag.." "..message)
				elseif vRP.hasGroup({user_id,"youtuber"}) then
					tag = "^9[ ^5"..user_id.." ^9] ^5VIP "..vRP.getUserVipTitle({user_id}).." ^9| ^5"..author.."^9 » ^0"
					TriggerClientEvent('chatMessage', -1, tag.." "..message)
					print("[ "..user_id.." ] ", author.." » "..message)
					--PerformHttpRequest(chatwebhook, function(err, text, headers) end, 'POST', json.encode({username = "[ "..user_id.." ] "..author, content = message}), { ['Content-Type'] = 'application/json' })
				else
					CancelEvent()
					TriggerClientEvent('chatMessage', source, "[^5Aries^0] ^1Discutia este momentan dezactivata!")
				end
			elseif not WasEventCanceled() and not disabled then
				if mute[user_id] ~= true then
					if cooldown[user_id] ~= true then
						if user_id == 1 then
							tag = "[ ^8"..user_id.." ^0] :90: | ^y𝙁𝙊𝙉𝘿𝘼𝙏𝙊𝙍 ^0| ^v"..author.."^8 » ^0"
						 elseif user_id == 12 then
						 	tag = "[ ^8"..user_id.." ^0] 💎 | ^s~ 𝐎𝐍𝐋𝐘𝐅𝐀𝐍𝐒 ~ ^z| "..author.."^8 » ^0"
						 elseif user_id == 302 then
						 	tag = "[ ^8"..user_id.." ^0] 💎 | ^s~ 𝐎𝐍𝐋𝐘𝐅𝐀𝐍𝐒 ~ ^z| "..author.."^8 » ^0"
						elseif user_id == 7 then
							tag = "[ ^8"..user_id.." ^0] 💎 | ^s~ 𝐎𝐍𝐋𝐘𝐅𝐀𝐍𝐒 ~ ^z| "..author.."^8 » ^0"
						elseif vRP.isUserOwner({user_id}) then
							tag = "[ ^8"..user_id.." ^0] ⭐ | ^9𝙁𝙊𝙉𝘿𝘼𝙏𝙊𝙍 ^0| "..author.."^8 » ^0"
						elseif vRP.isUserSmecher({user_id}) then
							tag = "[ ^8"..user_id.." ^0] 👑👑👑 | | ^9𝙁𝙊𝙉𝘿𝘼𝙏𝙊𝙍 ^0| "..author.."^8 » ^0"
						-- elseif user_id == 3912 then
						-- 	tag = "[ ^8"..user_id.." ^0] 🔪 | ^o𝘉𝘓𝘖𝘖𝘋 𝘒𝘐𝘓𝘓𝘈 ^0| "..author.."^8 » ^0"
						elseif vRP.isUserCoOwner({user_id}) then
							tag = "[ ^8"..user_id.." ^0] | ^2Co-Fondator ^0| ^0"..author.."^8 » ^0"
						elseif vRP.isUserManager({user_id}) then
							tag = "[ ^8"..user_id.." ^0] | ^zTRUSTED ^0| ^s"..author.."^8 » ^0"
						elseif vRP.isUserSupervizor({user_id}) then
							tag = "[ ^8"..user_id.." ^0] | ^2Head of Staff ツ^0| "..author.."^8 » ^0"
						elseif vRP.isUserHeadAdmin({user_id}) then
							tag = "[ ^8"..user_id.." ^0] | ^2Supervizor Staff ツ^0| "..author.."^8 » ^0"
						elseif vRP.isUserHeadOfHelpers({user_id}) then
							tag = "[ ^8"..user_id.." ^0] | ^8Super Admin ツ^0| "..author.."^8 » ^0"
						elseif vRP.isUserAdmin({user_id}) then
							tag = "[ ^8"..user_id.." ^0] | ^8Admin ツ^0| "..author.."^8 » ^0"
						elseif vRP.isUserModAvansat({user_id}) then
							tag = "[ ^8"..user_id.." ^0] | ^3Super Moderator ツ^0| "..author.."^8 » ^0"
						elseif vRP.isUserMod({user_id}) then
							tag = "[ ^8"..user_id.." ^0] | ^1Moderator ツ^0| "..author.."^8 » ^0"
						elseif vRP.isUserHelperAvansat({user_id}) then
							tag = "[ ^8"..user_id.." ^0] | ^6Helper Avansat ツ^0| "..author.."^8 » ^0"
						elseif vRP.isUserHelper({user_id}) then
							tag = "[ ^8"..user_id.." ^0] | ^6Helper ツ^0| "..author.."^8 » ^0"
						elseif vRP.isUserTrialHelper({user_id}) then
							tag = "[ ^8"..user_id.." ^0] | ^6Helper in Teste ツ^0| "..author.."^8 » ^0"
						elseif vRP.hasGroup({user_id,"sponsors"}) then
							local theTag = vRPsp.getSponsorTag({user_id})
							if(theTag ~= false)then
								tag = "^9[ ^5"..user_id.." ^9] ^5"..theTag.." ^9| ^5"..author.."^9 » ^0"
							else
								tag = "^9[ ^5"..user_id.." ^9] ^5🔥Sponsor🔥 ^9| ^5"..author.."^9 » ^0"
							end
						elseif vRP.isUserNitroVip({user_id}) then
							tag = "[ ^6"..user_id.." ^0] | ^6🔮 Nitro Booster ^0| "..author.."^6 » ^0"
						elseif vRP.isUserAriesVip({user_id}) then
							tag = "[ ^6"..user_id.." ^0] | ^6🔮 Vip Aries ^0| "..author.."^6 » ^0"
						elseif vRP.hasGroup({user_id,"youtuber"}) then
							tag = "[ ^0"..user_id.." ^0] | ^0You^8Tube ^0| "..author.."^0 » ^0"
						elseif vRP.hasGroup({user_id,"Traficant de arme"}) then
							tag = "^2["..user_id.."] Traficant Arme ^7| "..author.." » ^0"
						elseif vRP.isUserDiamondVip({user_id}) then
							tag = "[ ^5"..user_id.." ^0] | ^3💎 VIP Diamond ^0| "..author.."^5 » ^0"	
						elseif vRP.isUserGoldVip({user_id}) then
							tag = "[ ^3"..user_id.." ^0] | ^3🥇 VIP Gold ^0| "..author.."^3 » ^0"	
						elseif vRP.isUserSilverVip({user_id}) then
							tag = "[ ^0"..user_id.." ^0] | ^0🥈 VIP Silver ^0| "..author.."^0 » ^0"		
						elseif vRP.isUserBronzeVip({user_id}) then
							tag = "[ ^1"..user_id.." ^0] | ^1🥉 VIP Bronze ^0| "..author.."^1 » ^0"
						elseif vRP.isUserNitroVip({user_id}) then
							tag = "[ ^6"..user_id.." ^0] | ^6🔮 Nitro Booster ^0| "..author.."^6 » ^0"
						elseif vRP.hasGroup({user_id,"sponsors"}) then
							local theTag = vRP.getSponsorTag({user_id})
							if(theTag ~= false)then
								tag = "^5["..user_id.."] "..theTag.." ^7| "..author.." » ^5"
							else
								tag = "[ ^3"..user_id.." ^0] | ^3🔥 Sponsor ^0| "..author.."^3 » ^0"
							end
						elseif vRP.isUserInFaction({user_id,"Politie"}) then
							local dutyStats = ""
							if(vRP.hasGroup({user_id,"onduty"}))then
								dutyStats = ""
							else
								dutyStats = "[OFF-DUTY] "
							end
							tag = "[ ^0"..user_id.." ^0] | "..dutyStats.." ^5👮Politist ^0| "..author.."^5 » ^0"	
						elseif vRP.isUserInFaction({user_id,"Armata Romana"}) then
							local dutyStats = ""
							if(vRP.hasGroup({user_id,"onduty"}))then
								dutyStats = ""
							else
								dutyStats = "[OFF-DUTY] "
							end
							tag = "[ ^0"..user_id.." ^0] | "..dutyStats.." ^5🛡️Armata Romana ^0| "..author.."^5 » ^0"
						elseif vRP.isUserInFaction({user_id,"SWAT"}) then
							local dutyStats = ""
							if(vRP.hasGroup({user_id,"onduty"}))then
								dutyStats = ""
							else
								dutyStats = "[OFF-DUTY] "
							end
							tag = "[ ^0"..user_id.." ^0] | "..dutyStats.." ^5🚓Jandarm ^0| "..author.."^5 » ^0"
						elseif vRP.isUserInFaction({user_id,"S.R.I"}) then
							local dutyStats = ""
							if(vRP.hasGroup({user_id,"onduty"}))then
								dutyStats = ""
							else
								dutyStats = "[OFF-DUTY] "
							end
							tag = "[ ^0"..user_id.." ^0] | "..dutyStats.." ^5🔫S.R.I ^0| "..author.."^5 » ^0"
						elseif vRP.isUserInFaction({user_id,"Smurd"}) then
							local dutyStats = ""
							if(vRP.hasGroup({user_id,"onduty"}))then
								dutyStats = ""
							else
								dutyStats = "[OFF-DUTY] "
							end
							tag = "[ ^0"..user_id.." ^0] | "..dutyStats.." ^6💊Medic ^0| "..author.."^6 » ^0"
						elseif vRP.isUserInFaction({user_id,"Hitman"}) then
							tag = "[ ^4"..user_id.." ^0] | ^4🗡️Hitman ^0| "..author.."^0 » ^0"
						elseif vRP.isUserInFaction({user_id,"Sindicat"}) then
							tag = "[ ^4"..user_id.." ^0] | ^4🎱 Sindicat ^0| "..author.."^0 » ^0"
						elseif vRP.isUserInFaction({user_id,"Cartel Sinaloa"}) then
							tag = "[ ^1"..user_id.." ^0] | ^1🔪 Cartel Sinaloa ^0| "..author.."^0 » ^0"
						elseif vRP.isUserInFaction({user_id,"Cartel Medellin"}) then
							tag = "[ ^6"..user_id.." ^0] | ^6🌿 Cartel Medellin ^0| "..author.."^0 » ^0"
						elseif vRP.isUserInFaction({user_id,"Los Vagos"}) then
							tag = "[ ^3"..user_id.." ^0] | ^3⚡️ Los Vagos ^0| "..author.."^0 » ^0"
						elseif vRP.isUserInFaction({user_id,"Sons of Anarchy"}) then
							tag = "[ ^m"..user_id.." ^0] | ^m🔫 Sons of Anarchy ^0| "..author.."^0 » ^0"
					--	elseif vRP.isUserInFaction({user_id},"SummerHouse"}) then
					--		tag = "[ ^2"..user_id.." ^0] | ^l👹SummerHouse ^0| "..author.."^0 » ^0"
							--------------------------------------------------------------

						elseif vRP.isUserInFaction({user_id,"Clanul Sportivilor"}) then
							tag = "[ ^n"..user_id.." ^0] | ^n🏅Clanul Sportivilor ^0| "..author.."^0 » ^0"
						elseif vRP.isUserInFaction({user_id,"Triads"}) then
							tag = "[ ^n"..user_id.." ^0] | ^h🐍Triads ^0| "..author.."^0 » ^0"
						elseif vRP.isUserInFaction({user_id,"Grape Street Gang"}) then
							tag = "[ ^n"..user_id.." ^0] | ^g🔮Grape Street Gang ^0| "..author.."^0 » ^0"
						elseif vRP.isUserInFaction({user_id,"Latin Kings"}) then
							tag = "[ ^n"..user_id.." ^0] | ^j👑Latin Kings ^0| "..author.."^0 » ^0"
						elseif vRP.isUserInFaction({user_id,"Hellbanianz"}) then
							tag = "[ ^n"..user_id.." ^0] | ^0🐉Hellbanianz ^0| "..author.."^0 » ^0"
						elseif vRP.isUserInFaction({user_id,"Mara Salvatrucha"}) then
							tag = "[ ^n"..user_id.." ^0] | ^1🗡️Mara Salvatrucha ^0| "..author.."^0 » ^0"
						elseif vRP.isUserInFaction({user_id,"Aryan Brotherhood"}) then
							tag = "[ ^n"..user_id.." ^0] | ^d☘️Aryan Brotherhood ^0| "..author.."^0 » ^0"

						elseif vRP.isUserInFaction({user_id,"Camorra"}) then
							tag = "[ ^3"..user_id.." ^0] | ^3👑 Camorra ^0| "..author.."^0 » ^0"
						elseif vRP.isUserInFaction({user_id,"Yakuza"}) then
							tag = "[ ^0"..user_id.." ^0] | ^0🃏 Yakuza ^0| "..author.."^0 » ^0"
						elseif vRP.isUserInFaction({user_id,"Rusa"}) then
							tag = "[ ^4"..user_id.." ^0] | ^4💀 Mafia Rusa ^0| "..author.."^0 » ^0"
						elseif vRP.isUserInFaction({user_id,"Ndragheta"}) then
							tag = "[ ^2"..user_id.." ^0] | ^2🎩 'Ndrangheta ^0| "..author.."^0 » ^0"
						elseif vRP.isUserInFaction({user_id,"Sopranos"}) then
							tag = "[ ^4"..user_id.." ^0] | ^4🏹 Sopranos ^0| "..author.."^0 » ^0"
						elseif vRP.isUserInFaction({user_id,"Bloods"}) then
							tag = "[ ^5"..user_id.." ^0] | ^8💔Bloods ^0| "..author.."^0 » ^0"
						elseif vRP.isUserInFaction({user_id,"Grove Street"}) then
							tag = "[ ^2"..user_id.." ^0] | ^2📗Grove Streets ^0| "..author.."^0 » ^0"
						elseif vRP.isUserInFaction({user_id,"Dealer Arme Oras"}) then
							tag = "^4[ "..user_id.." ] Dealer Arme Oras ^7| "..author.." » ^4"
						elseif vRP.isUserInFaction({user_id,"Aries News"}) then
							tag = "^9[ "..user_id.." ] Aries News ^5| "..author.." » ^9"
						elseif vRP.isUserInFaction({user_id,"Dealer Arme Sandy"}) then
							tag = "^4[ "..user_id.." ] Dealer Arme Sandy ^7| "..author.." » ^4"

						elseif vRP.isUserInFaction({user_id,"Mecanic"}) then
							tag = "^4[ "..user_id.." ] 🔧Mecanic🔧 ^7| "..author.." » ^4"
						elseif vRP.isUserInFaction({user_id,"Taxi"}) then
							tag = "^3[ "..user_id.." ] 🚕Taxi🚕 ^7| "..author.." » ^3"
						else
							tag = "[ "..user_id.." ] Civil | "..author.." » "
						end
						TriggerClientEvent('chatMessage', -1, tag.." "..message)
						cooldownChat(user_id)
						print("[ "..user_id.." ] ", author.." » "..message)
						--PerformHttpRequest(chatwebhook, function(err, text, headers) end, 'POST', json.encode({username = "[ "..user_id.." ] "..author, content = message}), { ['Content-Type'] = 'application/json' })
					else
						TriggerClientEvent('chatMessage', source, "[^5Aries^0] Asteapta ^5"..cooldownTime.." ^0secunde pentru a putea trimite alt mesaj!")
					end
				else
					TriggerClientEvent('chatMessage', source, "^1[Mute] ^0Se pare ca nu te-ai comportat frumos pe chat si ai primit ^1mute. ^0Acesta expira in ^1"..math.floor(tonumber(timpmute[user_id]/60000)).." ^0minute")
				end
			end
		end
	end
end)

function daicumute(user_id, type)
	if(type)then
		--[[if timpmutevoice[user_id] ~= nil then
			Wait(timpmutevoice[user_id])
			timpmutevoice[user_id] = nil
			mutevoice[user_id] = nil
		end]]
	else
		if timpmute[user_id] ~= nil then
			Wait(timpmute[user_id])
			timpmute[user_id] = nil
			mute[user_id] = nil
		end
	end
end

RegisterCommand('mute', function(source, args, rawCommand)
	if source == 0 then
		if(args[1] == nil)then
			print("Pune Bro Un ID")
		else
			local user_id = tonumber(args[1])
			local guy = vRP.getUserSource({user_id})
			if guy ~= nil then
				if mute[user_id] == true then
					timpmute[user_id] = nil
					mute[user_id] = nil
					TriggerClientEvent('chatMessage', -1, "^1[Mute] ^0Se pare ca ^1"..vRP.getPlayerName({vRP.getUserSource({user_id})}).."^0 a primit unmute de la ^1Consola")
				else
					if args[2] ~= nil then
						timpmute[user_id] = tonumber(args[2])*60000
						mute[user_id] = true
						TriggerClientEvent('chatMessage', -1, "^1[Mute] ^0Se pare ca ^1"..vRP.getPlayerName({vRP.getUserSource({user_id})}).."^0 a primit mute de la ^1Consola ^0timp de ^1"..tonumber(args[2]).." ^0minute")
						daicumute(user_id, false)
					else
						print("Pune Bro Minutele")
					end
				end
			else
				print("Jucator Offline")
			end
		end
	elseif source ~= nil then
		local user_id = vRP.getUserId({source})
		if user_id ~= nil then
			if(args[1] == nil)then
				TriggerClientEvent('chatMessage', source, "^1SYNTAXA: /"..rawCommand.." [ID] [MINUTE]") 
			else
				if vRP.isUserTrialHelper({user_id}) then
					local target_id = tonumber(args[1])
					local guy = vRP.getUserSource({target_id})
					if guy ~= nil then
						if mute[target_id] == true then
							timpmute[target_id] = nil
							mute[target_id] = nil
							TriggerClientEvent('chatMessage', -1, "^1[Mute] ^0Se pare ca ^1"..vRP.getPlayerName({vRP.getUserSource({target_id})}).."^0 a primit unmute de la ^1"..vRP.getPlayerName({source}))
						else
							if args[2] ~= nil then
								timpmute[target_id] = tonumber(args[2])*60000
								mute[target_id] = true
								TriggerClientEvent('chatMessage', -1, "^1[Mute] ^0Se pare ca ^1"..vRP.getPlayerName({vRP.getUserSource({target_id})}).."^0 a primit mute de la ^1"..vRP.getPlayerName({source}).." ^0timp de ^1"..tonumber(args[2]).." ^0minute")
								daicumute(target_id, false)
							end
						end
					else
						vRPclient.notify(source,{"[~b~Aries~w~] ~r~Jucatorul nu este pe server!"})
					end
				end
			end
		end
	end
end, false)

AddEventHandler('__cfx_internal:commandFallback', function(command)
    local name = GetPlayerName(source)

    TriggerEvent('chatMessage', source, name, '/' .. command)

    if not WasEventCanceled() then
		local user_id = vRP.getUserId({source})
		local player = vRP.getUserSource({user_id})
		local pName = GetPlayerName(player)
		local author = "["..user_id.."] "..name
		--local theTag = vRPsp.getSponsorTag({user_id})
		message = "/"..command
    end

    CancelEvent()
end)

RegisterCommand('clear', function(source)
    local user_id = vRP.getUserId({source});
    if user_id ~= nil then
        if vRP.isUserHelper({user_id}) then
            TriggerClientEvent("chat:clear", -1);
            TriggerClientEvent("chatMessage", -1, "^7Server^0: Adminul ^7".. GetPlayerName(source) .."^7 a sters tot chat-ul.");
        else
            TriggerClientEvent("chatMessage", source, "^1Eroare^0: Nu ai acces la aceasta comanda.");
        end
    end
end)

RegisterCommand("car", function(source, args)
	local user_id = vRP.getUserId({source})
	local player = vRP.getUserSource{user_id}
	if user_id ~= nil then
		if vRP.isUserAdmin({user_id}) then
			if args[1] ~= nil then
				vRPclient.spawnVehicle(player,"adder")
			else
				vRPclient.notify(player,{"Model invalid!"})
			end
		else
			vRPclient.notify(player,{"Nu ai acces!"})
		end
	end
end, false)

RegisterCommand("stats",function(thePlayer,args)
	local user_id = vRP.getUserId({thePlayer})
		local id = parseInt(args[1])
		if id ~= nil then
			exports.ghmattimysql:execute('SELECT * FROM `vrp_users` WHERE id = @uid',{ ["@uid"] = id},function(rows)
				if #rows > 0 then
					nume = rows[1].username
					last_login = rows[1].last_login
					aJailTime = rows[1].aJailTime
					aJailReason = rows[1].aJailReason
					adminLvl = rows[1].adminLvl
					vipLvl = rows[1].vipLvl
					clanuri = rows[1].clan

					walletMoney = rows[1].walletMoney
					bankMoney = rows[1].bankMoney
					hoursPlayed = rows[1].hoursPlayed
					faction = rows[1].faction
					factionRank = rows[1].factionRank
					ariesCoins = rows[1].krCoins

					TriggerClientEvent("chatMessage", thePlayer, "^5" .. nume .. " ^0(" .. id .. ") | Ore jucate: ^5" .. hoursPlayed .. " ^0| Admin Level: ^5" .. adminLvl .. "")
					TriggerClientEvent("chatMessage", thePlayer, "^5Account: ^0Bani Cash: ^5" .. vRP.formatMoney({tonumber(walletMoney)}) .. "$ ^0| Bani Bancar: ^5" .. vRP.formatMoney({tonumber(bankMoney)}) .. "$" .. " ^0| Aries Coins: ^5" .. ariesCoins)
					TriggerClientEvent("chatMessage", thePlayer, "^5Faction: ^0Factiune: ^5" .. faction .. " ^0| Rank Factiune: ^5".. factionRank.." ^0")
					TriggerClientEvent("chatMessage", thePlayer, "^5General: ^0VIP Level: ^5"..vipLvl.."")	
				else
					TriggerClientEvent('chatMessage',thePlayer,"^5[Aries Romania] ^0Acest jucator nu a fost gasit in baza de date!")
				end
			end)
		else
			TriggerClientEvent('chatMessage',thePlayer,"^5[Aries Romania] /info ^0<id>")
		end
	end)

	RegisterCommand("arevivearea", function(source,args)
		local user_id = vRP.getUserId({source})
		local src = vRP.getUserSource({user_id})
		local radius = args[1]
		radius = radius or 5
		local name = GetPlayerName(src)
		if vRP.isUserTrialHelper({user_id}) then 
				vRPclient.getNearestPlayers(src,{tonumber(radius)}, function(nplayers)
					for k,v in pairs(nplayers) do 
						vRPclient.varyHealth(k,{100})
						vRPclient.notify(k,{"~b~[ADMIN-REVIVE]\n~w~Ai primit revive de la adminul ~b~" .. name})
					end
				end)
				-- TriggerClientEvent("chatMessage",-1,"^5[Aries Romania] ^0Adminul ^5" .. name ..  " ^0a dat revive pe o raza de ^5" .. radius .. " ^0metri")
			else
				TriggerClientEvent('chatMessage',source,"^5[Aries Romania] ^0Nu ai acces la aceasta comanda!")
		end
	end)

RegisterCommand("respawn", function(player, args)
	local user_id = vRP.getUserId({player})
        if vRP.isUserTrialHelper({user_id}) then
		local target_id = parseInt(args[1])
		local target_src = vRP.getUserSource({target_id})
		if target_src then
			vRPclient.teleport(target_src, {-542.86126708984,-207.70722961426,37.649787902832})
			TriggerClientEvent("chatMessage", target_src, "^1Info^7: Respawned by admin")
			vRP.sendStaffMessage({"^0Admin-ul ^8"..GetPlayerName(player).." ^0i-a dat respawn lui ^8"..GetPlayerName(target_src)})
		else
			TriggerClientEvent("chatMessage", player, "^1Syntax^7: /respawn <user_id>")
		end
	else
		TriggerClientEvent("chatMessage", player, "^1Eroare^7: Nu ai acces la aceasta comanda")
	end
end, false)

RegisterCommand('say', function(source, args, rawCommand)
	if(source == 0)then
		TriggerClientEvent('chatMessage', -1, "[CONSOLA]", { 255, 0, 0 }, rawCommand:sub(5))
	end
end)

RegisterCommand('a', function(source, args, rawCommand)
	local user_id = vRP.getUserId({source})
	if user_id ~= nil then
		if(args[1] == nil)then
			TriggerClientEvent('chatMessage', source, "^1SYNTAXA: /"..rawCommand.." [MESAJ]") 
		else
			if(vRP.isUserTrialHelper({user_id}))then
				local users = vRP.getUsers({})
				for uID, ply in pairs(users) do
					if vRP.isUserTrialHelper({uID}) then
						TriggerClientEvent('chatMessage', ply, "^0[^1STAFF CHAT^0] ^6"..vRP.getPlayerName({source}).." ("..user_id..") » ^1" ..rawCommand:sub(2))
					end
				end
			end
		end
	end    
end)

RegisterCommand("arevive",function(source,args)
	local thePlayer = source
	local user_id = vRP.getUserId({thePlayer})
	local playerName = GetPlayerName(thePlayer)
	local isAdmin = vRP.isUserTrialHelper({user_id})
	local thePlayers = vRP.getUsers({})
	if (isAdmin) then
		local id = args[1]
		if parseInt(id) > 0 then
			local nuser_id = parseInt(id)
			local nplayer = vRP.getUserSource({nuser_id})
			if nplayer then
				vRPclient.isInComa(nplayer,{}, function(in_coma)
					if in_coma then
						nplayername = GetPlayerName(nplayer)
						-- vRP.addNewLog({user_id, 4, "ARevive -> "..playerName.." -> "..nplayername})
						vRP.sendStaffMessage({"^1ARevive^0: "..playerName.." -> "..nplayername..""})
						vRPclient.notify(nplayer,{"I-ai dat revive lui ~g~"..nplayername})
						vRPclient.notify(nplayer,{"Ai primit revive de la adminul ~g~"..playerName})
						
						vRP.setThirst({user_id,0})
						vRP.setHunger({user_id,0})
						vRPclient.varyHealth(nplayer,{200})
					else
						vRP.setThirst({user_id,0})
						vRP.setHunger({user_id,0})
						vRPclient.varyHealth(nplayer,{200})
						TriggerClientEvent("chatMessage",thePlayer,"^1Eroare:^0 Acest jucator nu este mort, dar i s-a refacut viata!")
					end
				end)
			else
				TriggerClientEvent("chatMessage",thePlayer,"^1Eroare:^0 Acest jucator nu este online!")
			end
		elseif tostring(id) == "all" then
			TriggerClientEvent("chatMessage",-1,"^1ARevive^0: Adminul ^1"..playerName.."^0 a dat revive la tot serverul!")
			-- vRP.addNewLog({user_id, 4, "ARevive -> "..playerName.." -> a dat revive la tot serverul!"})
			for k,v in pairs(thePlayers)do

				thePlayersIds = v
				theIDs = k
				vRPclient.isInComa(thePlayers,{}, function(in_coma)
					if in_coma then
						vRPclient.revive(thePlayersIds,{})
						vRPclient.notify(thePlayersIds,{"Ai primit revive de la adminul ~g~"..playerName})
					end
				end)
			end
		end
	else
		TriggerClientEvent("chatMessage",thePlayer,"^1Eroare:^0 Nu ai acces la aceasta comanda!")
	end
end)

RegisterCommand("rev",function(source,args)

	local thePlayer = source

	local user_id = vRP.getUserId({thePlayer})

	local playerName = GetPlayerName(thePlayer)

	local isAdmin = vRP.isUserTrialHelper({user_id})

	local thePlayers = vRP.getUsers({})


	if (isAdmin) then

		local id = args[1]

		local motiv = args[2]

		if id ~= nil then

			if motiv ~= nil then

				if parseInt(id) > 0 then

				local nuser_id = parseInt(id)

				local nplayer = vRP.getUserSource({nuser_id})

				if nplayer then

					vRPclient.isInComa(nplayer,{}, function(in_coma)

						if in_coma then

							nplayername = GetPlayerName(nplayer)

							vRP.sendStaffMessage({"^1ARevive ^0: "..playerName.." -> "..nplayername.." | Motiv : ".. motiv .. ""})

						else
							TriggerClientEvent("chatMessage",thePlayer,"^1Eroare:^0 Acest jucator nu este mort!")
					
						end
					
					end)
				else

					
					TriggerClientEvent("chatMessage",thePlayer,"^1Eroare:^0 Acest jucator nu este online!")
				end

			
			elseif tostring(id) == "all" then
			
				TriggerClientEvent("chatMessage",-1,"^1ARevive^0: Adminul ^1"..playerName.."^0 a dat revive la tot serverul!")
			
				for k,v in pairs(thePlayers)do
	
					theIDs = k
				
					vRPclient.isInComa(v,{}, function(in_coma)
					
						if in_coma then

							vRPclient.varyHealth(v,{200})
					
							vRPclient.notify(v,{"Ai primit revive de la adminul ~g~"..playerName})

						end

					end)

				end

			end

		else

			TriggerClientEvent("chatMessage",thePlayer,"^1Syntax^0: /rev <ID/all> <motiv>")

		end

	end

else

	TriggerClientEvent("chatMessage",thePlayer,"^1Eroare:^0 Nu ai acces la aceasta comanda!")

end

end)

RegisterCommand("goevent", function(player)
    if eventOn then
        vRPclient.teleport(player, {evCoords[1], evCoords[2], evCoords[3]})
        TriggerClientEvent("zedutz:setFreeze", player, true)
    else
        TriggerClientEvent("chatMessage", player, "^1[Eroare]^7: Nu exista nici un eveniment activ")
    end
end, false)

RegisterCommand("startevent", function(player)
    local user_id = vRP.getUserId({player})
    if vRP.isUserAdmin({user_id}) then
        if eventOn then
            evCoords = {}
            eventOn = false
            TriggerClientEvent("chatMessage", -1, "^1Event^0: Event-ul a inceput. Jucatorii nu mai pot folosi comanda /goevent. Mult succes tuturor!")
        else
            TriggerClientEvent("chatMessage", player, "^1Eroare^0: Nu exista nici un eveniment activ!")
        end
    else
        TriggerClientEvent("chatMessage", player, "^1Eroare^0: Nu ai acces la aceasta comanda")
    end
end, false)


RegisterCommand("event", function(player)
    local user_id = vRP.getUserId({player})
    if vRP.isUserAdmin({user_id}) then
        if not eventOn then
            vRPclient.getPosition(player, {}, function(x, y, z)
                evCoords = {x, y, z + 0.5}
            end)
            eventOn = true
            TriggerClientEvent("chatMessage", -1, "^1[Event]^0: Adminul "..vRP.getPlayerName({player}).." a pornit un eveniment ! Foloseste </goevent> pentru a da tp acolo")

        end
    else
        TriggerClientEvent("chatMessage", player, "^1[Eroare]^7: Nu ai acces la aceasta comanda")
    end
end, false)

RegisterCommand("tptowp", function(player)
    local user_id = vRP.getUserId({player})
    if vRP.isUserTrialHelper({user_id}) then
		TriggerClientEvent("TpToWaypoint", player)
    else
        TriggerClientEvent("chatMessage", player, "^1[Eroare]^7: Nu ai acces la aceasta comanda")
    end
end, false)


RegisterCommand("bonus", function(source,args)
	local howMuch = tonumber(args[1])
	local user_id = vRP.getUserId({source})
	if(howMuch ~= nil and howMuch > 0)then
		if vRP.isUserSmecher({user_id}) then
			
			local users = vRP.getUsers({})
			TriggerClientEvent("chatMessage",-1,"^1[BONUS] ^2Administratorul ^1"..GetPlayerName(source).."^2 a dat un bonus de ^1"..vRP.formatMoney({tonumber(howMuch)}).."$^2 la tot serverul!")
			for luigi,milsuge in pairs(users)do
				id = luigi
				vRP.giveBankMoney({id,tonumber(howMuch)})
			end

		else
			vRPclient.notify(source,{"~r~Nu esti Fondator pentru a folosi aceasta comanda, incearca alta data."})	
		end
	else
		vRPclient.notify(source,{"~r~Nu ai scris suma de bani!"})
	end
end)


RegisterCommand('ore',function(thePlayer,args)
	local user_id = vRP.getUserId({thePlayer})
	local nid = args[1]
	if nid == nil then
		TriggerClientEvent('chatMessage',thePlayer,'^1Ore: ^0In momentul de fata ai ^1'..vRP.getUserHoursPlayed({user_id})..'^0 ore jucate.')
	else
		nid = parseInt(args[1])
		nplayer = vRP.getUserSource({nid})
		if nplayer then
			TriggerClientEvent('chatMessage',thePlayer,'^1Ore: ^1'..GetPlayerName(nplayer)..'^0 are ^1'..vRP.getUserHoursPlayed({nid})..'^0 ore jucate.')
		end
	end
end)

RegisterCommand("noclip", function(player)
	local user_id = vRP.getUserId({player})
	if vRP.isUserAdmin({user_id}) then
		vRPclient.toggleNoclip(player, {})
	else
		TriggerClientEvent("chatMessage", player, "^1Eroare^0: Nu ai acces la aceasta comanda.")
	end
end)

RegisterCommand("tpto", function(player, args)
	local user_id = vRP.getUserId({player})
	if vRP.isUserTrialHelper({user_id}) then
		if args[1] and args[1] ~= "" then
			local target_id = parseInt(args[1])
			local target_src = vRP.getUserSource({target_id})
			if target_src then
				vRPclient.getPosition(target_src, {}, function(x, y, z)
					vRPclient.teleport(player, {x, y, z})
					vRPclient.notify(player, {"Te-ai teleportat la "..vRP.getPlayerName({target_src}).." ["..target_id.."]"})
					vRPclient.notify(target_src, {"Adminul "..vRP.getPlayerName({player}).." ["..user_id.."] s-a teleportat la tine"})
				end)
			else
				TriggerClientEvent("chatMessage", player, "^1Eroare^7: Jucatorul nu este conectat !")
			end
		else
			TriggerClientEvent("chatMessage", player, "^1Syntax^7: /tpto <user_id>")
		end
	else
		TriggerClientEvent("chatMessage", player, "^1Eroare^7: Nu ai acces la aceasta comanda !")
	end
end, false)

RegisterCommand("tptome", function(player, args)
	local user_id = vRP.getUserId({player})
	if vRP.isUserTrialHelper({user_id}) then
		if args[1] and args[1] ~= "" then
			local target_id = parseInt(args[1])
			local target_src = vRP.getUserSource({target_id})
			if target_src then
				vRPclient.getPosition(player, {}, function(x, y, z)
					vRPclient.teleport(target_src, {x, y, z})
					vRPclient.notify(player, {"L-ai teleportat la tine pe "..vRP.getPlayerName({target_src}).." ["..target_id.."]"})
					vRPclient.notify(target_src, {"Adminul "..vRP.getPlayerName({player}).." ["..user_id.."] te-a teleportat la el"})
				end)
			else
				TriggerClientEvent("chatMessage", player, "^1Eroare^7: Jucatorul nu este conectat !")
			end
		else
			TriggerClientEvent("chatMessage", player, "^1Syntax^7: /tptome <user_id>")
		end
	else
		TriggerClientEvent("chatMessage", player, "^1Eroare^7: Nu ai acces la aceasta comanda !")
	end
end, false)

RegisterCommand('car', function(player, args)
	local user_id = vRP.getUserId({player})
	model = tostring(args[1])

	if vRP.isUserAdmin({user_id}) then
		if model ~= nil and model ~= "" then
			vRPclient.spawnVehicle(player,{model})
		else
			vRPclient.notify(player,{"~r~Trebuie sa pui un model de vehicul."})
		end
	else
		TriggerClientEvent("chatMessage", player, "^1Eroare^7: Nu ai acces la aceasta comanda !")
	end
end)
