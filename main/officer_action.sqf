waitUntil { !isNil "BIS_fnc_init" };

private ["_leader", "_unit", "_id"];
_leader = _this select 0;
_unit = _this select 1;
_id = _this select 2;

[_leader, _id] remoteExec ["removeAction", 0, true];

["NEO_task_2", "SUCCEEDED"] call A2S_setTaskState;
"NEO_task_2" call A2S_taskCommit;
["NEO_task_2", "tasksucceeded"] call A2S_taskHint;

[
	[_leader],
	{
		enableRadio true;
		enableSentences true;
		sleep 2;
		(_this select 0) directSay "NEO_speech_leaderEnd_00";
		sleep 5;
		(_this select 0) directSay "NEO_speech_leaderEnd_01";
		sleep 10;
		enableRadio true;
		enableSentences true;
	}
] remoteExec ["spawn", 0, false];

sleep 8;

[
	[_leader],
	{
		(_this select 0) action ["salute", (_this select 0)]; sleep 2; (_this select 0) action ["salute", (_this select 0)]
	}
] remoteExec ["spawn", 0, false];

NEO_coreLogic setVariable ["NEO_commandGiven", true, true];

["NEO_task_3", {localize "STR_TASK_3_TITLE"}] call A2S_createSimpleTask;
["NEO_task_3", {localize "STR_TASK_3_TEXT"}, {localize "STR_TASK_3_TITLE"}, {localize "STR_TASK_3_HUD"}] call A2S_setSimpleTaskDescription;
["NEO_task_3", "assigned"] call A2S_setTaskState;
"NEO_task_3" call A2S_taskCommit;
["NEO_task_3", "taskassigned"] call A2S_taskHint;
waitUntil { ("NEO_task_3" call A2S_taskExists) };
