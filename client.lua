local currentGarage = nil
local textShown = false
local lastText = nil
local personalVeh = 0
local personalBlip = 0
local lastSeenBlip = 0
local lastSeenCoords = nil

local function removeBlipSafe(b)
  if b and b ~= 0 and DoesBlipExist(b) then
    RemoveBlip(b)
  end
end

local function setLastSeen(coords)
  lastSeenCoords = coords
  removeBlipSafe(lastSeenBlip)

  if coords then
    lastSeenBlip = AddBlipForCoord(coords.x, coords.y, coords.z)
    SetBlipSprite(lastSeenBlip, 225)
    SetBlipScale(lastSeenBlip, 0.85)
    SetBlipColour(lastSeenBlip, 3)
    SetBlipAsShortRange(lastSeenBlip, false)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Your patrol car")
    EndTextCommandSetBlipName(lastSeenBlip)
  end
end

local function setPersonalVehicle(veh)
  removeBlipSafe(personalBlip)
  personalBlip = 0

  if personalVeh ~= 0 and DoesEntityExist(personalVeh) then
    setLastSeen(GetEntityCoords(personalVeh))
  end

  personalVeh = veh or 0

  if personalVeh ~= 0 and DoesEntityExist(personalVeh) then
    SetEntityAsMissionEntity(personalVeh, true, true)
    SetVehicleHasBeenOwnedByPlayer(personalVeh, true)

    personalBlip = AddBlipForEntity(personalVeh)
    SetBlipSprite(personalBlip, 56)
    SetBlipScale(personalBlip, 0.90)
    SetBlipColour(personalBlip, 0)
    SetBlipAsShortRange(personalBlip, false)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Your patrol car")
    EndTextCommandSetBlipName(personalBlip)

    removeBlipSafe(lastSeenBlip)
    lastSeenBlip = 0
    lastSeenCoords = nil
  end
end

local function clearPersonalVehicleState(makeLastSeen)
    removeBlipSafe(personalBlip)
    personalBlip = 0
  
    if makeLastSeen and personalVeh ~= 0 and DoesEntityExist(personalVeh) then
      setLastSeen(GetEntityCoords(personalVeh))
    else
      removeBlipSafe(lastSeenBlip)
      lastSeenBlip = 0
      lastSeenCoords = nil
    end
  
    personalVeh = 0
end

local function showHelp(text)
  if not Config.TextUI?.enabled then return end

  if textShown and lastText == text then return end
  textShown = true
  lastText = text

  lib.showTextUI(text, { position = 'left-center', icon = 'warehouse' })
end

local function hideHelp()
  if not textShown then return end
  textShown = false
  lastText = nil
  lib.hideTextUI()
end

local function requestModel(model)
  local hash = type(model) == "number" and model or joaat(model)
  if not IsModelInCdimage(hash) or not IsModelValid(hash) then return nil end

  RequestModel(hash)
  local timeout = GetGameTimer() + 6000
  while not HasModelLoaded(hash) do
    Wait(0)
    if GetGameTimer() > timeout then return nil end
  end
  return hash
end

local function spawnVehicle(model, spawnCoords, heading)
  local hash = requestModel(model)
  if not hash then
    return lib.notify({ type = 'error', description = ('Kunne ikke loade model: %s'):format(model) })
  end

  if IsAnyVehicleNearPoint(spawnCoords.x, spawnCoords.y, spawnCoords.z, 2.5) then
    SetModelAsNoLongerNeeded(hash)
    return lib.notify({ type = 'error', description = 'Spawn punktet er blokeret.' })
  end

  local veh = CreateVehicle(hash, spawnCoords.x, spawnCoords.y, spawnCoords.z, heading or 0.0, true, false)
  SetModelAsNoLongerNeeded(hash)

  if veh and veh ~= 0 then
    SetVehicleOnGroundProperly(veh)
    SetPedIntoVehicle(cache.ped, veh, -1)
    SetEntityAsMissionEntity(veh, true, true)

    setPersonalVehicle(veh)

    lib.notify({ type = 'success', description = 'Køretøj spawnet.' })
  end
end

local function deleteCurrentVehicle()
    local ped = cache.ped
    local veh = GetVehiclePedIsIn(ped, false)
  
    if veh == 0 then
      local coords = GetEntityCoords(ped)
      veh = GetClosestVehicle(coords.x, coords.y, coords.z, 3.5, 0, 70)
    end
  
    if not veh or veh == 0 then
      return lib.notify({ type = 'error', description = 'Ingen køretøj fundet tæt på.' })
    end
  
    if personalVeh ~= 0 and veh == personalVeh then
      clearPersonalVehicleState(false) 
    end
  
    SetEntityAsMissionEntity(veh, true, true)
    DeleteEntity(veh)
  
    lib.notify({ type = 'success', description = 'Køretøj slettet.' })
end

local function imgUrl(file)
  return ('https://cfx-nui-%s/images/%s'):format(GetCurrentResourceName(), file)
