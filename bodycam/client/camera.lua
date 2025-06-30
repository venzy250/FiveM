local iaCam = nil

function AttachChestCameraTo(ped)
    if iaCam then DestroyCam(iaCam) end
    iaCam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
    AttachCamToPedBone(iaCam, ped, Config.ChestBone, Config.ChestOffset.x, Config.ChestOffset.y, Config.ChestOffset.z, true)
    SetCamActive(iaCam, true)
    RenderScriptCams(true, true, 500, true, true)
end

function StopChestCamera()
    if iaCam then
        DestroyCam(iaCam)
        RenderScriptCams(false, false, 0, true, false)
        iaCam = nil
    end
end
