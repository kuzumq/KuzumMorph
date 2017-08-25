local _kuzum = {}
_kuzum.addonmsg = '|cffF29B38[Kuzum Morph]: |r'
_kuzum.main_loadstate = false
_kuzum.main_loadstate_msg = false
_kuzum.loadstate = false


C_Timer.NewTicker(1, (function()

	if not EWT and not _kuzum.main_loadstate and not _kuzum.main_loadstate_msg then

		_kuzum.main_loadstate_msg = true
		print(_kuzum.addonmsg, 'EWT не обнаружен.')

	elseif EWT and not _kuzum.main_loadstate then
		
		_kuzum.main_loadstate = true
		print(_kuzum.addonmsg, 'EWT загружен.')

	end
	
end), nil)

local SlotIds = {

	['INVTYPE_HEAD'] = 1,
	['INVTYPE_SHOULDER'] = 3,
	['INVTYPE_CLOAK'] = 15,
	['INVTYPE_CHEST'] = 5,
	['INVTYPE_BODY'] = 4,
	['INVTYPE_TABARD'] = 19,
	['INVTYPE_WRIST'] = 9,
	['INVTYPE_HAND'] = 10,
	['INVTYPE_WAIST'] = 6,
	['INVTYPE_LEGS'] = 7,
	['INVTYPE_FEET'] = 8,
	['INVTYPE_2HWEAPON'] = 16,
	['INVTYPE_WEAPON'] = 16,
	['INVTYPE_SHIELD'] = 17,
	['INVTYPE_HOLDABLE'] = 17,

}

function _kuzum.ClearPlayerModel()

	for _,id in pairs(SlotIds) do
	
		if id ~= 16 then
	
			SendChatMessage(".item "..id..' 0', "WHISPER", nil, sendTo)
		
		end
		
	end

end

function _kuzum.ConvertWowheadSTR(str)
	
	local str = tostring(str)

	local sendTo = UnitName('player')
  
	local tempt = {}
  
	for itemid in string.gmatch(str, "f.(%d%d+)") do
		
		if GetItemInfo(itemid) then 
		
			local equipSlot = select(9,GetItemInfo(itemid))
			local slotId = SlotIds[equipSlot]

			table.insert(tempt, {itemid = itemid, slotId = slotId})
		
		else
		
			print(_kuzum.addonmsg, 'Предмет '..itemid..' не найден в кэше, повторите попытку.')
			
		end
		
	end
	
	_kuzum.ClearPlayerModel()
	
	for i = 1, #tempt do
		
		if tempt[i].slotId then
			
			SendChatMessage(".item "..tempt[i].slotId..' '..tempt[i].itemid, "WHISPER", nil, sendTo)
			--print(' Kuzum Morph: '..GetItemInfo(tempt[i].itemid)..' Применено!')
		
		end
		
	end

end

-- In Test
function _kuzum.SetHook(x)

	WardrobeCollectionFrame.ModelsFrame.Models[x]:HookScript("OnMouseDown", function(self, button)
	
		if ( button == "LeftButton" ) then
	
			local id = WardrobeCollectionFrame.ModelsFrame.Models[x].visualInfo.visualID
			local link
			local sources = WardrobeCollectionFrame_GetSortedAppearanceSources(id);
			local offset = WardrobeCollectionFrame.tooltipIndexOffset;
			
			if ( offset ) then
		
				if ( offset < 0 ) then
			
					offset = #sources + offset;
				
				end
			
				local index = mod(offset, #sources) + 1;
			
				link = select(6, C_TransmogCollection.GetAppearanceSourceInfo(sources[index].sourceID));

			end
			
			local itemid = link:match("Hitem:(%d+):")
			local equipSlot = select(9,GetItemInfo(link))
			local idslot = SlotIds[equipSlot]
			local sendTo = UnitName('player')
			
			print(itemid)
			SendChatMessage(".item "..idslot..' '..itemid, "WHISPER", nil, sendTo)
			
		end
	
	end)
	
end

function _kuzum.init()

	for i=1,18 do

		local id = WardrobeCollectionFrame.ModelsFrame.Models[i].visualInfo.visualID
		_kuzum.SetHook(i)

	end
	
end

C_Timer.NewTicker(1, (function()

	if WardrobeCollectionFrame and not _kuzum.loadstate and _kuzum.main_loadstate then

		_kuzum.init()
		_kuzum.loadstate = true
		print(_kuzum.addonmsg, 'Модуль гардероба загружен.')

	end
	
end), nil)

SLASH_KUZUMMORPH1 = "/kzm"
SlashCmdList["KUZUMMORPH"] = function(msg, editBox)
	
	if msg:match("/run") then 
	
		if EWT then
	
			_kuzum.ConvertWowheadSTR(msg)
		
		else
	
			print(_kuzum.addonmsg, 'EWT не обнаружен.')
		
		end
		
	elseif msg == 'help' then 
	
		print(_kuzum.addonmsg, 'Введите комманду /kzm и через пробел вставьте ссылку скопированую из вовхеда(начинается она с /run)')
		print(_kuzum.addonmsg, 'Должна получиться комманда такого вида:')
		print(_kuzum.addonmsg, ' "/kzm /run local function blablablabla~"')
		
	else
	
		print(_kuzum.addonmsg, 'Введите /kzm help для получения справки.')
		
	end

	
end















