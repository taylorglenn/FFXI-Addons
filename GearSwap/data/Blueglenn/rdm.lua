--------------------------------------------------------------------------
-----------------------     includes      --------------------------------
--------------------------------------------------------------------------
function get_sets()
  -- Load and initialize the include file. 
  mote_include_version = 2
  include('Mote-Include.lua')
  include('organizer-lib')
end

--------------------------------------------------------------------------
------------     set style lock and macro book      ----------------------
--------------------------------------------------------------------------
function set_macros(book, sheet)
  if book then
    send_command('@input /macro book ' .. tostring(book) .. ';wait .1;input /macro set ' .. tostring(sheet))
    return
  end
  send_command('@input / macro set ' .. tostring(sheet))
end
set_macros(7, 1)

---------------------------------
-- lockstyle 
---------------------------------
function set_lockstyle(page)
  send_command('@wait 6;input /lockstyleset ' .. tostring(page))
end
set_lockstyle(03)

---------------------------------
-- dressup 
---------------------------------
function dressup(race, gender, face)
  send_command('@input //lua l dressup')
  if not race or not gender or not face then send_command('@input //du clear self') return end
  send_command('@input //du self race ' .. race .. ' ' .. gender)
  send_command('@wait 2; input //du self face ' .. tostring(face))
end
dressup('elvaan', 'female', 3)

---------------------------------
-- organizer 
---------------------------------
send_command('@input //gs org;wait6; input //gs validate')

--------------------------------------------------------------------------
-----------------------     job setup      -------------------------------
--------------------------------------------------------------------------
function job_setup()
  redMagicTable = loadRedMagicTable()
end

