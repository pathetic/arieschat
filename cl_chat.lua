local isRDR = not TerraingridActivate and true or false

    local chatInputActive = false
    local chatInputActivating = false
    local chatHidden = true
    local chatLoaded = false
    local message_number = 0
    
    
    RegisterNetEvent("seeeeend")
    RegisterNetEvent('chatMessage')
    RegisterNetEvent('chat:addTemplate')
    RegisterNetEvent('chat:addMessage')
    RegisterNetEvent('chat:addSuggestion')
    RegisterNetEvent('chat:addSuggestions')
    RegisterNetEvent('chat:removeSuggestion')
    RegisterNetEvent('chat:clear')
    RegisterNetEvent('chat:old')
    AddEventHandler('chat:old', function()
      SendNUIMessage({
        type = 'SHOW_OLD'
      })
    end)
    
    -- internal events
    RegisterNetEvent('__cfx_internal:serverPrint')
    
    RegisterNetEvent('_chat:muitzaqmessageEntered')
    
    AddEventHandler("seeeeend", function(source)
      PlaySound(source,"Event_Message_Purple","GTAO_FM_Events_Soundset",0,0,1)
    -- PlaySound(source,"QUIT","HUD_FRONTEND_DEFAULT_SOUNDSET",0,0,1)
    
    end)
    --deprecated, use chat:addMessage
    AddEventHandler('chatMessage', function(author, color, text,pid, entryPlayer)
      local args = { text }
      if author ~= "" then
        table.insert(args, 1, author)
      end
      local myMessage = false
      if GetPlayerServerId(PlayerId()) == entryPlayer then
        myMessage = true
      end
      message_number = message_number + 1
      SendNUIMessage({
        type = 'ON_MESSAGE',
        id = pid,
        message = {
          messageId = message_number,
          myMessage = myMessage,
          isEdit = false,
          playerId = pid,
          color = color,
          multiline = true,
          args = args
        }
      })
    end)
    
    
    
    AddEventHandler('chat:addMessage', function(message)
      SendNUIMessage({
        type = 'ON_MESSAGE',
        message = message
      })
    end)
    
    AddEventHandler('chat:addSuggestion', function(name, help, params)
      SendNUIMessage({
        type = 'ON_SUGGESTION_ADD',
        suggestion = {
          name = name,
          help = help,
          params = params or nil
        }
      })
    end)
    
    AddEventHandler('chat:addSuggestions', function(suggestions)
      for _, suggestion in ipairs(suggestions) do
        SendNUIMessage({
          type = 'ON_SUGGESTION_ADD',
          suggestion = suggestion
        })
      end
    end)
    
    AddEventHandler('chat:removeSuggestion', function(name)
      SendNUIMessage({
        type = 'ON_SUGGESTION_REMOVE',
        name = name
      })
    end)
    
    AddEventHandler('chat:addTemplate', function(id, html)
      SendNUIMessage({
        type = 'ON_TEMPLATE_ADD',
        template = {
          id = id,
          html = html
        }
      })
    end)
    
    AddEventHandler('chat:clear', function(name)
      SendNUIMessage({
        type = 'ON_CLEAR'
      })
    end)
    
    RegisterNUICallback('chatResult', function(data, cb)
      chatInputActive = false
      SetNuiFocus(false)
      if not data.canceled then
        local id = PlayerId()
        local r, g, b = 0, 0x99, 255
        if data.message:sub(1, 1) == '/' then
          ExecuteCommand(data.message:sub(2))
        else
          TriggerServerEvent('_chat:muitzaqmessageEntered', GetPlayerName(id), { r, g, b }, data.message)
        end
      end
      cb('ok')
    end)
    
    local function refreshCommands()
      if GetRegisteredCommands then
        local registeredCommands = GetRegisteredCommands()
    
        local suggestions = {}
    
        for _, command in ipairs(registeredCommands) do
            if IsAceAllowed(('command.%s'):format(command.name)) then
                table.insert(suggestions, {
                    name = '/' .. command.name,
                    help = ''
                })
            end
        end
    
        TriggerEvent('chat:addSuggestions', suggestions)
      end
    end
    
    local function refreshThemes()
      local themes = {}
    
      for resIdx = 0, GetNumResources() - 1 do
        local resource = GetResourceByFindIndex(resIdx)
    
        if GetResourceState(resource) == 'started' then
          local numThemes = GetNumResourceMetadata(resource, 'chat_theme')
    
          if numThemes > 0 then
            local themeName = GetResourceMetadata(resource, 'chat_theme')
            local themeData = json.decode(GetResourceMetadata(resource, 'chat_theme_extra') or 'null')
    
            if themeName and themeData then
              themeData.baseUrl = 'nui://' .. resource .. '/'
              themes[themeName] = themeData
            end
          end
        end
      end
    
      SendNUIMessage({
        type = 'ON_UPDATE_THEMES',
        themes = themes
      })
    end
    
    AddEventHandler('onClientResourceStart', function(resName)
      Wait(500)
    
      refreshCommands()
      refreshThemes()
    end)
    
    AddEventHandler('onClientResourceStop', function(resName)
      Wait(500)
    
      refreshCommands()
      refreshThemes()
    end)
    
    RegisterNUICallback('loaded', function(data, cb)
      TriggerServerEvent('chat:init');
    
      refreshCommands()
      refreshThemes()
    
      chatLoaded = true
    
      cb('ok')
    end)
    
    Citizen.CreateThread(function()
      SetTextChatEnabled(false)
      SetNuiFocus(false, false)
    
      while true do
        Wait(0)
    
        if not chatInputActive then
          if IsControlPressed(0, isRDR and `INPUT_MP_TEXT_CHAT_ALL` or 245) then
            chatInputActive = true
            chatInputActivating = true
    
            SendNUIMessage({
              type = 'ON_OPEN'
            })
          end
        end
    
        if chatInputActivating then
          if not IsControlPressed(0, isRDR and `INPUT_MP_TEXT_CHAT_ALL` or 245) then
            SetNuiFocus(true, true)
    
            chatInputActivating = false
          end
        end
    
        if chatLoaded then
          local shouldBeHidden = false
    
          if IsScreenFadedOut() or IsPauseMenuActive() then
            shouldBeHidden = true
          end
    
          if (shouldBeHidden and not chatHidden) or (not shouldBeHidden and chatHidden) then
            chatHidden = shouldBeHidden
    
            SendNUIMessage({
              type = 'ON_SCREEN_STATE_CHANGE',
              shouldHide = shouldBeHidden
            })
          end
        end
      end
    end)
    
    
    --// ENABLE CHAT KICK
    RegisterNetEvent('CL:EnableChatKick')
    AddEventHandler('CL:EnableChatKick',function()
      SendNUIMessage({
        type = 'CHAT_KICK'
      })
    end)
    
    --// SEND MONEY FROM SERVER
    RegisterNetEvent('CL:EnableChatTransfer')
    AddEventHandler('CL:EnableChatTransfer',function()
      SendNUIMessage({
        type = 'CHAT_TRANSFER'
      })
    end)
    
    --// SEND MONEY FRM NUI
    RegisterNUICallback('transferMoney', function(data, cb)
      SetNuiFocus(false,false)
      chatInputActive = false
      chatInputActivating = false
      chatHidden = true
      SendNUIMessage({
          type = 'ON_EXIT'
      }) 
      
      Wait(100)
      TriggerServerEvent('SV:TransferMoney',data.targetID)
    end)
    
    --// CANCEL EDIT MSG
    RegisterNUICallback('cancelchangeMessage', function(data, cb)
      SetNuiFocus(false,false)
      chatInputActive = false
      chatInputActivating = false
      chatHidden = true
      SendNUIMessage({
        type = 'CANCEL_EDIT'
    }) 
    --TriggerEvent("RAR:Alerts", {type = "error",position = "right",text = "تم الغاء تعديل رسالتك",time =  3000,anamtion =  "fadeIn",coloricon = "white",icon = "fas fa-edit"})
    
    end)
    
    --// KICK PLAYER FROM NUI TO SERVER
    RegisterNUICallback('PlayerKick', function(data, cb)
      SendNUIMessage({
          type = 'ON_EXIT'
      }) 
      Wait(1)
      TriggerServerEvent('SV:PlayerKick',data.targetID)
    end)
    
    --// MUTE PLAYER FROM NUI
    RegisterNUICallback('mutechat', function(data, cb)
      SetNuiFocus(false,false)
      chatInputActive = false
      chatInputActivating = false
      chatHidden = true
      SendNUIMessage({
          type = 'ON_EXIT'
      }) 
      Wait(100)
     -- TriggerServerEvent('SV:MuteChatPlayer',data.targetID)
    end)
    
    --// ENABLE MUTE PLAYER
    RegisterNetEvent('CL:EnableChatMute')
    AddEventHandler('CL:EnableChatMute',function()
      SendNUIMessage({
        type = 'CHAT_MUTE'
      })
    end)
    
    --// CHANGE MSG FOR ALL NUI
    RegisterNUICallback('editMessage', function(data, cb)
      SendNUIMessage({
        type = 'ON_EDIT',
        messageId = data.messageId,
        playerId = data.playerId
      }) 
    
    end)
    
    --// CHANGE MSG FOR ALL SERVER
    RegisterNUICallback('editMessageResult', function(data, cb)
      SetNuiFocus(false,false)
      chatInputActive = false
      chatInputActivating = false
      chatHidden = true
      TriggerServerEvent('SV:editMessage', data)
    end)
    
    --// CHANGE MSG FOR CLIENT
    RegisterNetEvent('CL:changeMessage')
    AddEventHandler('CL:changeMessage',function(data)
      SendNUIMessage({
        type = 'ON_EDIT_MESSAGE',
        messageId = data.messageId,
        playerId = data.playerId,
        message = data.message,
        isEdit = false
      })
    
    end)

    RegisterCommand("grafica",function(source, args)
      if not realismon then
        SetTimecycleModifier("BulletTimeDark")
        SetTimecycleModifierStrength(0.4)
        realismon = true
      else
        SetTimecycleModifier()
        realismon = false
      end
    end,false)