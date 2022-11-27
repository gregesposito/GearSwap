--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- __________.__                                ________                          __               .__.__  __      __  .__    .__           _____.__.__              
-- \______   |  |   ____ _____    ______ ____   \______ \   ____     ____   _____/  |_    ____   __| _|___/  |_  _/  |_|  |__ |__| ______ _/ ____|__|  |   ____      
--  |     ___|  | _/ __ \\__  \  /  ____/ __ \   |    |  \ /  _ \   /    \ /  _ \   __\ _/ __ \ / __ ||  \   __\ \   __|  |  \|  |/  ___/ \   __\|  |  | _/ __ \     
--  |    |   |  |_\  ___/ / __ \_\___ \\  ___/   |    `   (  <_> ) |   |  (  <_> |  |   \  ___// /_/ ||  ||  |    |  | |   Y  |  |\___ \   |  |  |  |  |_\  ___/     
--  |____|   |____/\___  (____  /____  >\___  > /_______  /\____/  |___|  /\____/|__|    \___  \____ ||__||__|    |__| |___|  |__/____  >  |__|  |__|____/\___  > /\ 
--                     \/     \/     \/     \/          \/              \/                   \/     \/                      \/        \/                      \/  \/ 
--
--	Please do not edit this file!							Please do not edit this file!							Please do not edit this file!
--
--	Editing this file will cause you to be unable to use Github Desktop to update!
--
--	Any changes you wish to make in this file you should be able to make by overloading. That is Re-Defining the same variables or functions in another file, by copying and
--	pasting them to a file that is loaded after the original file, all of my library files, and then job files are loaded first.
--	The last files to load are the ones unique to you. User-Globals, Charactername-Globals, Charactername_Job_Gear, in that order, so these changes will take precedence.
--
--	You may wish to "hook" into existing functions, to add functionality without losing access to updates or fixes I make, for example, instead of copying and editing
--	status_change(), you can instead use the function user_status_change() in the same manner, which is called by status_change() if it exists, most of the important 
--  gearswap functions work like this in my files, and if it's unique to a specific job, user_job_status_change() would be appropriate instead.
--
--  Variables and tables can be easily redefined just by defining them in one of the later loaded files: autofood = 'Miso Ramen' for example.
--  States can be redefined as well: state.HybridMode:options('Normal','PDT') though most of these are already redefined in the gear files for editing there.
--	Commands can be added easily with: user_self_command(commandArgs, eventArgs) or user_job_self_command(commandArgs, eventArgs)
--
--	If you're not sure where is appropriate to copy and paste variables, tables and functions to make changes or add them:
--		User-Globals.lua - 			This file loads with all characters, all jobs, so it's ideal for settings and rules you want to be the same no matter what.
--		Charactername-Globals.lua -	This file loads with one character, all jobs, so it's ideal for gear settings that are usable on all jobs, but unique to this character.
--		Charactername_Job_Gear.lua-	This file loads only on one character, one job, so it's ideal for things that are specific only to that job and character.
--
--
--	If you still need help, feel free to contact me on discord or ask in my chat for help: https://discord.gg/ug6xtvQ
--  !Please do NOT message me in game about anything third party related, though you're welcome to message me there and ask me to talk on another medium.
--
--  Please do not edit this file!							Please do not edit this file!							Please do not edit this file!
-- __________.__                                ________                          __               .__.__  __      __  .__    .__           _____.__.__              
-- \______   |  |   ____ _____    ______ ____   \______ \   ____     ____   _____/  |_    ____   __| _|___/  |_  _/  |_|  |__ |__| ______ _/ ____|__|  |   ____      
--  |     ___|  | _/ __ \\__  \  /  ____/ __ \   |    |  \ /  _ \   /    \ /  _ \   __\ _/ __ \ / __ ||  \   __\ \   __|  |  \|  |/  ___/ \   __\|  |  | _/ __ \     
--  |    |   |  |_\  ___/ / __ \_\___ \\  ___/   |    `   (  <_> ) |   |  (  <_> |  |   \  ___// /_/ ||  ||  |    |  | |   Y  |  |\___ \   |  |  |  |  |_\  ___/     
--  |____|   |____/\___  (____  /____  >\___  > /_______  /\____/  |___|  /\____/|__|    \___  \____ ||__||__|    |__| |___|  |__/____  >  |__|  |__|____/\___  > /\ 
--                     \/     \/     \/     \/          \/              \/                   \/     \/                      \/        \/                      \/  \/ 
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Setup functions for this job.  Generally should not be modified.
-------------------------------------------------------------------------------------------------------------------

--[[
    gs c toggle LuzafRing -- Toggles use of Luzaf Ring on and off
    
    Offense mode is melee or ranged.  Used ranged offense mode if you are engaged
    for ranged weaponskills, but not actually meleeing.
    
    Weaponskill mode, if set to 'Normal', is handled separately for melee and ranged weaponskills.
--]]
rd_status = false
wc_status = false
wildcard_failsafe = os.clock() + 9000000
dia_applied = false
shot_mob_id = 0


-- Initialization function for this job file.
function get_sets()
    -- Load and initialize the include file.
    include('Sel-Include.lua')
end

-- Setup vars that are user-independent.  state.Buff vars initialized here will automatically be tracked.
function job_setup()
	-- Whether to use Compensator under a certain threshhold even when weapons are locked.
	state.CompensatorMode = M{'Never','300','1000','Always'}
	-- Whether to automatically generate bullets.
	state.AutoAmmoMode = M(true,'Auto Ammo Mode')
	state.UseDefaultAmmo = M(true,'Use Default Ammo')
	state.Buff['Triple Shot'] = buffactive['Triple Shot'] or false

	-- Whether to use Luzaf's Ring
	state.LuzafRing = M(true, "Luzaf's Ring")
    -- Whether a warning has been given for low ammo
	
	autows = 'Leaden Salute'
	rangedautows = 'Last Stand'
	autofood = 'Sublime Sushi'
	ammostock = 198

    define_roll_values()
	
	init_job_states({"Capacity","AutoRuneMode","AutoTrustMode","AutoWSMode","AutoShadowMode","AutoFoodMode","RngHelper","AutoStunMode","AutoDefenseMode","LuzafRing",},{"AutoBuffMode","AutoSambaMode","Weapons","OffenseMode","RangedMode","WeaponskillMode","ElementalMode","IdleMode","Passive","RuneElement","CompensatorMode","TreasureMode",})
end


-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------
-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
-- Set eventArgs.useMidcastGear to true if we want midcast gear equipped on precast.

function job_filtered_action(spell, eventArgs)
	if spell.type == 'WeaponSkill' then
		local available_ws = S(windower.ffxi.get_abilities().weapon_skills)
		-- WS 112 is Double Thrust, meaning a Spear is equipped.
		if available_ws:contains(16) then
            if spell.english == "Savage Blade" then
				windower.chat.input('/ws "Evisceration" '..spell.target.raw)
                cancel_spell()
				eventArgs.cancel = true
            elseif spell.english == "Circle Blade" then
                windower.chat.input('/ws "Aeolian Edge" '..spell.target.raw)
                cancel_spell()
				eventArgs.cancel = true
			end
        end
	end
end

function job_pretarget(spell, spellMap, eventArgs)

end

function job_precast(spell, spellMap, eventArgs)
	if spell.action_type == 'Ranged Attack' then
		state.CombatWeapon:set(player.equipment.range)
    -- Check that proper ammo is available if we're using ranged attacks or similar.
    end
	
    if spell.action_type == 'Ranged Attack' or spell.name == 'Shadowbind' or (spell.type == 'WeaponSkill' and spell.skill == 'Marksmanship') then
        do_bullet_checks(spell, spellMap, eventArgs)
    end
end

function job_post_midcast(spell, spellMap, eventArgs)
	if spell.action_type == 'Ranged Attack' then
		if state.Buff['Triple Shot'] and sets.buff['Triple Shot'] then
			if sets.buff['Triple Shot'][state.RangedMode.value] then
				equip(sets.buff['Triple Shot'][state.RangedMode.value])
			else
				equip(sets.buff['Triple Shot'])
			end
		end

		if state.Buff.Barrage and sets.buff.Barrage then
			equip(sets.buff.Barrage)
		end
	end
end

function job_self_command(commandArgs, eventArgs)
	if commandArgs[1]:lower() == 'elemental' and commandArgs[2]:lower() == 'quickdraw' then
		windower.chat.input('/ja "'..data.elements.quickdraw_of[state.ElementalMode.Value]..' Shot" <t>')
		eventArgs.handled = true			
	end
end

function job_midcast(spell, action, spellMap, eventArgs)
	--Probably overkill but better safe than sorry.
	if spell.action_type == 'Ranged Attack' then
		if player.equipment.ammo:startswith('Hauksbok') or player.equipment.ammo == "Animikii Bullet" then
			enable('ammo')
			equip({ammo=empty})
			add_to_chat(123,"Abort Ranged Attack: Don't shoot your good ammo!")
			return
		end
	end
end

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_aftercast(spell, spellMap, eventArgs)
    if spell.type == 'CorsairRoll' and not spell.interrupted then
		if state.CompensatorMode.value ~= 'Never' then
			if (player.equipment.range and player.equipment.range == 'Compensator') and sets.weapons[state.Weapons.value] and sets.weapons[state.Weapons.value].range then
				equip({range=sets.weapons[state.Weapons.value].range})
				disable('range')
			end
			if sets.precast.CorsairRoll.main and sets.weapons[state.Weapons.value] and sets.weapons[state.Weapons.value].main then
				equip({main=sets.weapons[state.Weapons.value].main})
				disable('main')
			end
		end
        display_roll_info(spell)
	end
	
	if state.UseDefaultAmmo.value then
		equip({ammo=gear.RAbullet})
	end
end

-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------

function job_buff_change(buff, gain)
	local abil_recasts = windower.ffxi.get_ability_recasts()
	
	if player.equipment.Ranged and buff:contains('Aftermath') then
		classes.CustomRangedGroups:clear()
		if (player.equipment.range == 'Armageddon' and (buffactive['Aftermath: Lv.1'] or buffactive['Aftermath: Lv.2'] or buffactive['Aftermath: Lv.3']))
		or (player.equipment.Ranged == 'Death Penalty' and buffactive['Aftermath: Lv.3']) then
			classes.CustomRangedGroups:append('AM')
		end
	end

	-- Gain
	if buff == 'Warcry' and gain and state.AutoZergMode.value then
		if abil_recasts[196] > latency then
			wc_status = true
		else
			rd_status = true
		end
	end
	-- Loss
	if buff == 'Warcry' and not gain and state.AutoZergMode.value then
		rd_status = false
		wc_status = false
		wildcard_failsafe = os.clock() + 20
	end
end

-- Modify the default melee set after it was constructed.
function job_customize_melee_set(meleeSet)
    return meleeSet
end

-- Called by the 'update' self-command, for common needs.
-- Set eventArgs.handled to true if we don't want automatic equipping of gear.
function job_update(cmdParams, eventArgs)
end

function job_post_precast(spell, spellMap, eventArgs)
	if spell.type == 'WeaponSkill' then
		local WSset = standardize_set(get_precast_set(spell, spellMap))
		local wsacc = check_ws_acc()
		
		if (WSset.ear1 == "Moonshade Earring" or WSset.ear2 == "Moonshade Earring") then
			-- Replace Moonshade Earring if we're at cap TP
			if get_effective_player_tp(spell, WSset) > 3200 then
				if data.weaponskills.elemental:contains(spell.english) then
					if wsacc:contains('Acc') and sets.MagicalAccMaxTP then
						equip(sets.MagicalAccMaxTP[spell.english] or sets.MagicalAccMaxTP)
					elseif sets.MagicalMaxTP then
						equip(sets.MagicalMaxTP[spell.english] or sets.MagicalMaxTP)
					else
					end
				elseif spell.skill == 26 then
					if wsacc:contains('Acc') and sets.RangedAccMaxTP then
						equip(sets.RangedAccMaxTP[spell.english] or sets.RangedAccMaxTP)
					elseif sets.RangedMaxTP then
						equip(sets.RangedMaxTP[spell.english] or sets.RangedMaxTP)
					else
					end
				else
					if wsacc:contains('Acc') and not buffactive['Sneak Attack'] and sets.AccMaxTP then
						equip(sets.AccMaxTP[spell.english] or sets.AccMaxTP)
					elseif sets.MaxTP then
						equip(sets.MaxTP[spell.english] or sets.MaxTP)
					else
					end
				end
			end
		end
	elseif spell.type == 'CorsairShot' and not (spell.english == 'Light Shot' or spell.english == 'Dark Shot') then
		if state.CastingMode.value == 'Resistant' and sets.precast.CorsairShot then
			equip(sets.precast.CorsairShot.Resistant)
		elseif (state.WeaponskillMode.value == "Proc" or state.CastingMode.value == "Proc") and sets.precast.CorsairShot.Proc then
			equip(sets.precast.CorsairShot.Proc)
		elseif state.CastingMode.value == 'Fodder' and sets.precast.CorsairShot.Damage then
			equip(sets.precast.CorsairShot.Damage)
			
			local distance = spell.target.distance - spell.target.model_size
			local single_obi_intensity = 0
			local orpheus_intensity = 0
			local hachirin_intensity = 0

			if item_available("Orpheus's Sash") then
				orpheus_intensity = (16 - (distance <= 1 and 1 or distance >= 15 and 15 or distance))
			end
			
			if item_available(data.elements.obi_of[spell.element]) then
				if spell.element == world.weather_element then
					single_obi_intensity = single_obi_intensity + data.weather_bonus_potency[world.weather_intensity]
				end
				if spell.element == world.day_element then
					single_obi_intensity = single_obi_intensity + 10
				end
			end
			
			if item_available('Hachirin-no-Obi') then
				if spell.element == world.weather_element then
					hachirin_intensity = hachirin_intensity + data.weather_bonus_potency[world.weather_intensity]
				elseif spell.element == data.elements.weak_to[world.weather_element] then
					hachirin_intensity = hachirin_intensity - data.weather_bonus_potency[world.weather_intensity]
				end
				if spell.element == world.day_element then
					hachirin_intensity = hachirin_intensity + 10
				elseif spell.element == data.elements.weak_to[world.day_element] then
					hachirin_intensity = hachirin_intensity - 10
				end
			end
			
			if single_obi_intensity >= hachirin_intensity and single_obi_intensity >= orpheus_intensity and single_obi_intensity >= 5 then
				equip({waist=data.elements.obi_of[spell.element]})
			elseif hachirin_intensity >= orpheus_intensity and hachirin_intensity >= 5 then
				equip({waist="Hachirin-no-Obi"})
			elseif orpheus_intensity >= 5 then
				equip({waist="Orpheus's Sash"})
			end
			
		end
		
	elseif spell.action_type == 'Ranged Attack' then
		if buffactive.Flurry then
			if sets.precast.RA.Flurry and lastflurry == 1 then
				equip(sets.precast.RA.Flurry)
			elseif sets.precast.RA.Flurry2 and lastflurry == 2 then
				equip(sets.precast.RA.Flurry2)
			end
		end
	elseif spell.type == 'CorsairRoll' or spell.english == "Double-Up" then
		if state.LuzafRing.value and item_available("Luzaf's Ring") then
			equip(sets.precast.LuzafRing)
		end
		if spell.type == 'CorsairRoll' and state.CompensatorMode.value ~= 'Never' and (state.CompensatorMode.value == 'Always' or tonumber(state.CompensatorMode.value) > player.tp) then
			if item_available("Compensator") then
				enable('range')
				equip({range="Compensator"})
			end
			if sets.precast.CorsairRoll.main and sets.precast.CorsairRoll.main ~= player.equipment.main then
				enable('main')
				equip({main=sets.precast.CorsairRoll.main})
			end
		end
    elseif spell.english == 'Fold' and buffactive['Bust'] == 2 and sets.precast.FoldDoubleBust then
		equip(sets.precast.FoldDoubleBust)
	end
end

-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

function define_roll_values()
    rolls = {
        ["Corsair's Roll"]   = {lucky=5, unlucky=9, bonus="Experience Points"},
        ["Ninja Roll"]       = {lucky=4, unlucky=8, bonus="Evasion"},
        ["Hunter's Roll"]    = {lucky=4, unlucky=8, bonus="Accuracy"},
        ["Chaos Roll"]       = {lucky=4, unlucky=8, bonus="Attack"},
        ["Magus's Roll"]     = {lucky=2, unlucky=6, bonus="Magic Defense"},
        ["Healer's Roll"]    = {lucky=3, unlucky=7, bonus="Cure Potency Received"},
        ["Puppet Roll"]      = {lucky=3, unlucky=7, bonus="Pet Magic Accuracy/Attack"},
        ["Choral Roll"]      = {lucky=2, unlucky=6, bonus="Spell Interruption Rate"},
        ["Monk's Roll"]      = {lucky=3, unlucky=7, bonus="Subtle Blow"},
        ["Beast Roll"]       = {lucky=4, unlucky=8, bonus="Pet Attack"},
        ["Samurai Roll"]     = {lucky=2, unlucky=6, bonus="Store TP"},
        ["Evoker's Roll"]    = {lucky=5, unlucky=9, bonus="Refresh"},
        ["Rogue's Roll"]     = {lucky=5, unlucky=9, bonus="Critical Hit Rate"},
        ["Warlock's Roll"]   = {lucky=4, unlucky=8, bonus="Magic Accuracy"},
        ["Fighter's Roll"]   = {lucky=5, unlucky=9, bonus="Double Attack Rate"},
        ["Drachen Roll"]     = {lucky=4, unlucky=8, bonus="Pet Accuracy"},
        ["Gallant's Roll"]   = {lucky=3, unlucky=7, bonus="Defense"},
        ["Wizard's Roll"]    = {lucky=5, unlucky=9, bonus="Magic Attack"},
        ["Dancer's Roll"]    = {lucky=3, unlucky=7, bonus="Regen"},
        ["Scholar's Roll"]   = {lucky=2, unlucky=6, bonus="Conserve MP"},
        ["Bolter's Roll"]    = {lucky=3, unlucky=9, bonus="Movement Speed"},
        ["Caster's Roll"]    = {lucky=2, unlucky=7, bonus="Fast Cast"},
        ["Courser's Roll"]   = {lucky=3, unlucky=9, bonus="Snapshot"},
        ["Blitzer's Roll"]   = {lucky=4, unlucky=9, bonus="Attack Delay"},
        ["Tactician's Roll"] = {lucky=5, unlucky=8, bonus="Regain"},
        ["Allies' Roll"]    = {lucky=3, unlucky=10, bonus="Skillchain Damage"},
        ["Miser's Roll"]     = {lucky=5, unlucky=7, bonus="Save TP"},
        ["Companion's Roll"] = {lucky=2, unlucky=10, bonus="Pet Regain and Regen"},
        ["Avenger's Roll"]   = {lucky=4, unlucky=8, bonus="Counter Rate"},
		["Naturalist's Roll"]   = {lucky=3, unlucky=7, bonus="Enhancing Duration"},
		["Runeist's Roll"]   = {lucky=4, unlucky=8, bonus="Magic Evasion"},
    }
end

function display_roll_info(spell)
    rollinfo = rolls[spell.english]
    local rollsize = (state.LuzafRing.value and 'Large') or 'Small'

    if rollinfo then
        add_to_chat(217, spell.english..' provides a bonus to '..rollinfo.bonus..'.  Roll size: '..rollsize)
        add_to_chat(217, 'Lucky roll is '..tostring(rollinfo.lucky)..', Unlucky roll is '..tostring(rollinfo.unlucky)..'.')
    end
end


-- Determine whether we have sufficient ammo for the action being attempted.
function do_bullet_checks(spell, spellMap, eventArgs)

    if (player.equipment.ammo == 'Animikii Bullet' or player.equipment.ammo == 'Hauksbok Bullet') then
		cancel_spell()
		eventArgs.cancel = true
		enable('ammo')

		if sets.weapons[state.Weapons.value].ammo and item_available(sets.weapons[state.Weapons.value].ammo) then
			equip({ammo=sets.weapons[state.Weapons.value].ammo})
			disable('ammo')
		elseif item_available(gear.RAbullet) then
			equip({ammo=gear.RAbullet})
		else
			equip({ammo=empty})
		end

		add_to_chat(123,"Abort: Don't shoot your good ammo!")
		return
    end

    local bullet_name
    local bullet_min_count = 1
    
    if spell.type == 'WeaponSkill' then
        if spell.skill == "Marksmanship" then
            if data.weaponskills.elemental:contains(spell.english) then
                -- magical weaponskills
                bullet_name = gear.MAbullet
            else
				-- physical weaponskills
				bullet_name = gear.WSbullet
            end
        else
            -- Ignore non-ranged weaponskills
            return
        end
    elseif spell.type == 'CorsairShot' then
        bullet_name = gear.QDbullet
    elseif spell.action_type == 'Ranged Attack' then
        bullet_name = gear.RAbullet
        if state.Buff['Triple Shot'] then
            bullet_min_count = 3
        end
    end
  
	local available_bullets = count_available_ammo(bullet_name)
	
  -- If no ammo is available, give appropriate warning and cancel.
    if not (available_bullets > 0) then
        if spell.type == 'CorsairShot' and player.equipment.ammo ~= 'empty' then
            add_to_chat(217, 'No Quick Draw ammo available, using equipped ammo: ('..player.equipment.ammo..')')
            return
        elseif spell.type == 'WeaponSkill' and (player.equipment.ammo == gear.RAbullet or player.equipment.ammo == gear.WSbullet or player.equipment.ammo == gear.MAbullet) then
            add_to_chat(217, 'No weaponskill ammo available, using equipped ammo: ('..player.equipment.ammo..')')
            return
        else
            add_to_chat(217, 'No ammo ('..tostring(bullet_name)..') available for that action.')
            eventArgs.cancel = true
            return
        end
    end
    
    -- Don't allow shooting or weaponskilling with ammo reserved for quick draw.
    if spell.type ~= 'CorsairShot' and bullet_name == gear.QDbullet and (available_bullets <= bullet_min_count) then
        add_to_chat(217, 'No ammo will be left for Quick Draw.  Cancelling.')
        eventArgs.cancel = true
        return
    end
    
    -- Low ammo warning.
    if spell.type ~= 'CorsairShot' and (available_bullets > 0) and (available_bullets <= options.ammo_warning_limit) then
        local msg = '****  LOW AMMO WARNING: '..bullet_name..' ****'
        --local border = string.repeat("*", #msg)
        local border = ""
        for i = 1, #msg do
            border = border .. "*"
        end
        
        add_to_chat(217, border)
        add_to_chat(217, msg)
        add_to_chat(217, border)
    end
end

function check_buff()
	if state.AutoBuffMode.value ~= 'Off' and player.in_combat then
		
		local abil_recasts = windower.ffxi.get_ability_recasts()
		local available_ws = S(windower.ffxi.get_abilities().weapon_skills)

        if state.AutoShot.value ~= 'Off' and (dia_applied and shot_mob_id and windower.ffxi.get_mob_by_id(shot_mob_id).valid_target and math.sqrt(windower.ffxi.get_mob_by_id(shot_mob_id).distance) <= 22) then
            windower.add_to_chat('[AutoShot] Attemping to use Light Shot for -DIA- upgrade.')
            windower.send_command('input /ja "Light Shot" '..shot_mob_id)
            tickdelay = os.clock() + 2.8
            return true
		elseif player.sub_job == 'WAR' and not state.Buff['SJ Restriction'] and not buffactive.Berserk and abil_recasts[1] < latency then
			windower.chat.input('/ja "Berserk" <me>')
			tickdelay = os.clock() + 5.1
			return true
		elseif player.sub_job == 'WAR' and not state.Buff['SJ Restriction'] and not buffactive.Aggressor and abil_recasts[4] < latency and player.status == 'Engaged' then
			windower.chat.input('/ja "Aggressor" <me>')
			tickdelay = os.clock() + 5.1
			return true
		elseif (player.equipment.range == 'Armageddon' and not (buffactive['Aftermath: Lv.1'] or buffactive['Aftermath: Lv.2'] or buffactive['Aftermath: Lv.3'])) and abil_recasts[84] < latency and not buffactive['Triple Shot'] then
			windower.chat.input('/ja "Triple Shot" <me>')
			tickdelay = os.clock() + 5.1
			return true
		else
			return false
		end
	end
		
	return false
end

function check_zerg_sp()
	if state.AutoZergMode.value and player.status == 'Engaged' and player.in_combat and not data.areas.cities:contains(world.area) then
	
		local now = os.clock()
		local abil_recasts = windower.ffxi.get_ability_recasts()

		if buffactive['Warcry'] and abil_recasts[196] < latency and rd_status == true then
			windower.chat.input('/p Random Deal! <scall20>')
			windower.chat.input('/ja "Random Deal" <me>')
			if abil_recasts[196] > latency then
				rd_status = false
			end
			tickdelay = os.clock() + 4.5
			return true		
		elseif buffactive['Warcry'] and abil_recasts[196] > latency and abil_recasts[0] < latency and wc_status == true then
			windower.chat.input('/p Wild Card! <scall20>')
			windower.chat.input('/ja "Wild Card" <me>')
			if abil_recasts[0] > latency then
				wc_status = false
			end
			tickdelay = os.clock() + 4.5
			return true		
		-- If RD fails, to force WC
		elseif not buffactive['Warcry'] and abil_recasts[196] > latency and abil_recasts[0] < latency and rd_status == false then
			if now > wildcard_failsafe then
				wildcard_failsafe = os.clock() + 9000000
				windower.chat.input('/p Wild Card - Failsafe! <scall20>')
				windower.chat.input('/ja "Wild Card" <me>')
				tickdelay = os.clock() + 4.5
				return true
			end
			return false
		else
			return false
		end
	end
		
	return false
end

function job_tick()
	if check_ammo() then return true end
	if check_buff() then return true end
	if check_zerg_sp() then return true end
	if check_steps_subjob() then return true end
	return false
end

buff_spell_lists = {
	Auto = {	
		--Options for When are: Always, Engaged, Idle, OutOfCombat, Combat
		{Name='Haste',			Buff='Haste',			SpellID=57,		When='Always'},
        {Name='Refresh',		Buff='Refresh',			SpellID=109,	When='Always'},
        {Name='Reraise',	    Buff='Reraise',		    SpellID=135,	When='Always'},
	},
	
	Default = {
		{Name='Haste',			Buff='Haste',			SpellID=57,		Reapply=true},
		{Name='Refresh',		Buff='Refresh',			SpellID=109,	Reapply=true},
        {Name='Reraise',	    Buff='Reraise',		    SpellID=141,	Reapply=true},
	},
}