--------------------------------------------------------------------------
----------------------     user setup      -------------------------------
--------------------------------------------------------------------------
function user_setup() 
  ---------------------------------
  -- modes
  ---------------------------------
  state.IdleMode:options('Normal', 'DT')
  state.OffenseMode:options('Normal', 'Enspell', 'TpSword')
  state.CastingMode:options('Normal', 'FreeNuke', 'MagicBurst')

  send_command('bind ^i gs c cycle IdleMode')
  send_command('bind ^o gs c cycle OffenseMode')
  send_command('bind ^c gs c cycle CastingMode')

  ---------------------------------
  -- jse setup
  ---------------------------------
  gear.blueglenn.rdm = {
    capes = { 
      dual_wield          = { name = "Sucellos's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Dual Wield"+10','Phys. dmg. taken-10%',}},
      magic_attack_bonus  = { name = "Sucellos's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10',}},
      fast_cast           = { name = "Sucellos's Cape", augments={'"Fast Cast"+10',}},
      enhancing_duration  = { name = "Ghostfyre Cape",  augments={'Enfb.mag. skill +3','Enha.mag. skill +2','Mag. Acc.+2','Enh. Mag. eff. dur. +20',}},
    },
    
    neck = "Duelist's Torque +1",

    artifact = {  head  = "Atro. Chapeau +1",
                  body  = "Atrophy Tabard +1",
                  hands = "Atrophy Gloves +2",
                  legs  = "Atrophy Tights +1",
                  feet  = "Atrophy Boots +1" },

    relic = {     head  = "Viti. Chapeau +3",
                  body  = "Viti. Tabard +3",
                  hands = "Viti. Gloves +3",
                  legs  = "Viti. Tights +1",
                  feet  = "Vitiation Boots +3" },

    empyrean = {  head  = "Leth. Chappel +1",
                  body  = "Lethargy Sayon +1",
                  hands = "Leth. Gantherots +1",
                  legs  = "Leth. Fuseau +1",
                  feet  = "Leth. Houseaux +1" },
  }
end

---------------------------------
-- user unload
---------------------------------
function user_unload()
  -- unload keybinds
  send_command('unbind ^i') -- unbinds IdleMode from i key
  send_command('unbind ^o') -- unbinds OffenseMode from o key
end

--------------------------------------------------------------------------
--------------------     define gear sets      ---------------------------
--------------------------------------------------------------------------
function init_gear_sets()
  -- this is the order.  the order is arbitrary, but you should try to keep it consistent
    -- main
    -- sub
    -- range
    -- ammo
    -- head
    -- body
    -- hands
    -- legs
    -- feet
    -- neck 
    -- ear1
    -- ear2
    -- ring1
    -- ring2
    -- back
    -- waist
  ---------------------------------
  -- idle 
  ----------------------------------
  sets.idle = 
  { 
    ammo = "Homiliary",
    head = gear.blueglenn.rdm.relic.head, -- +3 Refresh
    body = gear.blueglenn.jhakri.body,
    hands= gear.blueglenn.nyame.hands,
    legs = gear.blueglenn.carmine.legs,
    feet = gear.blueglenn.nyame.feet,
    neck = "Bathy Choker +1", -- +3 Regen
    ear1 = "Infused Earring", -- +1 Regen
    ear2 = "Genmei Earring",
    ring1= "Defending Ring",
    ring2= "Stikini Ring +1", -- +1 Refresh
    back = "Moonbeam Cape",
    waist= "Flume Belt",
  }

  -- todo: sets.idle.DT

  ---------------------------------
  -- engaged 
  ----------------------------------
  sets.engaged = 
  {  
    head = gear.blueglenn.carmine.head,
    body = gear.blueglenn.ayanmo.body,
    hands= gear.blueglenn.nyame.hands,
    legs = gear.blueglenn.ayanmo.legs,
    feet = gear.blueglenn.nyame.feet,
    neck = "Anu Torque",
    ear1 = "Telos Earring",
    ear2 = "Dedition Earring",
    ring2= "Hetairoi Ring",
    ring1= "Chirich Ring +1",
    back = gear.blueglenn.rdm.capes.dual_wield,
    waist= "Dynamic Belt",  -- better belt is Reiki Yotai  which drops from Kouryu in Escha - Ru'Aun Geas Fete
  }

  sets.engaged.Enspell =  
    set_combine(sets.engaged, 
    { 
      --main = "", look up a lvl 1 dagger for each slot
      --sub  = "",
      range= "Ullr",
      neck = gear.blueglenn.rdm.neck ,
    })

  sets.engaged.TpSword = set_combine(sets.engaged, { sub = "Thibron" }) -- Thibron James lol

  ---------------------------------
  -- precast 
  ---------------------------------
  -- weapon skills
  sets.precast.WS = 
  { 
    head = gear.blueglenn.rdm.relic.head,
    body = gear.blueglenn.rdm.relic.body,
    hands= gear.blueglenn.rdm.artifact.hands,
    legs = gear.blueglenn.rdm.relic.legs,
    feet = gear.blueglenn.jhakri.feet,
    neck = "Fotia Gorget",
    ear1 = "Telos Earring",
    ear2 = gear.blueglenn.moonshade,
    ring1= "Chirich Ring +1",
    ring2= "Apate Ring",
    back = gear.blueglenn.rdm.capes.dual_wield,-- WS cape
    waist= "Fotia Belt" ,
  }

  sets.precast.WS['Chant du Cygne'] = 
    set_combine(sets.precast.WS, 
    {
      body = gear.blueglenn.ayanmo.body,
      hands= gear.blueglenn.ayanmo.hands,
    })

  sets.precast.WS['Vorpal Blade'] = sets.precast.WS['Chant du Cygne']

  sets.precast.WS['Savage Blade'] = set_combine(
    sets.precast.WS, 
    { 
      legs = gear.blueglenn.jhakri.legs,
      feet = gear.blueglenn.carmine.feet,
      neck = gear.blueglenn.rdm.neck
    })

  sets.precast.WS['Knights of Round'] = sets.precast.WS['Savage Blade']

  sets.precast.WS['Death Blossom']  = sets.precast.WS['Savage Blade']

  sets.precast.WS['Sanguine Blade'] = 
  { 
    head = "Pixie Hairpin +1",
    body = gear.blueglenn.amalric.body,
    hands= gear.blueglenn.jhakri.hands,
    legs = gear.blueglenn.jhakri.legs, -- amalric slops +1
    feet = gear.blueglenn.jhakri.feet,
    neck = "Baetyl Pendant",
    ear1 = "Regal Earring", -- todo
    ear2 = "Malignance Earring",
    ring1= "Freke Ring",
    ring2= "Shiva Ring +1",
    back = gear.blueglenn.rdm.capes.magic_attack_bonus,
    waist= "Eschan Stone", 
  }

  sets.precast.WS['Seraph Blade'] = sets.precast.WS['Sanguine Blade']

  -- job abilities
  sets.precast.JA['Chainspell'] = { body = gear.blueglenn.rdm.relic.body }

  sets.precast.Waltz = 
  {
    hands= gear.blueglenn.nyame.hands, -- todo: Herculean Gloves with +10% waltz potency
    legs = "Dashing Subligar",
    ear1 = "Roundel Earring",
  }

  -- 38 from job natively (30 from traits  8 from job gifts)
  sets.precast.FC = 
  { 
    head = gear.blueglenn.rdm.artifact.head, -- 12
    ear1 = "Loquac. Earring", -- 2
    ear2 = "Enchntr. Earring +1", -- 2
    body = gear.blueglenn.rdm.relic.body, -- 13
    back = gear.blueglenn.rdm.capes.fast_cast, -- 10
    legs = gear.blueglenn.carmine.legs, -- interruption down 20
    feet = gear.blueglenn.carmine.feet, -- 8
    ring1= "Freke Ring", -- interruption down 10
    waist= "Rumination Sash", -- interruption down 10
  } -- TODO: This is actually 85 fastcast which is overcapped by 5.

  sets.precast.FC.Cure =  set_combine(sets.precast.FC, { ear1 = "Mendi. Earring" })
  sets.precast.FC.Curaga              = sets.precast.FC.Cure
  sets.precast.FC['Healing Magic']    = sets.precast.FC.Cure
  sets.precast.FC['Enhancing Magic']  = set_combine(sets.precast.FC, { waist = "Siegel Sash" })

  ---------------------------------
  -- midcast sets
  ---------------------------------
  ---------------------------------
  -- healing sets
  ---------------------------------
  sets.midcast.Cure = 
  { 
    head = gear.blueglenn.kaykaus.head,
    body = gear.blueglenn.kaykaus.body,
    hands= gear.blueglenn.kaykaus.hands,
    legs = gear.blueglenn.kaykaus.legs,
    feet = gear.blueglenn.kaykaus.feet,
    neck = "Nodens Gorget",
    ear1 = "Mendi. Earring",
    ear2 = "Roundel Earring",
    ring1= "Haoma's Ring",
    ring2= "Lebeche Ring",
    back = gear.blueglenn.rdm.capes.magic_attack_bonus, -- swap this with a MND cape
    waist= "Bishop's Sash", 
  }

  sets.midcast.Cursna  = set_combine(sets.midcast.Cure, 
  { 
    legs = gear.blueglenn.rdm.artifact.legs,
    neck = "Debils Medallion",
    ear2 = "Meili Earring", -- todo
    ring2= "Haoma's Ring", 
  })

  ---------------------------------
  -- enhancing sets
  ---------------------------------
  sets.midcast['Enhancing Magic'] = 
  { 
    body = gear.blueglenn.rdm.relic.body,
    hands= gear.blueglenn.rdm.artifact.hands,
    feet = gear.blueglenn.rdm.empyrean.feet,
    neck = gear.blueglenn.rdm.neck,
    ear1 = "Mimir Earring", -- todo
    ear2 = "Andoaa Earring", -- todo
    ring1= "Stikini Ring",
    ring2= "Stikini Ring +1",
    back = gear.blueglenn.rdm.capes.enhancing_duration,
    waist= "Olympus Sash",
  }

  sets.midcast['Enhancing Magic'].self  = 
  set_combine(sets.midcast['Enhancing Magic'], 
  {
    head = gear.blueglenn.telchine.head.enhancing_duration,
    legs = gear.blueglenn.telchine.legs.enhancing_duration,
  })

  sets.midcast['Enhancing Magic'].other = 
  set_combine(sets.midcast['Enhancing Magic'],
  {
    head = gear.blueglenn.rdm.empyrean.head,
    legs = gear.blueglenn.rdm.empyrean.legs,
  })

  -- en-spells and temper
  sets.midcast['Enhancing Magic'].enhancing_skill = 
  set_combine(sets.midcast['Enhancing Magic'], 
  {
    head = "Befouled Crown",
    hands= gear.blueglenn.rdm.relic.hands,
    legs = gear.blueglenn.rdm.artifact.legs, 
    neck = "Incanter's Torque", -- todo
  }) 
                          
  sets.midcast.Regen = sets.midcast['Enhancing Magic']

  sets.midcast.Refresh = 
  set_combine(sets.midcast['Enhancing Magic'], 
  {
    head = gear.blueglenn.amalric.head, -- todo
    body = gear.blueglenn.rdm.artifact.body,
    legs = gear.blueglenn.rdm.empyrean.legs, 
  })

  sets.midcast.Stoneskin = 
  set_combine(sets.midcast['Enhancing Magic'], 
  {
    neck = "Nodens Gorget", 
    waist= "Siegel Sash", 
  })

  sets.midcast.Aquaveil = 
  set_combine(sets.midcast['Enhancing Magic'], 
  {
    head = gear.blueglenn.amalric.head, -- todo
    ear1 = "Halasz Earring",
    ring1 = "Freke Ring",
    ring2 = "Evanescence Ring",
    waist = "Emphatikos Rope", 
  })

  sets.midcast.GainSpell    = set_combine(sets.midcast['Enhancing Magic'], { hands= gear.blueglenn.rdm.relic.hands })
  sets.midcast.SpikesSpell  = set_combine(sets.midcast['Enhancing Magic'], { legs = gear.blueglenn.rdm.relic.legs })
  sets.midcast.Storm        = sets.midcast['Enhancing Magic']
  sets.midcast.Protect      = sets.midcast['Enhancing Magic']
  sets.midcast.Protectra    = sets.midcast.Protect
  sets.midcast.Shell        = sets.midcast.Protect
  sets.midcast.Shellra      = sets.midcast.Shell

  ---------------------------------
  -- enfeebling sets
  ---------------------------------
  sets.midcast['Enfeebling Magic'] = {}
  -- Dia  Silence  Bind  Blind, Gravity, Break, Dispel, Frazzle II, Distract II
  sets.midcast['Enfeebling Magic'].enfeebling_accuracy =
  {  
    ammo = "Regal Gem",
    head = gear.blueglenn.rdm.relic.head, -- artifact when +3
    body = gear.blueglenn.rdm.artifact.body,
    hands= gear.blueglenn.kaykaus.hands,
    legs = gear.blueglenn.chironic.legs.enfeebling,
    feet = gear.blueglenn.rdm.relic.feet,
    neck = gear.blueglenn.rdm.neck,
    ear1 = "Malignance Earring",
    ear2 = "Hermetic Earring",
    ring1= "Stikini Ring",
    ring2= "Stikini Ring +1",
    back = gear.blueglenn.rdm.capes.magic_attack_bonus,
    waist= "Eschan Stone",
  }

  --  Addle, Addle II, Paralyze, Paralyze II, Slow, Slow II
  sets.midcast['Enfeebling Magic'].enfeebling_potency = 
    set_combine(sets.midcast['Enfeebling Magic'].enfeebling_accuracy, 
    { 
      head = gear.blueglenn.rdm.relic.head,
      body = gear.blueglenn.rdm.empyrean.body, 
    })

  -- Frazzle III, Distract III, Poison II
  sets.midcast['Enfeebling Magic'].enfeebling_skill = 
    set_combine(sets.midcast['Enfeebling Magic'].enfeebling_accuracy, 
    {
      hands= gear.blueglenn.rdm.empyrean.hands,
      ear2 = "Vor Earring",
      waist= "Rumination Sash", 
    })

  sets.midcast['Enfeebling Magic'].enfeebling_sleep = 
    set_combine(sets.midcast['Enfeebling Magic'].enfeebling_accuracy, 
    {
      head = gear.blueglenn.rdm.empyrean.head,
      body = gear.blueglenn.rdm.empyrean.body,
      hands= gear.blueglenn.rdm.empyrean.hands,
      legs = gear.blueglenn.rdm.empyrean.legs,
      feet = gear.blueglenn.rdm.empyrean.feet, 
    })

  ---------------------------------
  -- nuking sets
  ---------------------------------
  sets.midcast['Elemental Magic'] = 
  {   
    --head = gear.blueglenn.jhakri.head, -- 41
    --body = gear.blueglenn.amalric.body, -- 53 (33 base, 20 path A)
    body = "Cohort Cloak +1", -- 100 (cannnot equip headgear)
    hands= gear.blueglenn.amalric.hands, -- 53 (33 base  20 path A)
    legs = gear.blueglenn.jhakri.legs, -- 42
    feet = gear.blueglenn.jhakri.feet, -- 39
    neck = "Baetyl Pendant", -- 13
    ear1 = "Malignance Earring", -- 8
    ear2 = "Novio Earring", -- 7 --"Regal Earring",
    ring1= "Freke Ring", -- 8
    ring2= "Shiva Ring +1", -- 3
    back = gear.blueglenn.rdm.capes.magic_attack_bonus, -- 10
    waist= "Eschan Stone", -- 7
  } 
  -- 284 magic attack bonus

  sets.midcast['Dark Magic'] = 
    set_combine(sets.midcast['Elemental Magic'], 
    { 
      head = "Pixie Hairpin +1",
      body = gear.blueglenn.carmine.body,
      hands= gear.blueglenn.kaykaus.hands,
      ring1= "Archon Ring",
      ring2= "Evanescence Ring",
    })

  sets.midcast.Drain = sets.midcast['Dark Magic']
  sets.midcast.Aspir = sets.midcast['Dark Magic']
  sets.midcast.Stun  = sets.midcast['Dark Magic']
  sets.midcast['Bio III'] = set_combine(sets.midcast['Dark Magic'],  { legs = gear.blueglenn.rdm.relic.legs })
                  
  -- todo: sets.midcast.magic_burst

  ---------------------------------
  -- casting mode sets
  ---------------------------------
  sets.CastingMode = { sub = "Enki Strap" }
  sets.CastingMode.Enfeebling = 
    set_combine(sets.CastingMode, {
      -- put an enfeebling grio here
    }
  )
  sets.CastingMode.FreeNuke = 
    set_combine(sets.CastingMode, {
      Main = "Raetic Staff +1"
    }
  )
  sets.CastingMode.MagicBurst = -- probably just put the whole damn EA set in here (if/when you get it)
    set_combine(sets.FreeNuke, {
      ring1= "Locus Ring", -- mag. crit. rate +5%, bonus damage to MB
      ring2= "Resonance Ring", -- mag. crit. rate +5%, ele. skill +8
    }
  )
end

--------------------------------------------------------------------------
---------------------     gearswap hooks     -----------------------------
--------------------------------------------------------------------------
function job_midcast(spell, action, spellMap, eventArgs)
  local spell_type = spell.type:lower()
  if spell_type == 'whitemagic' or spell_type == 'blackmagic' then
    handleEnhancingEnfeebling(spell)
    handleElementalMagic(spell)
  end
  
end

--------------------------------------------------------------------------
-------------------        my functions        ---------------------------
--------------------------------------------------------------------------
function handleElementalMagic(spell)
  local skillType = spell.skill
  if skillType:lower() ~= 'elemental magic' then return end

  local mode = state.CastingMode.value
  if mode == 'Normal' then return end

  local castingModeSet = sets.CastingMode[mode]
  if castingModeSet ~= nil then
    equip(castingModeSet)
  end
end

function handleEnhancingEnfeebling(spell)
  local skillType = spell.skill
  if skillType:lower() ~= 'enhancing magic' and skillType:lower() ~= 'enfeebling magic' then return end
  local set = getSet(spell)
  local fullPath = sets.midcast[skillType][set]
  if fullPath == nil then
    windower.add_to_chat(028, 'WARNING: sets.midcast['..skillType..']['..set..'] was not found!')
    return 
  end
  windower.add_to_chat(069, '<-- equipping sets.midcast['..skillType..']['..set..'] -->')
  equip(fullPath)
end

function getSetFrom2dTable(spellName, table)
  for tableName, table in pairs(table) do
    for tableSpell,_  in pairs(table) do
      if tostring(tableSpell):lower() == tostring(spellName):lower() then 
        return tostring(tableName) 
      end
    end
  end
  return ''
end

function getSet(spell)
  local redMagicTableSet = getSetFrom2dTable(spell.english, redMagicTable)
  if redMagicTableSet ~= '' then return redMagicTableSet end

  local target = spell.target.type:lower()

  -- if target is monster use base table, if enhancing_skill, use that table
  if target == 'monster' or redMagicTableSet:lower() == 'enhancing_skill' then 
    return '' 
  end

  if target == 'self' then 
    return 'self' 
  end

  if target == 'npc' or target == 'player' then 
    return 'other' 
  end

  return ''
end

function loadRedMagicTable()
  return {
    enfeebling_accuracy = 
    S{
      'Bind',
      'Break',
      'Dispel',
      'Distract',
      'Distract II',
      'Frazzle',
      'Frazzle II',
      'Gravity',
      'Gravity II',
      'Silence',
      'Dia',
      'Dia II',
      'Dia III',
      'Diaga',
      'Blind',
      'Blind II',
    },
    enfeebling_skill = 
    S{
      'Distract III',
      'Frazzle III',
      'Poison II'
    },
    enfeebling_potency = 
    S{
      'Addle',
      'Addle II',
      'Paralyze',
      'Paralyze II',
      'Slow',
      'Slow II',
    },
    enfeebling_sleep = 
    S{
      'Sleep',
      'Sleep II',
      'Sleepga',
    },
    enhancing_skill = 
    S{
      'Temper',
      'Temper II',
      'Enfire',
      'Enfire II',
      'Enblizzard',
      'Enblizzard II',
      'Enaero',
      'Enaero II',
      'Enstone',
      'Enstone II',
      'Enthunder',
      'Enthunder II',
      'Enwater',
      'Enwater II',
    },
  }
end

function substring(str, substr) 
  return string.find(str, substr) ~= nil
end
