local ped = PlayerPedId()
local scale = 0.5 -- Shrink the ped to 10%

-- Helper function to get the right, forward, and up vectors based on the heading
function GetScaledBasisFromHeading(heading, scale)
    local rad = math.rad(heading)
    local sinH = math.sin(rad)
    local cosH = math.cos(rad)

    local right   = { x = -sinH * scale, y = cosH * scale, z = 0.0 }
    local forward = { x = cosH * scale, y = sinH * scale, z = 0.0 }
    local up      = { x = 0.0, y = 0.0, z = 1.0 * scale }

    return right, forward, up
end

CreateThread(function()
    local cam = nil
    while true do
        Wait(0)

        -- Get the ped's position and heading
        local pos = GetEntityCoords(ped, false) -- Get the current position of the ped
        local heading = GetEntityHeading(ped) -- Get the ped's current heading
        local right, forward, up = GetScaledBasisFromHeading(heading, scale)

        -- Ensure the Z position is on the ground
        local _, groundZ = GetGroundZFor_3dCoord(pos.x, pos.y, pos.z, false)
        
        -- If ground Z is valid, set the Z coordinate to it
        if groundZ then
            pos = vector3(pos.x, pos.y, groundZ + scale) -- Add scale to Z position to prevent floating
        end

        -- Reapply the scaled matrix to the ped (third-person)
        SetEntityMatrix(ped,
            right.x, right.y, right.z,
            forward.x, forward.y, forward.z,
            up.x, up.y, up.z,
            pos.x, pos.y, pos.z
        )

        -- Apply scaling to the ped when aiming (maintain scale while aiming)
        if IsPedWeaponReadyToShoot(ped) or IsPedAimingFromCover(ped) then
            -- Continuously apply the scale to the ped model while aiming
            SetEntityMatrix(ped,
                right.x, right.y, right.z,
                forward.x, forward.y, forward.z,
                up.x, up.y, up.z,
                pos.x, pos.y, pos.z
            )
        end

        -- Apply scaling to the ped in vehicles (optional, only if you need this)
        if IsPedInAnyVehicle(ped) then
            local vehicle = GetVehiclePedIsIn(ped, false)
            SetEntityMatrix(vehicle,
                right.x, right.y, right.z,
                forward.x, forward.y, forward.z,
                up.x, up.y, up.z,
                pos.x, pos.y, pos.z
            )
        end

        -- Prevent scale reset during aiming, reapply the matrix
        if IsPedWeaponReadyToShoot(ped) then
            -- Reapply the matrix transformation continuously while aiming
            SetEntityMatrix(ped,
                right.x, right.y, right.z,
                forward.x, forward.y, forward.z,
                up.x, up.y, up.z,
                pos.x, pos.y, pos.z
            )
        end
    end
end)
