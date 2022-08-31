if (!isServer) exitWith {};
waituntil { !isNil "BIS_fnc_init" };
if (!isMultiplayer) then { { doStop _x } forEach switchableUnits };

_officer = TOUR_officer_01;
_officer2 = TOUR_officer_02;
_pilot = TOUR_pilot_01;
_pilot2 = TOUR_pilot_02;
_chopper = TOUR_chopper_01;

/*
//Create Chopper and Pilot
private ["_chopper", "_pilot"];
_chopper = createVehicle ["Mi171Sh_CZ_EP1", [1411,1490,0], [], 0, "CAN_COLLIDE"];
[nil, nil, "per", rSPAWN, [_chopper], { (_this select 0) allowDamage false }] call RE;
_chopper setDir 45;
_chopper setPosATL (getPosATL _chopper);
_chopper addEventhandler ["GetIn", { if (isPlayer (_this select 2)) then { (_this select 2) action ["eject", vehicle (_this select 2)] } }];
_pilot = (createGroup WEST) createUnit ["CZ_Soldier_Pilot_EP1", ([_chopper, 10, 180] call BIS_fnc_relPos), [], 0, "NONE"];
[nil, nil, "per", rSPAWN, [_pilot], { (_this select 0) allowDamage false }] call RE;
_pilot setBehaviour "CARELESS";
_pilot forceSpeed 1.5;
_pilot assignAsDriver _chopper;
_pilot moveInDriver _chopper;
_chopper lockDriver true;

//Create OFFICER
private ["_officer"];
_officer = (createGroup WEST) createUnit ["CZ_Soldier_Office_DES_EP1", [1361.41,1470.16,0], [], 0, "NONE"];
[nil, nil, "per", rSPAWN, [_officer], { (_this select 0) allowDamage false; (_this select 0) setIdentity "Damek" }] call RE;
*/
_officer setIdentity "Damek"; //wrong: this will not set on clients!
_officer removeAlleventHandlers "HandleDamage";
_officer addEventHandler ["HandleDamage", {0}]; 
_officer allowDamage false;

_pilot removeAlleventHandlers "HandleDamage";
_pilot addEventHandler ["HandleDamage", {0}]; 
_pilot allowDamage false;

_pilot2 removeAlleventHandlers "HandleDamage";
_pilot2 addEventHandler ["HandleDamage", {0}]; 
_pilot2 allowDamage false;
//_officer setDir 180;
//_officer setFormDir 180;
//_officer setPosATL (getPosATL _officer);
_officer setBehaviour "CARELESS";
_officer forceSpeed 1.5;

//remove rabbits and incorrect environmental sounds
enableEnvironment false;

//Wait for players (Same as client intro)
sleep 10;

//Officer Moves to players start position and gives the Briefing
_officer doMove getmarkerpos "KAIN_mkr_officerWP1";
waituntil { unitReady _officer };
sleep 1.6;
[TOUR_officer_01, "Acts_BootKoreShootingRange_Adams"] remoteExec ["switchMove", 0, false];
//Acts_Abuse_Lacey
//_officer setDir 180;
//_officer setFormDir 180;
//_officer setPosATL (getPosATL _officer);


//Make Officer say the speech lines
[_officer] spawn
{
	private ["_officer"];
	_officer = _this select 0;
	
	[_officer,"NEO_speech_00"]remoteExec ["TOUR_fnc_directSay", 0];
	sleep 4;
	[_officer,"NEO_speech_01"]remoteExec ["TOUR_fnc_directSay", 0];
	sleep 5;
	[_officer,"NEO_speech_02"]remoteExec ["TOUR_fnc_directSay", 0];
	sleep 8;
	[_officer,"NEO_speech_03"]remoteExec ["TOUR_fnc_directSay", 0];
	sleep 7;
	[_officer,"NEO_speech_04"]remoteExec ["TOUR_fnc_directSay", 0];
	sleep 6;
	[_officer,"NEO_speech_05"]remoteExec ["TOUR_fnc_directSay", 0];
	sleep 13;
	[_officer,"NEO_speech_06"]remoteExec ["TOUR_fnc_directSay", 0];
	sleep 6;
	[_officer,"NEO_speech_07"]remoteExec ["TOUR_fnc_directSay", 0];
	sleep 6;
	[_officer,"NEO_speech_08"]remoteExec ["TOUR_fnc_directSay", 0];
	sleep 3;
	[TOUR_officer_01,"NEO_speech_09"]remoteExec ["TOUR_fnc_directSay", 0];
};


//Add AnimDone EventHandler - This will be used to control the Officer Animations
private ["_animDoneID"];
_animDoneID = _officer addEventHandler ["AnimDone", 
{
	if (local (_this select 0)) then
	{
		private ["_officer", "_anim"];
		_officer = _this select 0;
		_anim = _this select 1;
	
		_officer setVariable ["NEO_officerMoveDone", true]; 
		/*
		switch (true) do
		{
			case (_anim == "c4coming2cdf_genericstani1") : { [nil, _officer, rSWITCHMOVE, "c4coming2cdf_genericstani3"] call RE };
			case (_anim == "c4coming2cdf_genericstani3") : { [nil, _officer, rSWITCHMOVE, "amovpercmstpslowwrfldnon_player_idlesteady01"] call RE; _officer setVariable ["NEO_officerMoveDone", true]; [nil, nil, rSPAWN, [_officer], { (_this select 0) directSay "NEO_speech_08" }] call RE; };
			case DEFAULT { hint format ["AnimDone - %1\n\nNot found\n\nAborting briefing scene...", _anim]; [nil, _officer, rSWITCHMOVE, "amovpercmstpslowwrfldnon_player_idlesteady01"] call RE; _officer setVariable ["NEO_officerMoveDone", true] };
		};
		*/
	};
}];

//Once Animation Scene is done, we remove Event Handler and Make Officer Salute players
waitUntil { !isNil { _officer getVariable "NEO_officerMoveDone" } };
_officer removeEventHandler ["AnimDone", _animDoneID];
sleep 2;
_officer setDir 165;
_officer setFormDir 165;
_officer setPosATL (getPosATL _officer);
sleep 16;
TOUR_officer_01 playAction "Salute";

//Task Update - Defend FOB Assigned
[] spawn
{
	
	waitUntil {KAIN_core getVariable "KAIN_var_tasksCreated"};
	sleep 3;
	["NEO_task_0", "assigned"] call A2S_setTaskState;
	"NEO_task_0" call A2S_taskCommit;
	["NEO_task_0", "taskassigned"] call A2S_taskHint;
};

//Briefing Ends
sleep 3;
TOUR_officer_01 playAction "saluteOff";


sleep 1;
[_officer, false]remoteExec ["enableSentences", 0];


//Make Officer Board The Chopper and leave FOB
_officer doMove (getMarkerPos "KAIN_mkr_officerWP2");
waitUntil { unitReady _officer };
_officer doMove (getPos _chopper);
waitUntil { unitReady _officer };
_officer assignAsCargo _chopper;
_officer moveInCargo _chopper;
_officer2 assignAsCargo _chopper;
_officer2 moveInCargo _chopper;
_chopper doMove (getMarkerPos "KAIN_mkr_chopperEvac");
_chopper flyInHeight 20;

//Delete Officer Chopper
waituntil { unitReady _chopper };
deleteVehicle _officer;
deleteVehicle _officer2;
deleteVehicle _pilot;
deleteVehicle _pilot2;
deleteVehicle _chopper;



//Variable - Intro Ended - Used to make sure we spawn enemies after offcer chopper has been deleted
NEO_coreLogic setVariable ["NEO_introScene_done", true];
