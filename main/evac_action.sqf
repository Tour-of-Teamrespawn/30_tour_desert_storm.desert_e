waitUntil { !isNil "BIS_fnc_init" };

private ["_chopper", "_id"];
_chopper = _this select 0;
_id = _this select 2;


[_chopper, _id] remoteExec ["removeAction", 0, true];
NEO_coreLogic setVariable ["NEO_evacAllInside", true, true];

["NEO_task_3", "SUCCEEDED"] call A2S_setTaskState;
["NEO_task_3", "tasksucceeded"] call A2S_taskHint;
"NEO_task_3" call A2S_taskCommit;
