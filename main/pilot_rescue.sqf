if (!isServer) exitWith {};
waitUntil { !isNil "BIS_fnc_init" };
NEO_coreLogic setVariable ["NEO_savePilot", true, true];

private ["_chopper"];
_chopper = _this select 0;

//Wait until chopper hit the ground
waitUntil { getPosATL _chopper select 2 < 5 };
sleep 5;

//Chopper must not be near base and not to far so rescue mission is activated
if (((_chopper distance NEO_basePosition) > 400) || ((_chopper distance NEO_basePosition) < 100)) exitWith 
{
	[[],
	{
		enableRadio true;
		enableSentences true;
		sleep 2;
		NEO_CASradio sideRadio "NEO_speech_19b";
		sleep 10;
		enableSentences false;
		enableRadio false;
		
	}] remoteExec ["spawn", 0, false];
};

private ["_pos"];
_pos = getPos _chopper;

//Create Pilot
private ["_pilot", "_logic"];
_pilot = (createGroup WEST) createUnit ["UK3CB_ADA_B_HELI_PILOT", [0,0,0], [], 0, "NONE"];
_crashPos = ([_pos, 5, (([_chopper, NEO_basePosition] call BIS_fnc_dirTo) + 180)] call BIS_fnc_relPos);
NEO_coreLogic setVariable ["NEO_casPilot", _pilot, true];
NEO_pilot = _pilot;

//Event Handler
_pilot addEventHandler ["Killed", 
{
	if (local (_this select 0)) then
	{
		["NEO_task_1", "FAILED"] call A2S_setTaskState;
		["NEO_task_1", "taskfailed"] call A2S_taskHint;
		"NEO_task_1" call A2S_taskCommit;
	};
}];

//Variables
NEO_coreLogic setVariable ["NEO_pilotRescueStarted", true, true];
NEO_coreLogic setVariable ["NEO_pilotRescued", false, true];

//Dialog from Pilot
[[_pos],
{
	_pos = _this select 0;
	enableRadio true;
	enableSentences true;
	sleep 2;
	NEO_CASradio sideRadio "NEO_speech_17";
	sleep 8;
	enableSentences false;
	enableRadio false;

}] remoteExec ["spawn", 0, false];

//Task
//Create Rescue Pilot Task
["NEO_task_1", {localize "STR_TASK_1_TITLE"}] call A2S_createSimpleTask;
["NEO_task_1", {localize "STR_TASK_1_TEXT"}, {localize "STR_TASK_1_TITLE"}, {localize "STR_TASK_1_HUD"}] call A2S_setSimpleTaskDescription;
["NEO_task_1", _pos] call A2S_setSimpleTaskDestination;
"NEO_task_1" call A2S_taskCommit;
["NEO_task_1", "ASSIGNED"] call A2S_setTaskState;
["NEO_task_1", "taskassigned"] call A2S_taskHint;
"NEO_task_1" call A2S_taskCommit;

//injure the pilot manually
[_pilot, 1] call ace_medical_status_fnc_adjustPainLevel;
[_pilot, 0.45, "rightleg", "stab"] call ace_medical_fnc_addDamageToUnit;
[_pilot, 0.25, "leftleg", "explosion"] call ace_medical_fnc_addDamageToUnit;
[_pilot, true, true, true, true] call ace_medical_engine_fnc_updateBodyPartVisuals;

//remove ACE damage before creating invincibility
_pilot removeAlleventHandlers "HandleDamage";
_pilot addEventHandler ["HandleDamage", {0}]; 
_pilot allowDamage false;

[_pilot] spawn 
{
	params ["_pilot"];
	while {isNil "KAIN_pilotSafeDistance" && alive _pilot} do 
	{
		[_pilot, true, true, true, true] call ace_medical_engine_fnc_updateBodyPartVisuals; //update blood manually since ace is disabled
		sleep 2;
	};
};

