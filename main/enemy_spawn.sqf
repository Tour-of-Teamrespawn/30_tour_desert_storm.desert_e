//Spawn enemy waves and make them move and attack the base
createCenter INDEPENDENT;
RESISTANCE setFriend [WEST, 0];
WEST setFriend [RESISTANCE, 0];

if (!(isNil "KAIN_debugOn_quickStart") or (KAIN_ds_attackDelay == 2) or (KAIN_ds_attackDelay == 3)) then 
{
	deleteVehicle TOUR_officer_01;
	deleteVehicle TOUR_officer_02;
	deleteVehicle TOUR_pilot_01;
	deleteVehicle TOUR_pilot_02;
	deleteVehicle TOUR_chopper_01;
	systemchat "Intro dialogue: Skip";
} 
else { waituntil { !isNil { NEO_coreLogic getVariable "NEO_introScene_done" }}; sleep 10; };	//Wait for Intro Scene is finnished and officer has been deleted};

if (KAIN_ds_attackDelay == 0) then {sleep 300 + random 300} else 
{
	switch (KAIN_ds_attackDelay) do 
	{
		case 1: {systemchat "Selected attack delay: 5 mins"; sleep 301};
		case 2: {systemchat "Selected attack delay: 60 secs"; sleep 61};
		case 3: {systemchat "Selected attack delay: 0 secs"; sleep 1};
		case 4: {systemchat "Selected attack delay: NEVER"; waitUntil {count (playableUnits+switchableUnits) == 0}}; //attack is never spawned
	};
};
systemchat "The attack began";

//Parameters
private ["_center", "_timeOut", "_maxEnemies", "_maxMechanized", "_maxArmored", "_maxAir", "_minSaboteur", "_maxSaboteur", "_distInf", "_distMoto", "_distMech", "_distArmor", "_distAir", "_grp"];
_center = getPos NEO_basePosition;							//Center, spawn occurs around it
_timeOut = 2850;											//Spawn time - default: 2250
_maxEnemies = round ([100, 120] call BIS_fnc_randomNum);	//Maximum number of enemies to be alive and in map at same time
_maxMechanized = 15;										//Maximum Mechanized groups to spawn
_maxArmored = 5;											//Maximum Armored groups to spawn
_maxAir = 1;												//Maximum Air groups to spawn
_distInf = [750, 1000];										//Min-Max Distance Infantry groups spawn in relation to center position
_distMoto = [1000, 1250];									//Min-Max Distance Motorized groups spawn in relation to center position
_distMech = [1250, 1500];									//Min-Max Distance Mechanized groups spawn in relation to center position
_distArmor = [2000, 2500];									//Min-Max Distance Armored groups spawn in relation to center position
_distAir = [3000, 4000];									//Min-Max Distance Air groups spawn in relation to center position

_center set [2, 0];									

//Arrays
private ["_infantry", "_motorized", "_mechanized", "_armored", "_air"];
_infantry = ["UK3CB_TKA_I_RIF_Squad", "UK3CB_TKA_I_RIF_Squad", "UK3CB_TKA_I_RIF_Squad", "UK3CB_TKA_I_AA_FireTeam", "UK3CB_TKA_I_MG_Squad", "UK3CB_TKA_I_Recon_SpecSquad", "UK3CB_TKA_I_Recon_SpecSquad"];		//UK3CB_TKA_I_Recon_SpecSquad - should be 2x spec ops instead of last two RIF_squads - but they wont spawn using BIS_fnc_createGroup!												//Infantry Group types
_motorized = ["UK3CB_TKA_I_V3S_Open_Motorised_MG_Squad", "UK3CB_CHD_I_UAZ_MG_Sentry"];													//Motorized Group Types
_mechanized = ["UK3CB_TKA_I_BMP2_Mechanized_RIF_Squad", "UK3CB_TKA_I_BMP1_Mechanized_RIF_Squad", "UK3CB_TKA_I_M113_M2_Mechanized_MG_Squad", "UK3CB_TKA_I_MTLB_Mechanized_RIF_Squad"];																//Mechanized Group Types
_armored = ["UK3CB_TKA_I_TankPlatoon", "UK3CB_TKA_I_TankSection"];																												//Armor group types
_air = ["RHS_Mi24P_vvs", "RHS_Mi8AMTSh_vvs", "UK3CB_ADA_O_UH1H", "UK3CB_TKA_O_Su25SM"]; //Air group types

