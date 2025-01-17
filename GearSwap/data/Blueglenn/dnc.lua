---------------------------------
-- includes
---------------------------------
function get_sets()
  -- Load and initialize the include file.
  mote_include_version = 2
  include('Mote-Include.lua')
end

---------------------------------
-- lockstyle 
---------------------------------
function set_lockstyle(page)
  send_command('@wait 6;input /lockstyleset ' .. tostring(page))
end
set_lockstyle(16)

---------------------------------
-- macros 
---------------------------------
function set_macros(sheet, book)
  if book then
    send_command('@input /macro book ' .. tostring(book) .. ';wait .1;input /macro set ' .. tostring(sheet))
    return
  end
  send_command('@input /macro set ' .. tostring(sheet))
end
set_macros(1, 16)

---------------------------------
-- dislpay globals
---------------------------------
displaySettings = 
{ 
  pos = 
  {
    x = 0,
    y = 0
    --x = 810,
    --y = 1065
  },
  text = 
  {
    font = 'Consolas',
    size = 10
  },
  bg = 
  {
    alpha = 255
  },
  flags = 
  {
    draggable = false
  }
}
displayBox = texts.new('${value}', displaySettings)

---------------------------------
-- job setup
---------------------------------
function job_setup()

end

---------------------------------
-- user setup
---------------------------------
function user_setup() 
  ---------------------------------
  -- states
  ---------------------------------
  state.OffenseMode:options('Normal','Accuracy','Subtle Blow')
  send_command('bind ^o gs c cycle OffenseMode')

  windower.register_event('prerender', drawDisplay)

  ---------------------------------
  -- jse setup
  ---------------------------------
  gear.globals.dnc = {
    capes = { 
      reverse_flourish = { name="Toetapper Mantle", augments={'"Store TP"+3','"Dual Wield"+3','"Rev. Flourish"+23',}},
      da  = { name="Senuna's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},
      wsd = { name="Senuna's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Weapon skill damage +10%',}},
      mab = { name="Senuna's Mantle", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','Magic Damage +5','Weapon skill damage +10%',}},
    },
  
    neck = "Etoile Gorget +1",
  
    artifact = {  head  = "Maxixi Tiara +3",
                  body  = "Maxixi Casaque +1",
                  hands = "Maxixi Bangles +1",
                  legs  = "Maxixi Tights +1",
                  feet  = "Maxixi Shoes +1" },
  
    relic = {     head  = "Horos Tiara +3",
                  body  = "Horos Casaque +3",
                  hands = "Horos Bangles +1",
                  legs  = "Horos Tights +3",
                  feet  = "Horos Toe Shoes +3" },
  
    empyrean = {  head  = "Maculele Tiara +1",
                  body  = "Maculele Casaque +1",
                  hands = "Maculele Bangles +1",
                  legs  = "Maculele Tights +1",
                  feet  = "Macu. Toe Shoes +1" }, 
  }
end

---------------------------------
-- user unload
---------------------------------
function user_unload()
  -- unload keybinds
  send_command('unbind ^o') -- unbinds OffenseMode from o key
end

---------------------------------
-- define gear sets
---------------------------------
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
    -- waist
    -- ear1
    -- ear2
    -- ring1
    -- ring2
    -- back

  ---------------------------------
  -- idle
  ---------------------------------
  sets.idle = 
  {
    --main = "Tauret",
    --sub  = "Gleti's Knife",
    --sub  = "Centovente",
    ammo = "Staunch Tathlum",
    head = gear.globals.nyame.head,
    body = gear.globals.nyame.body,
    hands= gear.globals.nyame.hands,
    legs = gear.globals.nyame.legs,
    feet = gear.globals.nyame.feet,
    neck = "Bathy Choker +1",
    waist= "Flume Belt",
    ear1 = "Infused Earring",
    ear2 = "Etiolation Earring",
    ring1= "Defending Ring",
    ring2= "Shneddick Ring",
    back = "Moonbeam Cape",
  }
  ---------------------------------
  -- engaged
  ---------------------------------
  sets.engaged = 
  {
    ammo = "Yamarang",
    head = gear.globals.dnc.artifact.head, --gear.globals.adhemar.head,
    body = gear.globals.dnc.relic.body,
    hands= gear.globals.adhemar.hands,
    legs = gear.globals.meghanada.legs,
    feet = gear.globals.dnc.relic.feet,
    neck = gear.globals.dnc.neck,
    waist= "Windbuffet Belt +1",
    ear1 = "Sherida Earring",
    ear2 = "Telos Earring",
    ring1= "Ilabrat Ring",
    ring2= "Gere Ring",
    back = gear.globals.dnc.capes.da,
  }
  sets.engaged.Accuracy = set_combine(sets.engaged, 
  {
    head = gear.globals.dnc.relic.head,
    waist= "Eschan Stone", -- +15 acc
    ear1 = "Mache Earring +1",
    ear2 = "Mache Earring +1",
    ring1= "Ilabrat Ring", -- floor(10dex * 075) = 7acc, todo: regal ring (same dex, but set bonus with artifact armor increases acc)
    ring2= "Chirich Ring +1",
  })
  sets.engaged['Subtle Blow'] = set_combine(sets.engaged, {

  })
  ---------------------------------
  -- job abilities
  ---------------------------------
  sets.precast.JA['No Foot Rise'] = { body = gear.globals.dnc.relic.body }
  sets.precast.JA['Saber Dance'] = { legs = gear.globals.dnc.relic.legs }
  sets.precast.JA['Trance'] = { head = gear.globals.dnc.relic.head }
  ---------------------------------
  -- steps
  ---------------------------------
  sets.precast.Step = 
  {
    ammo = "Yamarang",
    head = gear.globals.dnc.artifact.head,
    body = gear.globals.dnc.artifact.body,
    hands= gear.globals.dnc.artifact.hands,
    legs = gear.globals.dnc.artifact.legs,
    feet = gear.globals.dnc.relic.feet,
    neck = gear.globals.dnc.neck,
    waist= "Eschan Stone", -- +15 acc
    ear1 = "Mache Earring +1",
    ear2 = "Mache Earring +1",
    ring1= "Ilabrat Ring", -- floor(10dex * 075) = 7acc, todo: regal ring (same dex, but set bonus with artifact armor increases acc)
    ring2= "Chirich Ring +1",
    back = gear.globals.dnc.capes.da,
  }
  sets.precast.Step['Feather Step'] = set_combine(sets.precast.Step, { feet = gear.globals.dnc.empyrean.feet })
  ---------------------------------
  -- sambas
  ---------------------------------
  sets.precast.Samba = 
  {
    head = gear.globals.dnc.artifact.head -- + samba duration
  }
  ---------------------------------
  -- waltzes
  ---------------------------------
  sets.precast.Waltz = 
  {
    ammo = "Yamarang", --5
    head = gear.globals.dnc.relic.head, --11 (13 with +2, 15 with +3)
    body = gear.globals.dnc.artifact.body, --15 (17 with +2, 19 with +3)
    hands= gear.globals.herculean.hands.waltz, --11
    legs = "Dashing Subligar", --10
    feet = gear.globals.dnc.artifact.feet, --10 (12 with +2, 14 with +3)
    neck = gear.globals.dnc.neck, --7
    ear1 = "Roundel Earring", --5
  } --74/50, todo: overcapped
  sets.precast.WaltzSelf = set_combine(sets.precast.Waltz, 
  {
    head = gear.globals.mummu.head,
  })
  ---------------------------------
  -- jigs
  ---------------------------------
  sets.precast.Jig = 
  {
    legs = gear.globals.dnc.relic.legs, -- + jig duration 
    feet = gear.globals.dnc.artifact.feet, -- + jig duration
  }
  ---------------------------------
  -- flourishes
  ---------------------------------
  sets.precast.JA['Reverse Flourish'] = 
  {
    hands = gear.globals.dnc.empyrean.hands,
    back  = gear.globals.dnc.capes.reverse_flourish, --23/30 RF
  }
  sets.precast.JA['Violent Flourish'] = 
  {
    ammo = "Yamarang",
    head = gear.globals.mummu.head,
    body = gear.globals.dnc.relic.body,
    hands= gear.globals.mummu.hands,
    legs = gear.globals.dnc.relic.legs,
    feet = gear.globals.mummu.feet,
    neck = gear.globals.dnc.neck,
    waist= "Eschan Stone",
    ear1 = "Hermetic Earring +1",
    ear2 = "Sherida Earring",
    ring1= "Stikini Ring +1",
    ring2= "Stikini Ring",
    --back = "int20 macc30 cape"
  }
  ---------------------------------
  -- precast
  ---------------------------------
  sets.precast.FC = 
  {
    ammo = "Sapience Orb", -- 2
    head = gear.globals.herculean.head.mab, -- 7
    ear1 = "Enchntr. Earring +1", -- 2
    ear2 = "Loquac. Earring", --2
    ring1= "Prolix Ring", -- 2
    ring2= "Veneficium Ring", -- no FC, but has 1% QC
  } -- 15% FC, better than nothing I guess?
  ---------------------------------
  -- weapon skills
  ---------------------------------
  sets.precast.WS = 
  {
    ammo = "Charis Feather",
    body = gear.globals.meghanada.body,
    legs = gear.globals.dnc.relic.legs,
    feet = gear.globals.mummu.feet,
    neck = "Fotia Gorget",
    waist= "Fotia Belt",
    ear1 = gear.globals.moonshade,
    ear2 = "Mache Earring +1",
    ring1= "Ilabrat Ring", -- floor(10dex * 0.75) = 7acc, todo: regal ring (same dex, but set bonus with artifact armor increases acc)
    ring2= "Gere Ring",
    back = gear.globals.dnc.capes.wsd,
  }
  -- Evisceration: Dagger - Physical - 50% DEX - Static fTP @ 1.25 - Crit Rate @ 1k/2k/3k = 10%/25%/50%
  sets.precast.WS['Evisceration'] = set_combine(sets.precast.WS,
  { 
    head = gear.globals.adhemar.head,
    hands= gear.globals.mummu.hands,
    legs = gear.globals.lustratio.legs,
    ear1 = "Sherida Earring",
    --back = "dex30 acc/att20 10critrate"
  })
  -- Rudra's Storm: Dagger - Physical - 80% DEX - 26% gravity - Dynamic fTP: 5.0 / 10.19 / 13.0
  sets.precast.WS["Rudra's Storm"] = set_combine(sets.precast.WS,
  {
    head = gear.globals.mummu.head,
    hands= gear.globals.meghanada.hands, -- todo: replace with +3 artifact (meghanada +2 are better than artifact +2)
    legs = gear.globals.dnc.relic.legs,
    neck = gear.globals.dnc.neck,
  })
  -- Climactic Flourish - Forces the first swing of the next X attack rounds to critical hit and grants them a base damage bonus equal to 
    -- 50% of your CHR (at the time the hit lands), where X is the number of Finishing moves consumed upon activation (all available).
  sets.precast.WS["Rudra's Storm"].Climactic = set_combine(sets.precast.WS["Rudra's Storm"],
  {
    head = gear.globals.dnc.empyrean.head
  })
  sets.precast.WS['Wyrrhic Kleos'] = set_combine(sets.precast.WS,
  {
    ammo = "Aurgelmir Orb",
    head = gear.globals.lustratio.head,
    body = gear.globals.adhemar.body,
    hands= gear.globals.adhemar.hands,
    legs = gear.globals.gleti.legs,
    feet = gear.globals.lustratio.feet,
    ear1 = "Sherida Earring",
    back = gear.globals.dnc.capes.da
  })
  -- Aeolian Edge: 40% DEX / 40% INT - Dynamic fTP: 2.0 / 3.0 / 4.5
  sets.precast.WS["Aeolian Edge"] = set_combine(sets.precast.WS,
  {
    head = gear.globals.herculean.head.mab,
    body = gear.globals.nyame.body,
    hands= gear.globals.nyame.hands,
    legs = gear.globals.nyame.legs,
    feet = gear.globals.nyame.feet,
    neck = "Sanctity Necklace",
    waist= "Eschan Stone",
    ear2 = "Friomisi Earring",
    ring1= "Acumen Ring",
    ring2= "Shiva Ring +1",
    back = gear.globals.dnc.capes.mab
  })
  ---------------------------------
  -- buff sets
  ---------------------------------
  sets.buff["Fan Dance"] = { hands = gear.globals.dnc.relic.hands }
  sets.buff["Saber Dance"] = { legs = gear.globals.dnc.relic.legs }
  sets.buff["Climactic Flourish"] = { head = gear.globals.dnc.empyrean.head }
end

---------------------------------
-- display stuff
---------------------------------
function drawDisplay()
  local INDENT = ' ':rep(3)
  local displayLines = L{}

  -- Modes
  displayLines:append('[I]dle: '..state.IdleMode.value)
  displayLines:append('[O]ffense: '..state.OffenseMode.value)

  displayLines:append(' - ')

  local nfr_recast = math.ceil(get_recast_time(223)) -- no foot rise
  local fm = get_finishing_moves();
  displayLines:append('NFR: '..nfr_recast)
  displayLines:append('FM: '..fm)

  displayLines:append(' - ')

  local f1_recast = math.ceil(get_recast_time(221))
  local f2_recast = math.ceil(get_recast_time(222))
  local f3_recast = math.ceil(get_recast_time(226))
  displayLines:append('F1: '..f1_recast)
  displayLines:append('F2: '..f2_recast)
  displayLines:append('F3: '..f3_recast)

  --displayBox:text(displayLines:concat('\\cr\n'))
  displayBox:text(displayLines:concat(' | '))
  displayBox:show()
end

---------------------------------
-- gearswap hooks
---------------------------------
function job_precast(spell, action, spellMap, eventArgs)
  autoPresto(spell)
  --equipDanceSet(spell) -- should not need this 
end

function job_buff_change(buff, gain) 
  -- Is triggered every time you either recieve a buff, or one wears off
  -- buff is the name of the buff, and gain is true if you are getting the buff, and false if the buff is wearing off
  
  handleBuffGear(buff, gain)
end

function job_state_change(field, newValue, oldValue)
  -- any mode changed
  drawDisplay()
end

---------------------------------
-- my functions
---------------------------------
function chat(message)
  add_to_chat(123, message)
end

function autoPresto(spell)
  if spell.type == 'Step' then
    local canPlayerUsePresto = player.main_job_level >= 77
    local recastTimers = windower.ffxi.get_ability_recasts()
    local isPrestoOnCooldown = recastTimers[236] > 0 -- 236 is code for presto 
    local underThreeFinishingMoves = 
      not buffactive['Finishing Move 3'] and 
      not buffactive['Finishing Move 4'] and 
      not buffactive['Finishing Move 5']
  
    if canPlayerUsePresto and not isPrestoOnCooldown and underThreeFinishingMoves then
      cast_delay(1.1)
      send_command('@input /ja "Presto" <me>')
    end
  
  end
end

function handleBuffGear(buffName, gain)
  local buffSet = sets.buff[buffName]
  if buffSet == nil then return end 

  for slot,_ in pairs(buffSet) do
    toggleSlotForBuff(buffName, gain, slot)
  end
end

function toggleSlotForBuff(buffName, gain, slot)
  if gain then
    equip(sets.buff[buffName])
    disable(slot)
    chat('Slot disabled: ' .. slot .. ' - because ' .. buffName .. ' was activated.')
  else
    enable(slot)
    chat('Slot enabled: ' .. slot .. ' - because ' .. buffName .. ' has worn.')
  end
end

function get_recast_time(recast_id)
  local recast_timer = windower.ffxi.get_ability_recasts()[recast_id]
  if recast_timer == nil then return 0 end
  return recast_timer
end

function get_finishing_moves()
  local buffs = S(windower.ffxi.get_player().buffs)
  local finishing_move_ids = 
  { --  ~/res/buffs.lua
    [1] = 381,
    [2] = 382,
    [3] = 383,
    [4] = 384,
    [5] = 385,
    [6] = 588 -- this is actually 6 plus, but it needs to be an integer to be used in logic elsewhere
  }

  for k,v in pairs(finishing_move_ids) do
    if buffs:contains(v) then return k end
  end

  return 0
end
-- function equipDanceSet(spell)
--   local spellName = spell.english
--   if spellName ~= nil then return end
--   -- Jig
--   if (spellName:contains('Jig')) then
--     equip(sets.precast.Jig)
--     return
--   end
--   -- Waltz
--   if (spellName:contains('Waltz')) then
--     if (spell.target == 'self') then
--       equip(sets.precast.WaltzSelf)
--       return
--     end
--     equip(sets.precast.Waltz)
--     return
--   end
--   -- Samba
--   if (spellName:contains('Samba')) then
--     equip(sets.precast.Samba)
--     return
--   end
-- end