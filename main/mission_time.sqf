if (!isServer) exitWith {};
waituntil { !isNil "BIS_fnc_init" };

/*
//Mission Time
if (isDedicated) then 
{
	//allow admin to select how long the mission lasts for debugging
	_dutyLength = "KAIN_par_dutyLength" call BIS_fnc_getParamValue;
	switch {_dutyLength} do 
	{
		case (0): {sleep 2750};
		case (1): {sleep 1800};
		case (2): {sleep 600};
		case (3): {sleep 300};
		case (4): {sleep 1};
	};
} else {sleep 300};
hint "shift complete";
*/
_sleep = 3300;
_stamp = time;
KAIN_endKey = false;
waitUntil {((time - _stamp) > _sleep) or (KAIN_endKey)};


//End Mission if FOB is overun
_alivePlayers = {_x distance (getPosATL NEO_basePosition) < 75} count (playableUnits+switchableUnits);
_aliveEnemy = {(alive _x) && !(isPlayer _x) && (side _x == independent) && ((_x distance (getPosATL NEO_basePosition)) < 75)} count allUnits;

if (_alivePlayers < _aliveEnemy) then //
{
	["NEO_task_0", "FAILED"] call A2S_setTaskState;
	["NEO_task_0", "taskfailed"] call A2S_taskHint;
	"NEO_task_0" call A2S_taskCommit;
	
	["NEO_task_1", "FAILED"] call A2S_setTaskState;
	["NEO_task_1", "taskfailed"] call A2S_taskHint;
	"NEO_task_1" call A2S_taskCommit;
		
	"overrun" call BIS_fnc_endMissionServer;
	
	NEO_spec = nil;
	publicVariable "NEO_spec";
} 
else 
{
	//if players keep FOB clear of enemy by time mission ends
	if !(NEO_coreLogic getVariable "NEO_baseRadio_missionAborted") then
	{
		NEO_coreLogic setVariable ["NEO_baseRadio_radioOccupied", true, true];
		NEO_coreLogic setVariable ["NEO_baseRadio_hqCalling", true, true];
		NEO_coreLogic setVariable ["NEO_baseRadio_playerResponds", false, true];
		
		//Wait for a player to answer the radio
		while { !(NEO_coreLogic getVariable "NEO_baseRadio_playerResponds") } do
		{
			private ["_speech"];
			_speech = 
			[
				["ds_officer_00", "HQ TO BISHOP ONE. OVER."], 
				["ds_officer_01", "GOD DAMMIT BISHOP ONE, PICKUP THE RADIO ASAP."], 
				["ds_officer_02", "DO YOU READ BISHOP ONE? OVER."]
				
			] call BIS_fnc_selectRandom;
			
			[NEO_radio, (_speech select 0)] remoteExec ["say", 0, false];
			[NEO_HQradio, [(_speech select 1)]] spawn TOUR_fnc_sideRadio;
			
			private ["_timeOut"];
			_timeOut = (time + (5 + (random 5)));
			
			waitUntil { (time > _timeOut) || (NEO_coreLogic getVariable "NEO_baseRadio_playerResponds") };
		};
		
		NEO_coreLogic setVariable ["NEO_baseRadio_hqCalling", false, true];
		NEO_coreLogic setVariable ["NEO_baseRadio_playerResponds", false, true];
		NEO_coreLogic setVariable ["NEO_baseRadio_radioOccupied", false, true];
		
		//Mission is completed, send EVAC with replacement Team
		NEO_coreLogic setVariable ["NEO_baseRadio_missionCompleted", true, true];
		[] execFSM "main\evac.fsm";
		
		//Here we update main task - Succeeded
		["NEO_task_0", "SUCCEEDED"] call A2S_setTaskState;
		["NEO_task_0", "tasksucceeded"] call A2S_taskHint;
		"NEO_task_0" call A2S_taskCommit;
		
		sleep 2.5;
		[NEO_radio, "ds_officer_03"] remoteExec ["say", 0, false];
		[NEO_radio, "BISHOP 1, WE ARE SENDING ANOTHER TEAM TO REPLACE YOU. HOLD ON 2 MORE MINUTES, CHOPPER ON THE WAY, OVER."] remoteExec ["sideChat", 0, false];
		
		sleep 10;
		
		//Enemy flees away from FOB
		{
			if (count units _x > 0 && side leader _x == EAST) then
			{
				private ["_grp", "_leader", "_dist", "_dir", "_pos", "_wp"];
				_grp = _x;
				_leader = leader _grp;
				_dist = 4000;
				_dir = [NEO_basePosition, _leader] call BIS_fnc_dirTo;
				_pos = [NEO_basePosition, _dist, _dir] call BIS_fnc_relPos;
				_wp = currentWaypoint _grp;
				
				_wp setWaypointPosition [_pos, 0];
				_wp setWaypointBehaviour "CARELESS";
				_wp setWaypointCombatMode "BLUE";
				_wp setWaypointSpeed "FULL";
				_wp setWaypointType "MOVE";
				
				_grp enableAttack false;
				{ _x allowFleeing 1 } forEach units _grp;
			};
		} forEach allGroups;
	};
};