_extVehWPs = ["KAIN_mkr_vehEXT_01", "KAIN_mkr_vehEXT_02", "KAIN_mkr_vehEXT_03", "KAIN_mkr_vehEXT_04", "KAIN_mkr_vehEXT_05", "KAIN_mkr_vehEXT_06", "KAIN_mkr_vehEXT_07", "KAIN_mkr_vehEXT_08", "KAIN_mkr_vehEXT_09", "KAIN_mkr_vehEXT_10", "KAIN_mkr_vehEXT_11", "KAIN_mkr_vehEXT_12", "KAIN_mkr_vehEXT_13", "KAIN_mkr_vehEXT_14", "KAIN_mkr_vehEXT_15"];
_intVehWPs = ["KAIN_mkr_vehINT_00", "KAIN_mkr_vehINT_01", "KAIN_mkr_vehINT_02", "KAIN_mkr_vehINT_03"];

//What types to spawn - "Mechanized", "Armored", "Air" - Added later
NEO_grpTypes = ["Infantry", "Infantry", "Infantry", "Infantry", "Infantry", "Motorized", "Motorized"];
//systemchat "1";
[] spawn
{
	if (isMultiplayer) then 
	{
		if (("KAIN_par_quickStart" call BIS_fnc_getParamValue) == 0) then //normal start
		{
			waitUntil { time > (300 + (random 200)) };
			NEO_grpTypes set [(count NEO_grpTypes), "Mechanized"];
			waitUntil { time > (600 + (random 300)) };
			NEO_grpTypes set [(count NEO_grpTypes), "Armored"];
			waitUntil { time > (900 + (random 400)) };
			NEO_grpTypes set [(count NEO_grpTypes), "Air"];
		} 
		else //quick start
		{
			NEO_grpTypes set [(count NEO_grpTypes), "Mechanized"];
			waitUntil { time > 180 };
			NEO_grpTypes set [(count NEO_grpTypes), "Armored"];
			waitUntil { time > 300};
			NEO_grpTypes set [(count NEO_grpTypes), "Air"];
		};
	} 
	else //SP
	{
		NEO_grpTypes set [(count NEO_grpTypes), "Mechanized"];
		waitUntil { time > 180 };
		NEO_grpTypes set [(count NEO_grpTypes), "Armored"];
		waitUntil { time > 300};
		NEO_grpTypes set [(count NEO_grpTypes), "Air"];
	};
};

