
sleep 1;
[] spawn 
{
	systemchat "checking for incapacitation and death";

	waitUntil 
	{
		sleep 2;
		_plyrs = playableUnits + switchableUnits;
		(count _plyrs<=0) or ({lifeState _x != "Incapacitated"} count _plyrs == 0)
	};

	sleep 2;
	["NEO_task_0", "FAILED"] call A2S_setTaskState;
	["NEO_task_0", "taskfailed"] call A2S_taskHint;
	"NEO_task_0" call A2S_taskCommit;
	sleep 5;

	"playersdead" call BIS_fnc_endMissionServer;
};

