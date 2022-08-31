//inform players when dish has been destroyed, and prevent calling CAS
if (isServer) then 
{
	TOUR_commDish addEventHandler ["Killed", 
	{
		NEO_coreLogic setVariable ["NEO_baseRadio_casDamaged", true, true];
						
		["KAIN_task_1", {"Protect Comm Dish"}] call a2s_createSimpleTask;
		[
				"KAIN_task_1", 
				{
						"The satellite communication dish was destroyed. You are no longer able to call close air support."
				}, 
				{"Protect Comm Dish"}, {"Comm Dish"}
		] call A2S_setSimpleTaskDescription;
		"KAIN_task_1" call A2S_taskCommit;
				
		["KAIN_task_1", "FAILED"] call A2S_setTaskState;
		["KAIN_task_1", "taskfailed"] call A2S_taskHint;
		"KAIN_task_1" call A2S_taskCommit;
	}];
};