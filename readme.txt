



_____________________________________________________________________________________________________________

 CREDITS: A3




  Author: 	  Kain_Lowsta

  Mission:	  Desert Storm

  Description:	  Ported and adapted for Arma 3

  Version:	  v1.03

  Thanks to: 	  _neo_ for original concept and all Tour members for testing and feedback

  Last Edited: 	  (current) 22/10/21		//(v0.991) 25/03/2019          //(v0.90) 20/09/2017


_____________________________________________________________________________________________________________

 CREDITS: A2




  Author: 	  _neo_

  Mission:	  Desert Storm

  Description:	  Hold a Base in the desert.

  Version:	  1.06

  Voice Acting:	  Marlboro as Officer Damek, OLO as Lt. Vilem and _neo_ as CAS pilot

  Thanks to: 	  Deadfast for Multitask and Name Recognition and all Tour members for testing and feedback

  Last Edited: 	  01/11/2011



_____________________________________________________________________________________________________________

 CHANGELOG




  V0.20 (alpha)(vanilla)

	- Added: FOB Storm made using vanilla A3 assets
	- Added: vehicle wrecks surrounding base
	- Added: Terrain objects outside base (pipeline)


  V0.30

	- Added: Dust particle effect
	- Changed: Weather to match original


  V0.40	

	- Added: Enemy spawn script
	- Changed: AI difficulty increased (A2 values were too easy!)


  V0.50

	- Added: Primary task (defend base)
	- Added: Briefing notes
	- Added: Mines are available from the cache
	- Added: Playable slots to match original
	- Changed: Platoon Commander's 2IC is now a medic not rifleman


  V0.60

	- Added: Briefing intro with original voice acting
	- Added: Add more detail to the FOB

  V0.70

	- Added: Respawn control
	- Added: AIS Revive/medical
	- Changed: Injured units can be stabilised by anyone, anywhere. But can ony be fully revived inside 	  	  the medic building on the base

  V0.80

	- Added: TOUR name recog updated to V4, and implemented
	- Added: Satelite radio dialog interface
	- Added: Ported Close Air Support FSM


  V0.90	

	- Changed: Loading screen image customized for salt lake city
	- Changed: briefing notes show references to A2 factions/places


  V0.963 (beta)

	- Fixed: TOUR_core not available in mission.sqm
	- Fixed: description text is not displayed in lobby
	- Fixed: officer is not named correctly
	- Fixed: Mission name is not displayed in mission select screen


  V0.968

	- Fixed: gear boxes around base still have default gear in
	- Fixed: respawn control does not force correct uniform on respawn	
	- Fixed: respawn control files have references to TOUR_core in them


   V0.97

	- Fixed: Respawn control spectator cam bug where player cannot spectate others after death
	- Fixed: trucks with reinforcement troops have to many in squad
	- Fixed: enemy APC has too much fire power
	- Added: players recieve balaclavas/masks


   v0.98

	- Added: Evac option in satellite radio dialog to abort mission
	- Fixed: DLC helmets are given to players even if they do not own DLC
	- Fixed: saboteur enemies are too rare
	- Fixed: enemies are not difficult enough
	- Fixed: pallets + ammo cans near mortar are floating
	- Fixed: tin fences are floating
	- Fixed: sandbag was misplaced at top of radio tower
	- Fixed: jerry can at transmitter building is clipping ground
	- Fixed: mortar is bugged: player gets stuck inside
	- Fixed: thick fog takes too long to develop
	- Fixed: Too much overcast by end of mission
	- Fixed: _neo_ garbage script not removing AI bodies after death in MP


   v0.99

	- Added: Rescue the pilot task
	- Added: Ammo cache
	- Fixed: Remove rabbits
	- Fixed: No side chat radio messages are played when CAS/EVAC is called
	- Fixed: Sound assets too quiet
	- Fixed: Error when radio dialog opened
	- Fixed: Players see AI too soon
	- Fixed: HQ doesn't call the sat phone at the end
	- Fixed: radiotower sandbags floating after tower destroyed
	- Fixed: Player can complete the mission even if base is overun with enemies
	- Fixed: first aid time takes too long
	- Fixed: mission doesnt end if all players are bleeding out
	- Fixed: No hint about using medic bulding to heal
	- Fixed: AI vehicles can't pathfind around the base
	- Fixed: objects around mortar causing injuries
	- Fixed: enemy heli won't move
	- Fixed: static weapons have thermal
	- Fixed: static weapons' backpacks dissapear on roofs when dissasembled in a bunker
	- Fixed: nametags shows 'error no unit' when incapacitated using AIS revive
	- Fixed: Vcom AI compatibility
	- Changed: Tweaked player loadouts
	- Changed: more troops in reinforcement trucks
	- Removed: TOUR respawn control

   v0.991
	
	- Fixed: repeated error in RPT: fn_hasRadio.sqf 


   v0.995 (+mods)

	Added: New loadouts for player, enemy and NPCs
	Added: A2 humvee to replace A3 vehicle
	Added: More debug options
	Fixed: Supply crates don't have correct ammo anymore
	Fixed: Wrong faction for friendly NPCs
	Fixed: Hide bodies causing lag
	Fixed: Enemy UAZ gunner not mounted
	Fixed: Enemy  V3S troops not in cargo
	Fixed: Enemy UAZ and APC groups have too many men
	Fixed: Enemy infantry standing in the desert
	Fixed: Enemy vehicles stuck at spawn
	Fixed: Enemy spec ops team not spawning
	Removed: VCOM AI, AIS medical, TOUR nametags and Field Radio scripts (depreciated)


   v0.998

	Added: Moved mission to the Desert map
	Added: Remade FOB storm using A2 mod structures
	Added: More slots: increased player count from 20 to 30
	Added: More debug options
	Added: Action to move weapon optic to rear rail
	Added: New Tour respawn control
	Added: Command bunker laptop screen saver
	Added: New FOB Storm sign at front gate
	Fixed: Evac chopper gunners have incorrect uniform
	Fixed: Can't save the pilot in the side task (now uses ACE medical)
	Fixed: FOB map marker is not correct
	Fixed: Briefing text doesn't match the new map
	Fixed: Players dont have ace radios or bandages
	Fixed: Magazine getting placed in uniform
	Fixed: Player can't shoot before selecting firemode
	Fixed: Player can't heal at medic tent (now uses ACE medical)
	Fixed: Debug only works in SP
	Fixed: Enemy spec ops have NVGs and supressors
	Changed: AI difficulty set to current Tour default


   RC1

	Fixed: Some systemchat and debug markers visible
	Fixed: Duty completing immediately
	Fixed: Tents getting squashed
	Fixed: Chopper pilots don't speak
	Fixed: CAS grid reference not correct
	Fixed: Cant take bandages
	Fixed: Shipping containers don't open at both ends
	Fixed: CAS is invisible for clients
	Fixed: Pilot task doesn't fail if he dies


   v1.00

	Fixed: Destroying comm dish doesn't prevent CAS
	Fixed: CAS pilot being killed by chopper cookoff
	Fixed: CAS pilot bleeding out too fast 
	Fixed: Misalligned base objects
	Fixed: Vehicle wrecks aren't randomized

   v1.01

	Fixed: Pilot task doesnt complete
	Fixed: move optic action - undefined variable in _player
	Fixed: Respawn control is out of date
	Fixed: injured upon respawn

  
   v1.03

	Added: New tent interiors
	Added: Debriefing text
	Fixed: Broken sat comm
	Fixed: Rescue pilot task called repeatedly
	Fixed: moveOptic action missing after respawn
	Fixed: Can complete mission even if base is over-run
	Fixed: Damak can be killed
	Fixed: No pilot task hint
	Changed: Increased mission length to 1hr (from 45mins)
	

_____________________________________________________________________________________________________________
	
  Known Bugs (Current)


	didnt end when all incapacitated
	When all players defeated, mission ended but didn't go to debriefing
	tables can be moved with ace


	
	weapon disasembly happens slowly (because function is spawned)
	Default vehicle AI is a bit derpy
	some tire tracks at main entrance not visible
	Mortar strike needed?


___________________________________________________________________________________________________________


  Known Bugs & TODO (pre v0.992)

	- CAS helo crew do not get setCaptive correctly sometimes
	- intro briefing by officer - sound does not fade as player moves away
	- hidden radio sound clips which were never used	
	- there are no leaflets blowing in the wind

