if (!isServer) exitWith {};
waitUntil { !isNil "BIS_fnc_init" };

//Create defend objective
["NEO_task_0", {localize "STR_TASK_0_TITLE"}] call a2s_createSimpleTask;
[
		"NEO_task_0", 
		{
				localize "STR_TASK_0_TEXT"
		}, 
		{localize "STR_TASK_0_TITLE"}, {localize "STR_TASK_0_HUD"}
] call A2S_setSimpleTaskDescription;
"NEO_task_0" call A2S_taskCommit;

waitUntil { ("NEO_task_0" call A2S_taskExists) };
KAIN_core setVariable ["KAIN_var_tasksCreated", true, true];
