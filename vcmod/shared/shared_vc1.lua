
-----------------------------------------------------
VC.CD.Default = {Model = "models/barney.mdl", Name = "Car Dealer", Pos = Vector(0,0,0), Ang = Angle(0,0,0), Platforms = {}, Vehicles = {}}  function VC.CD.CanAffordVehicle(ply, price) local Func = ply.canAfford or ply.CanAfford local can = !Func or Func(ply, price) return can end function VC.CD.GetName(mdl, nm, skin) return (mdl or "").."$$$_VC_$$$"..(nm or "Unknown").."$$$_VC_$$$"..(skin or "0") end function VC.CD_GetDataFromName(txt) local tbl = string.Explode("$$$_VC_$$$", txt) return {Model = tbl[1], Name = tbl[2], Skin = tbl[2]} end  local function CheckTables(tbl, job, rank) local restjob, restrank = tbl and tbl.JobRestrict and job and tbl.JobRestrict[job], tbl and tbl.RankRestrict and rank and tbl.RankRestrict[rank] if restjob then return "job" elseif restrank then return "rank" end end function VC.CD.IsRestricted(ply, tbl_veh, tbl_npc, dontprint)  local rank = ply:GetNWString("UserGroup") local JobName = ply.getJobTable and ply:getJobTable() and ply:getJobTable().name or "Unknown"  local restVeh, restNPC = CheckTables(tbl_veh, JobName, rank), CheckTables(tbl_npc, JobName, rank)  local rest = nil if restNPC then rest = {type = "npc", restriction = restNPC} elseif restVeh then rest = {type = "veh", restriction = restVeh} end  if rest and !dontprint then if SERVER then VCMsg("Access restricted", ply) else VCPopup(VC.Lng("AccessRestricted").." "..(rest.type == "npc" and VC.Lng("CantBeUsedBy") or VC.Lng("CantBeSpawnedBy"))..(rest.restriction == "rank" and (' "'..rank..'"') or ' "'..JobName..'"')..".", "cross", 8) end end  return rest end  function VC.CD.GetSpawnPosAng(ply, tbl, ent)  local pos, ang = nil, nil  if tbl.Platforms and table.Count(tbl.Platforms) > 0 then  for k,v in pairs(tbl.Platforms) do  local ar,af,au = v.Ang:Right()*142,v.Ang:Forward()*71,v.Ang:Up()*50  if !util.TraceLine({start = v.Pos+ar+af, endpos = v.Pos-ar-af+au}).Hit and !util.TraceLine({start = v.Pos-ar+af+au, endpos = v.Pos+ar-af}).Hit then pos = v.Pos+Vector(0,0,10) ang = v.Ang break end  end  else  local tang = (ply:GetPos()-ent:GetPos()):Angle() tang.p = 0 pos = ent:GetPos()+Vector(0,0,10)-tang:Right()*150 ang = tang-Angle(0,90,0)  end  return pos, ang end local rs7 = "vc.check_msg_work_ALS_k4" 