//move into position
sleep 3;
_pilot setPos _crashPos;
"Land_ClutterCutter_small_F" createVehicle (getPos _pilot);
sleep 0.1;
["blooddrop_1", (_pilot selectionPosition "rightfoot")] call ace_medical_blood_fnc_createBlood;
["blooddrop_2", (_pilot selectionPosition "rightleg")] call ace_medical_blood_fnc_createBlood;
["blooddrop_3", (_pilot selectionPosition "torso")] call ace_medical_blood_fnc_createBlood;
["blooddrop_4", (_pilot selectionPosition "pelvis")] call ace_medical_blood_fnc_createBlood;

//trigger ragdoll
sleep 3;
[_pilot, true] call ace_medical_status_fnc_setUnconsciousState; 
sleep 1;

//setup pilot
doStop _pilot;
_pilot setBehaviour "COMBAT";
_pilot setCombatMode "RED";
_pilot disableAi "MOVE";
_pilot setCaptive true;
_pilot lookAt NEO_basePosition;
_pilot glanceAt NEO_basePosition;

//Trigger
//When player is close to pilot he will look to player and speak
private ["_pilotTrigger"];
_pilotTrigger = createTrigger ["EmptyDetector", getPosATL _pilot];
_pilotTrigger attachTo [_pilot, [0,0,0]];
_pilotTrigger setTriggerArea [10, 10, 0, false];
_pilotTrigger setTriggerActivation ["WEST", "PRESENT", false];
_pilotTrigger setTriggerStatements ["this",
"
	NEO_coreLogic setVariable [""NEO_pilotHasBeenFound"", true];
	NEO_pilot lookAt (thisList select 0);
	NEO_pilot glanceAt (thisList select 0);
	
	[[NEO_pilot],
	{
		_pilot = _this select 0;
		_pos = getPos _pilot;
			
		enableSentences true;
		sleep 2;
		_pilot directSay ""NEO_speech_10"";
		sleep 10;
		enableSentences false;
		
		waitUntil {_pilot distance _pos>20};
		KAIN_pilotSafeDistance = true;
		
		_pilot allowDamage true;
		_pilot removealleventhandlers ""HandleDamage"";

				
	}] remoteExec [""spawn"", 0, false];
	
", ""];
		//[_pilot] call ace_medical_fnc_init; //re enable ace medical is undefined when run on on the dedi from the spawn above		

//Time Out
private ["_timeOut"];
_timeOut = (time + (360 + (random 240)));
waitUntil { ((_pilot distance NEO_basePosition) < 60) || (time > _timeOut) || (NEO_coreLogic getVariable "NEO_baseRadio_missionAborted") || (NEO_coreLogic getVariable "NEO_baseRadio_missionCompleted") || (!alive _pilot) };

//If pilot is alive
if ((alive _pilot) && (NEO_coreLogic getVariable "NEO_pilotHasBeenFound")) then
{
	waitUntil { ((_pilot distance NEO_basePosition) < 60) || (!alive _pilot) };
	if (!alive _pilot) exitWith {};
	
	NEO_coreLogic setVariable ["NEO_pilotRescued", true, true];
	_pilot removeAllEventHandlers "Killed";
	_pilot setCaptive false;
	_pilot enableAi "MOVE";
	
	if (vehicle _pilot != _pilot) then
	{
		unassignVehicle _pilot;
		[_pilot] orderGetIn false;
	};
	
	//Update Pilot Rescue Task - Succeeded
	["NEO_task_1", "SUCCEEDED"] call A2S_setTaskState;
	["NEO_task_1", "tasksucceeded"] call A2S_taskHint;
	"NEO_task_1" call A2S_taskCommit;
	
	//Pilot speech - "Oh thank you, just drop me at the medic tent if you can"
	[[_pilot],
	{
		enableSentences true;
		sleep 2;
		(_this select 0) directSay "NEO_speech_11";
		sleep 10;
		enableSentences false;
		
	}] remoteExec ["spawn", 0, false];
	
	
	//Pilot goes and stays at medic tent
	while { (_pilot distance KAIN_medicStation) > 5 } do
	{
		_pilot doMove getPos KAIN_medicStation;
		waitUntil { unitReady _pilot };
	};
	
	doStop _pilot;
	_pilot playAction "stand";
}
else
{
	//Kill pilot and Fail the task
	_pilot setDamage 1;
};