//systemchat "2";
//Main Loop
while { (time < _timeOut) && !(NEO_coreLogic getVariable "NEO_baseRadio_missionAborted") && !(NEO_coreLogic getVariable "NEO_baseRadio_missionCompleted") } do
{
	//systemchat "3";
	_maxGrps = (6 + (round (random 6)));
	for "_i" from 1 to _maxGrps do
	{
		//systemchat "4";
		private ["_total"];
		_total = []; 
		{ if (alive _x && side _x == independent) then { _total set [count _total, _x] } } forEach allUnits;
		
		if (count _total < _maxEnemies) then
		{
			if !(isNil "KAIN_debugOn_spawnEnemy" ) then 
			{
				for "_i" from 1 to 2 do 
				{
					hint "";
					sleep 0.1;
					hint "initializing";
					sleep 0.1;
				};
				hint format ["creating group\n______________\n    %1 of %2", _i, _maxGrps]; //hint groups to spawn (iteration and total)
			};
			
			//all override of spawn distance for debug
			if (isMultiplayer) then 
			{
				if ("KAIN_par_debug" call BIS_fnc_getParamValue == 1) then
				{
					_distInf = [150, 150];										
					_distMoto = [400, 400];									
					_distMech = [600, 600];								
					_distArmor = [900, 900];									
					_distAir = [1500, 1500];
				};
			} 
			else 
			{
				_distInf = [150, 150];										
				_distMoto = [400, 400];									
				_distMech = [600, 600];								
				_distArmor = [900, 900];									
				_distAir = [1500, 1500];
			};
			
			//systemchat "5";
			private ["_type", "_grpClass", "_posSpawn", "_dist", "_dir", "_grp", "_grp2", "_wp", "_tries", "_height", "_radius", "_foundValidPos", "_mkr", "_leader", "_vehicle"];
			_type = NEO_grpTypes call BIS_fnc_selectRandom;
			_grpClass = "";
			_posSpawn = [];
			_dist = 0;
			_dir = random 360;
			_grp = grpNull;
			_tries = 0;
			_height = 0;
			_radius = 50;

			switch (_type) do
			{
				case "Infantry" : 
				{
					_dist = _distInf call BIS_fnc_randomNum;
					_grpClass = _infantry call BIS_fnc_selectRandom;
				};
				case "Motorized" : 
				{
					_dist = _distMoto call BIS_fnc_randomNum;
					_grpClass = _motorized call BIS_fnc_selectRandom;
				};
				case "Mechanized" : 
				{
					_dist = _distMech call BIS_fnc_randomNum;
					_grpClass = _mechanized call BIS_fnc_selectRandom;
					
					_maxMechanized = _maxMechanized - 1;
					if (_maxMechanized < 1) then 
					{ 
						NEO_grpTypes = NEO_grpTypes - ["Mechanized"];
					};
				};
				case "Armored" : 
				{
					_dist = _distArmor call BIS_fnc_randomNum;
					_grpClass = _armored call BIS_fnc_selectRandom;
					
					_maxArmored = _maxArmored - 1;
					if (_maxArmored < 1) then 
					{ 
						NEO_grpTypes = NEO_grpTypes - ["Armored"];
					}; 
				};
				case "Air" : 
				{
					_height = 500;
					_dist = _distAir call BIS_fnc_randomNum;
					_grpClass = _air call BIS_fnc_selectRandom;
					
					_maxAir = _maxAir - 1;
					if (_maxAir < 1) then 
					{ 
						NEO_grpTypes = NEO_grpTypes - ["Air"];
					};
				};
			};
			
			//hint type of group
			if !(isNil "KAIN_debugOn_spawnEnemy" ) then {hint format ["creating group\n______________\n    %1 of %2\n %3:  %4", _i, _maxGrps, _type, _grpClass]; sleep 1;};
			
			//find a spawn position which is not over water
			_foundValidPos = false;
					
			For "_i" from 1 to 4 do 
			{
				_posSpawn = _center getPos [_dist, _dir];
				if !(isNil "KAIN_debugOn_spawnEnemy" ) then 
				{ 
					_mkr = createMarker [str _posSpawn, _posSpawn];
					_mkr setMarkerShape "ICON";
					_mkr setMarkerBrush "BORDER";
					_mkr setMarkerType "mil_dot"; 
					_mkr setMarkerSize [2, 2]; 
					_mkr setMarkerColor "ColorRed";
					_mkr setMarkerText (str _grpClass);					
				};
				
				//allow choppers and planes to spawn over sea, and land vehicles only over land
				if !(surfaceIsWater _posSpawn) exitWith {_foundValidPos = true};
				if ((_grpClass == "RHS_Mi24P_vvs") or (_grpClass == "RHS_Mi8AMTSh_vvs") or (_grpClass == "UK3CB_ADA_O_UH1H") or (_grpClass == "UK3CB_TKA_O_Su25SM")) exitWith {_foundValidPos = true};
								 
				//hint when searching for position on land
				if !(isNil "KAIN_debugOn_spawnEnemy" ) then {hint "";sleep 0.1;hint format ["creating group\n______________\n    %1 of %2\n %3:  %4\n______________\n   finding safe spawnpoint", _i, _maxGrps, _type, _grpClass]; sleep 0.1;};
				
				switch (_type) do
				{
					case "Infantry" : {_dist = _distInf call BIS_fnc_randomNum;};
					case "Motorized" : {_dist = _distMoto call BIS_fnc_randomNum;};
					case "Mechanized" : {_dist = _distMech call BIS_fnc_randomNum;};
					case "Armored" : {_dist = _distArmor call BIS_fnc_randomNum;};
					case "Air" : {_dist = _distAir call BIS_fnc_randomNum;};
				};
				
				if !(isNil "KAIN_debugOn_spawnEnemy" ) then {deleteMarker _mkr ; sleep 0.5;};
			};
			
			while {!_foundValidPos} do //if cannot find safe spawn place, try closer to base
			{
				if !(isNil "KAIN_debugOn_spawnEnemy" ) then {hint "cannot find a safe place to spawn";};
				
				_distInf = [(_distInf select 0)*0.75,(_distInf select 1)*0.75];
				_distMoto = [(_distMoto select 0)*0.75,(_distMoto select 1)*0.75];
				_distMech = [(_distMech select 0)*0.75,(_distMech select 1)*0.75];
				_distArmor = [(_distArmor select 0)*0.75,(_distArmor select 1)*0.75];
				_distAir = [(_distAir select 0)*0.75,(_distAir select 1)*0.75];
				
				For "_i" from 1 to 4 do 
				{
					_posSpawn = _center getPos [_dist, _dir];
					if !(isNil "KAIN_debugOn_spawnEnemy" ) then 
					{ 
						_mkr = createMarker [str _posSpawn, _posSpawn];
						_mkr setMarkerShape "ICON";
						_mkr setMarkerBrush "BORDER";
						_mkr setMarkerType "mil_dot"; 
						_mkr setMarkerSize [2, 2]; 
						_mkr setMarkerColor "ColorRed";
						_mkr setMarkerText (str _grpClass);					
					};
					
					if !(surfaceIsWater _posSpawn) exitWith {_foundValidPos = true}; 
					
					//hint when searching for position on land
					if !(isNil "KAIN_debugOn_spawnEnemy" ) then {hint ""; sleep 0.1; hint format ["creating group\n______________\n    %1 of %2\n %3:  %4\n______________\n   finding safe spawnpoint", _i, _maxGrps, _type, _grpClass]; sleep 0.1;};
					
					switch (_type) do
					{
						case "Infantry" : {_dist = _distInf call BIS_fnc_randomNum;};
						case "Motorized" : {_dist = _distMoto call BIS_fnc_randomNum;};
						case "Mechanized" : {_dist = _distMech call BIS_fnc_randomNum;};
						case "Armored" : {_dist = _distArmor call BIS_fnc_randomNum;};
						case "Air" : {_dist = _distAir call BIS_fnc_randomNum;};
					};
					
					if !(isNil "KAIN_debugOn_spawnEnemy" ) then {deleteMarker _mkr ;sleep 0.5;};
				};
				
			};
			_posSpawn set [2, _height];
			
			//hint spawn found
			if !(isNil "KAIN_debugOn_spawnEnemy" ) then {hint format ["creating group\n______________\n    %1 of %2\n %3:  %4\n______________\n   spawnpoint found", _i, _maxGrps, _type, _grpClass]; sleep 1;};
			
			//spawn group using the correct call dependant on type/class
			if (_type == "Air") then 
			{
				_grp = [_posSpawn, INDEPENDENT, [_grpClass]] call BIS_fnc_spawnGroup
			} 
			else 
			{
				if ((_type == "Motorized") && (_grpClass == "UK3CB_CHD_I_UAZ_MG_Sentry")) then 
				{
					_grp = [_posSpawn, INDEPENDENT, (configFile >> "CfgGroups" >> "Indep" >> "UK3CB_CHD_I" >> _type >> _grpClass)] call BIS_fnc_spawnGroup;
				} 
				else 
				{
					if (_grpClass == "UK3CB_TKA_I_Recon_SpecSquad") then 
					{
						_grp = [_posSpawn, INDEPENDENT, (configFile >> "CfgGroups" >> "Indep" >> "UK3CB_TKA_I" >> "SpecOps" >> _grpClass)] call BIS_fnc_spawnGroup;
					} 
					else 
					{
						_grp = [_posSpawn, INDEPENDENT, (configFile >> "CfgGroups" >> "Indep" >> "UK3CB_TKA_I" >> _type >> _grpClass)] call BIS_fnc_spawnGroup; //standard infantry
					};
				};
			};
			
			//hint spawned
			if !(isNil "KAIN_debugOn_spawnEnemy" ) then {hint format ["creating group\n______________\n    %1 of %2\n %3:  %4\n______________\n   spawnpoint assigned\n______________\n   group spawned", _i, _maxGrps, _type, _grpClass]; sleep 1;};
			
			_leader = leader _grp;
			_leaderPos = getPos _leader;
			_vehicle = vehicle (_leader);
			_units = units _grp;
			_leader setVariable ["KAIN_hasOrders", false];
			
			//customize each unit
			{
				_x call TOUR_fnc_loadouts;	//set Tour default skill level			
				_x call NEO_fnc_garbageAdd;
				_x setBehaviour "AWARE";
				
				//remove unwanted items
				if ("NVGoggles_OPFOR" in assignedItems _x) then 
				{
					_x unassignItem "NVGoggles_OPFOR";
					_x removeItem "NVGoggles_OPFOR";
				};
				if ("muzzle_snds_B" in primaryWeaponItems _x) then {_x removePrimaryWeaponItem "muzzle_snds_B"};
				if ("rhsusf_acc_harris_swivel" in primaryWeaponItems _x) then {_x removePrimaryWeaponItem "rhsusf_acc_harris_swivel"};
				if ("rhs_acc_pbs1" in primaryWeaponItems _x) then {_x removePrimaryWeaponItem "rhs_acc_pbs1"};
				if ("rhs_acc_dtk4short" in primaryWeaponItems _x) then {_x removePrimaryWeaponItem "rhs_acc_dtk4short"};
				
				
				//troops wont mount in rear V3S without being assigned
				if ((_type == "Motorized") or (_type == "Mechanized")) then 
				{
					if (_x==vehicle _x) then {systemchat "enemy mounting up"; _x assignAsCargo _vehicle; _x moveInCargo _vehicle};  //dont eject the driver
				};
				
				if !(isNil "KAIN_debugOn_spawnEnemy" ) then //debug markers
				{ 
					_mkr = createMarker [str (position _x), position _x];
					_mkr setMarkerShape "ICON";
					_mkr setMarkerBrush "BORDER";
					_mkr setMarkerType "mil_dot"; 
					_mkr setMarkerSize [0.75, 0.75]; 
					_mkr setMarkerColor "ColorYellow"; 
				};
			} forEach units _grp;
			
			//hint attributes set
			if !(isNil "KAIN_debugOn_spawnEnemy" ) then {hint format ["creating group\n______________\n    %1 of %2\n %3:  %4\n______________\n   spawnpoint assigned\n______________\n   group spawned\n______________\n   attributes set", _i, _maxGrps, _type, _grpClass]; };sleep 2;
			
			//remove extra units which dont fit in vehicles
			sleep 1;
			if (_type != "Infantry") then {{if (_x==vehicle _x) then {deleteVehicle _x}} forEach _units};
			
			//make sure group has no existing waypoints
			for "_i" from count waypoints _grp - 1 to 0 step -1 do
			{
				deleteWaypoint [_grp, _i];
			};

			//sleep 5;
			//hunt the players
			KAIN_fnc_searchAndDestroy = 
			{
				params ["_grp", "_pos"];
				_wp = _grp addWaypoint [_pos, 50];
				_grp setVariable ["KAIN_enemyGroupWaypointPos", waypointPosition _wp];
				
				_wp setWaypointBehaviour "AWARE";
				_wp setWaypointCombatMode "RED";
				_wp setWaypointSpeed "NORMAL";
				_wp setWaypointType "SAD";
				
				//debug markers
				_wpPos = waypointPosition [_grp, 0];
				_wpPos set [2, (_wpPos select 2)+2.5]; //make sure marker can be seen by raising it up
				_helper = "Sign_Sphere200cm_F" createVehicleLocal [0,0,0];
				_helper setPos _wpPos;
				
			};
			
			sleep 1;
			[_grp, _center] call KAIN_fnc_searchAndDestroy;
			sleep 1;
			if (true) then {(driver vehicle _leader) moveTo (_center getPos [60, _center getDir getPos _leader])}; //give vehicles a nudge incase they refuse to move
			
			//nerf
			_vehicle disableTIEquipment true;
			_grp reveal (selectRandom (playableUnits+switchableUnits));
						
			//hint waypoint assigned
			if !(isNil "KAIN_debugOn_spawnEnemy" ) then {hint format ["creating group\n______________\n    %1 of %2\n %3:  %4\n______________\n   spawnpoint assigned\n______________\n   group spawned\n______________\n   attributes set\n______________\n   waypoint assigned", _i, _maxGrps, _type, _grpClass]; };
			sleep 2;
		};
	};
	
	//Delay between spawns
	private ["_newTotal"];
	_newTotal = [];	{ if (alive _x && side _x == independent) then { _newTotal set [count _newTotal, _x] } } forEach allUnits;
	
	if (count _newTotal < (_maxEnemies / 2)) then
	{
		if !(isNil "KAIN_debugOn_spawnEnemy" ) then {hint "Current wave finished. Short sleep";};
		if (isMultiplayer) then {if ("KAIN_par_attackFrequency" call BIS_fnc_getParamValue == 0) then {sleep 150} else {sleep 30}} else {sleep 30};
	}
	else
	{
		if (count _newTotal < _maxEnemies) then
		{
			if !(isNil "KAIN_debugOn_spawnEnemy" ) then {hint "Current wave finished. Medium sleep";};
			if (isMultiplayer) then {if ("KAIN_par_attackFrequency" call BIS_fnc_getParamValue == 0) then {sleep 300} else {sleep 60}} else {sleep 60};
		}
		else
		{
			if !(isNil "KAIN_debugOn_spawnEnemy" ) then {hint "Current wave finished. Long sleep";};
			if (isMultiplayer) then {if ("KAIN_par_attackFrequency" call BIS_fnc_getParamValue == 0) then {sleep (400 + random 200)} else {sleep 100}} else {sleep 100};
		};
	};
};