end

local function openGarageMenu(garage)
    currentGarage = garage
  
    local options = {}
  
    for _, v in ipairs(Config.Vehicles) do
      local image = v.image and imgUrl(v.image) or nil
  
      options[#options + 1] = {
        title = v.label or v.model,
        icon = 'car',
        image = image,
        arrow = false,
        onSelect = function()
          spawnVehicle(v.model, garage.spawn.coords, garage.spawn.heading or 0.0)
        end
      }
    end
  
    lib.registerContext({
      id = ('garage:%s'):format(garage.id),
      title = garage.label or 'Garage',
      position = 'top-right',
      options = options
    })
  
    lib.showContext(('garage:%s'):format(garage.id))
end

local function openDeleterMenu(deleter)
  lib.registerContext({
    id = ('deleter:%s'):format(deleter.id),
    title = deleter.label or 'Slet Din Bil',
    position = 'top-right',
    options = {
      {
        title = 'Slet køretøj',
        description = 'Sletter køretøjet du sidder i (eller nærmeste i radius).',
        icon = 'trash',
        onSelect = function()
          local ok = lib.alertDialog({
            header = 'Bekræft sletning',
            content = 'Er du sikker på at du vil slette køretøjet?',
            centered = true,
            cancel = true
          })
          if ok == 'confirm' then
            deleteCurrentVehicle()
          end
        end
      }
    }
  })

  lib.showContext(('deleter:%s'):format(deleter.id))
end

CreateThread(function()
  if not Config.Blips?.enabled then return end

  for _, g in ipairs(Config.Garages) do
    if g.blip then
      local blip = AddBlipForCoord(g.coords.x, g.coords.y, g.coords.z)
      SetBlipSprite(blip, Config.Blips.sprite)
      SetBlipScale(blip, Config.Blips.scale)
      SetBlipColour(blip, Config.Blips.colour)
      SetBlipAsShortRange(blip, true)
      BeginTextCommandSetBlipName("STRING")
      AddTextComponentString(Config.Blips.name or "Garage")
      EndTextCommandSetBlipName(blip)
    end
  end
end)

CreateThread(function()
    while true do
      local ped = cache.ped
      local p = GetEntityCoords(ped)
  
      local sleep = 1000
      local shouldShowText = false
      local textToShow = nil
  
      for _, g in ipairs(Config.Garages) do
        local dist = #(p - g.coords)
  
        if Config.Marker.enabled and dist <= (Config.Marker.drawDist or 25.0) then
          sleep = 0
  
          DrawMarker(
            Config.Marker.type,
            g.coords.x, g.coords.y, g.coords.z - 0.9,
            0.0, 0.0, 0.0,
            0.0, 0.0, 0.0,
            Config.Marker.scale.x, Config.Marker.scale.y, Config.Marker.scale.z,
            255, 255, 255, 140,
            false, true, 2, false, nil, nil, false
          )
        end
  
        if Config.TextUI and dist <= (Config.TextUI.dist or 3.0) then
          shouldShowText = true
          textToShow = ('[E] - Åbn %s'):format(g.label or 'Garage')
  
          if dist <= (g.interactDist or 2.0) and IsControlJustPressed(0, Config.OpenKey) then
            openGarageMenu(g)
          end
        end
      end
  
      for _, d in ipairs(Config.VehicleDeleters or {}) do
        local dist = #(p - d.coords)
  
        if Config.Marker.enabled and dist <= (Config.Marker.drawDist or 25.0) then
          sleep = 0
  
          DrawMarker(
            Config.Marker.type,
            d.coords.x, d.coords.y, d.coords.z - 0.9,
            0.0, 0.0, 0.0,
            0.0, 0.0, 0.0,
            Config.Marker.scale.x, Config.Marker.scale.y, Config.Marker.scale.z,
            255, 80, 80, 140,
            false, true, 2, false, nil, nil, false
          )
        end
  
        if Config.TextUI and dist <= (Config.TextUI.dist or 3.0) then
          shouldShowText = true
          textToShow = '[E] - For at slette din bil'
  
          if dist <= (d.interactDist or 2.0) and IsControlJustPressed(0, Config.OpenKey) then
            openDeleterMenu(d)
          end
        end
      end
  
      if shouldShowText and textToShow then
        showHelp(textToShow)
      else
        hideHelp()
      end
  
      Wait(sleep)
    end
end)

CreateThread(function()
    while true do
      Wait(1000)
  
      if personalVeh ~= 0 then
        if DoesEntityExist(personalVeh) then
          lastSeenCoords = GetEntityCoords(personalVeh)
  
          if lastSeenBlip ~= 0 then
            removeBlipSafe(lastSeenBlip)
            lastSeenBlip = 0
          end
        else
          removeBlipSafe(personalBlip)
          personalBlip = 0
          personalVeh = 0
  
          if lastSeenCoords then
            setLastSeen(lastSeenCoords)
          end
        end
      end
    end
  end)
