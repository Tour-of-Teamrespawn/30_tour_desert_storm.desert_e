if (!isServer) exitWith {};
waitUntil { !isNil "BIS_fnc_init" };

private ["_unit"];
_unit = _this select 0;

[[_unit],{ (_this select 0) allowDamage false; (_this select 0) setIdentity "Vilem" }] remoteExec ["spawn", 0, true];

_unit setCaptive true;
_unit setBehaviour "CARELESS";
_unit disableAi "TARGET";
_unit disableAi "AUTOTARGET";
_unit forceSpeed 1.5;
_unit setUnitPos "UP";

_unit action ["Eject", vehicle _unit];
[_unit] orderGetIn false;
waitUntil { _unit == vehicle _unit };

[
	[],
	{ 
		enableRadio true;
		enableSentences true;
		sleep 2;
		NEO_BRAVO2radio sideRadio "NEO_speech_officerEnd";
		sleep 10;
		enableRadio true;
		enableSentences true;
	}
] remoteExec ["spawn", 0, false];

["NEO_task_2", {localize "STR_TASK_2_TITLE"}] call A2S_createSimpleTask;
["NEO_task_2", {localize "STR_TASK_2_TEXT"}, {localize "STR_TASK_2_TITLE"}, {localize "STR_TASK_2_HUD"}] call A2S_setSimpleTaskDescription;
["NEO_task_2", "ASSIGNED"] call A2S_setTaskState;
"NEO_task_2" call A2S_taskCommit;
["NEO_task_2", "taskassigned"] call A2S_taskHint;
waitUntil { ("NEO_task_2" call A2S_taskExists) };


while { (_unit distance (getMarkerPos "KAIN_mkr_vilem_01")) > 5 } do
{
	_unit doMove (getMarkerPos "KAIN_mkr_vilem_01");
	waitUntil { unitReady _unit };
};

sleep 1;

private ["_posLook"];
_posLook = [_unit, 10, 0] call BIS_fnc_relPos;

_unit setFormDir 0;
_unit lookAt _posLook;
_unit glanceAt _posLook;

[
	_unit,
	[
		format ["Talk to %1", name _unit], "main\officer_action.sqf", [], -1, true, true, "", 
		"
			(_this == leader group _this)
			&&
			((_this distance _target) < 3)
		"
	]
] remoteExec ["addAction", 0, true];
