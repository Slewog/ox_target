if GetConvarInt('ox_target:defaults', 1) ~= 1 then return end

local api = require 'client.api'
local GetEntityBoneIndexByName = GetEntityBoneIndexByName
local GetEntityBonePosition_2 = GetEntityBonePosition_2
local GetVehicleDoorLockStatus = GetVehicleDoorLockStatus

local function toggleDoor(vehicle, door)
    if GetVehicleDoorLockStatus(vehicle) ~= 2 then
        if GetVehicleDoorAngleRatio(vehicle, door) > 0.0 then
            SetVehicleDoorShut(vehicle, door, false)
        else
            SetVehicleDoorOpen(vehicle, door, false, false)
        end
    end
end

api.addGlobalVehicle({
    {
        name = 'ox_target:driverF',
        icon = 'fa-solid fa-car-side',
        label = locale('toggle_front_driver_door'),
        bones = { 'door_dside_f', 'seat_dside_f' },
        canInteract = function(entity, distance, coords, name)
            if GetVehicleDoorLockStatus(entity) > 1 then return end

            local boneId = GetEntityBoneIndexByName(entity, 'door_dside_f')

            if IsVehicleDoorDamaged(entity, 0) then return end

            if boneId ~= -1 then
                return #(coords - GetEntityBonePosition_2(entity, boneId)) < 0.5 or
                    #(coords - GetEntityBonePosition_2(entity, GetEntityBoneIndexByName(entity, 'seat_dside_f'))) < 0.72
            end
        end,
        onSelect = function(data)
            toggleDoor(data.entity, 0)
        end
    },
    {
        name = 'ox_target:passengerF',
        icon = 'fa-solid fa-car-side',
        label = locale('toggle_front_passenger_door'),
        bones = { 'door_pside_f', 'seat_pside_f' },
        canInteract = function(entity, distance, coords, name)
            if GetVehicleDoorLockStatus(entity) > 1 then return end

            local boneId = GetEntityBoneIndexByName(entity, 'door_pside_f')
            if IsVehicleDoorDamaged(entity, 1) then return end

            if boneId ~= -1 then
                return #(coords - GetEntityBonePosition_2(entity, boneId)) < 0.5 or
                    #(coords - GetEntityBonePosition_2(entity, GetEntityBoneIndexByName(entity, 'seat_pside_f'))) < 0.72
            end
        end,
        onSelect = function(data)
            toggleDoor(data.entity, 1)
        end
    },
    {
        name = 'ox_target:driverR',
        icon = 'fa-solid fa-car-side',
        label = locale('toggle_rear_driver_door'),
        bones = { 'door_dside_r', 'seat_dside_r' },
        canInteract = function(entity, distance, coords, name)
            if GetVehicleDoorLockStatus(entity) > 1 then return end

            local boneId = GetEntityBoneIndexByName(entity, 'door_dside_r')
            if IsVehicleDoorDamaged(entity, 2) then return end

            if boneId ~= -1 then
                return #(coords - GetEntityBonePosition_2(entity, boneId)) < 0.5 or
                    #(coords - GetEntityBonePosition_2(entity, GetEntityBoneIndexByName(entity, 'seat_dside_r'))) < 0.72
            end
        end,
        onSelect = function(data)
            toggleDoor(data.entity, 2)
        end
    },
    {
        name = 'ox_target:seatDriverR',
        icon = 'fa-solid fa-person-walking-arrow-right',
        label = locale('seat_rear_driver'),
        bones = {'seat_dside_r'},
        canInteract = function(entity, distance, coords, name)
            if distance > 0.9 then return false end
            if GetVehicleDoorLockStatus(entity) == 2 then return false end

            return GetEntityBoneIndexByName(entity, 'door_dside_r') ~= -1 and (IsVehicleSeatFree(entity, 2) or IsVehicleSeatFree(entity, 1))
        end,
        onSelect = function(data)
            if IsVehicleSeatFree(data.entity, 1) then
                TaskEnterVehicle(PlayerPedId(), data.entity, 10000, 1, 1.0, 1, 0)
            else
                TaskEnterVehicle(PlayerPedId(), data.entity, 10000, 2, 1.0, 1, 0)
            end
        end
    },
    {
        name = 'ox_target:passengerR',
        icon = 'fa-solid fa-car-side',
        label = locale('toggle_rear_passenger_door'),
        bones = { 'door_pside_r', 'seat_pside_r' },
        canInteract = function(entity, distance, coords, name)
            if GetVehicleDoorLockStatus(entity) > 1 then return end

            local boneId = GetEntityBoneIndexByName(entity, 'door_pside_r')
            if IsVehicleDoorDamaged(entity, 3) then return end

            if boneId ~= -1 then
                return #(coords - GetEntityBonePosition_2(entity, boneId)) < 0.5 or
                    #(coords - GetEntityBonePosition_2(entity, GetEntityBoneIndexByName(entity, 'seat_pside_r'))) < 0.72
            end
        end,
        onSelect = function(data)
            toggleDoor(data.entity, 3)
        end
    },
    {
        name = 'ox_target:seatPassengerR',
        icon = 'fa-solid fa-person-walking-arrow-right',
        label = locale('seat_rear_passenger'),
        bones = {'seat_pside_r'},
        canInteract = function(entity, distance, coords, name)
            if distance > 0.9 then return false end
            if GetVehicleDoorLockStatus(entity) == 2 then return end

            return GetEntityBoneIndexByName(entity, 'door_pside_r') ~= 1 and (IsVehicleSeatFree(entity, 2) or IsVehicleSeatFree(entity, 1))
        end,
        onSelect = function(data)
            if IsVehicleSeatFree(data.entity, 2) then
                TaskEnterVehicle(PlayerPedId(), data.entity, 10000, 2, 1.0, 1, 0)
            else
                TaskEnterVehicle(PlayerPedId(), data.entity, 10000, 1, 1.0, 1, 0)
            end
        end
    },
    {
        name = 'ox_target:bonnet',
        icon = 'fa-solid fa-car',
        label = locale('toggle_hood'),
        bones = 'bonnet',
        canInteract = function(entity, distance, coords, name, boneId)
            if GetVehicleDoorLockStatus(entity) > 1 then return end
            if IsVehicleDoorDamaged(entity, 4) then return end
            return #(coords - GetEntityBonePosition_2(entity, boneId)) < 0.9
        end,
        onSelect = function(data)
            toggleDoor(data.entity, 4)
        end
    },
    {
        name = 'ox_target:trunk',
        icon = 'fa-solid fa-car-rear',
        label = locale('toggle_trunk'),
        bones = 'boot',
        canInteract = function(entity, distance, coords, name, boneId)
            if GetVehicleDoorLockStatus(entity) > 1 then return end
            if IsVehicleDoorDamaged(entity, 5) then return end
            return #(coords - GetEntityBonePosition_2(entity, boneId)) < 0.9
        end,
        onSelect = function(data)
            toggleDoor(data.entity, 5)
        end
    }
})
