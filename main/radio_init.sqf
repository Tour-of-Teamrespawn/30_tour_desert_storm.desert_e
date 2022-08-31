waitUntil { !isNil "BIS_fnc_init" };

//Server Only
if (isServer) then
{
	NEO_coreLogic setVariable ["NEO_baseRadio_hqCalling", false, true];
	NEO_coreLogic setVariable ["NEO_baseRadio_inUse", false, true];
	NEO_coreLogic setVariable ["NEO_baseRadio_missionAborted", false, true];
	NEO_coreLogic setVariable ["NEO_baseRadio_missionCompleted", false, true];
	NEO_coreLogic setVariable ["NEO_baseRadio_evacDown", false, true];
	NEO_coreLogic setVariable ["NEO_baseRadio_casDown", false, true];
	NEO_coreLogic setVariable ["NEO_baseRadio_casDamaged", false, true];
	NEO_coreLogic setVariable ["NEO_baseRadio_casCalled", false, true];
	NEO_coreLogic setVariable ["NEO_baseRadio_casCancelled", false, true];
	NEO_coreLogic setVariable ["NEO_baseRadio_casOnMission", false, true];
	NEO_coreLogic setVariable ["NEO_baseRadio_hqCalling", false, true];
	NEO_coreLogic setVariable ["NEO_baseRadio_playerResponds", false, true];
	NEO_coreLogic setVariable ["NEO_baseRadio_radioOccupied", false, true];
	
	//Radio Action
	//Can have two options, answer HQ call or Open Radio Interface
	[NEO_radio,["Use Satellite Radio", "main\radio_action.sqf", [], 10, true, true, "", 
	"
		(_this == leader group _this)
		&&
		((_this distance _target) < 2)
		&&
		!(NEO_coreLogic getVariable ""NEO_baseRadio_inUse"")
		&&
		!(NEO_coreLogic getVariable ""NEO_baseRadio_missionAborted"")
		&&
		!(NEO_coreLogic getVariable ""NEO_baseRadio_missionCompleted"")
	"
	]]remoteExec ["addAction", 0, true];
};

//Players Machine Only
if (isDedicated) exitWith {};
waitUntil { !isNull player };
waitUntil { !(player != player) };

//On Radio Open
if (isNil "NEO_fnc_onRadioOpen") then
{
	NEO_fnc_onRadioOpen =
	{
		NEO_coreLogic setVariable ["NEO_baseRadio_inUse", true, true];
		
		[] spawn
		{
			if ((NEO_coreLogic getVariable "NEO_baseRadio_casCancelled") || (NEO_coreLogic getVariable "NEO_baseRadio_casDown") || (NEO_coreLogic getVariable "NEO_baseRadio_casDamaged")) then
			{
				((findDisplay 566666) displayCtrl 577779) ctrlEnable false;
			}
			else
			{
				if (NEO_coreLogic getVariable "NEO_baseRadio_casOnMission") then
				{
					((findDisplay 566666) displayCtrl 577779) ctrlSetText "- Abort Close Air Support";
					buttonSetAction [577779, "[] call NEO_fnc_onRadioCasCancelled; while { dialog } do { closeDialog 0 }"];
				};
			};
		};
	};
};

//On Radio Close
if (isNil "NEO_fnc_onRadioClose") then
{
	NEO_fnc_onRadioClose =
	{
		NEO_coreLogic setVariable ["NEO_baseRadio_inUse", false, true];
	};
};

//On CAS Called
if (isNil "NEO_fnc_onRadioCasCalled") then
{
	NEO_fnc_onRadioCasCalled =
	{
		[] spawn 
		{
			_grid = player call BIS_fnc_posToGrid;
			[player, [format ["This is Bishop 1 to HQ, Over. Requesting immediate close air support to grid %1 %2, Out.", (_grid select 0), (_grid select 1)]]] spawn TOUR_fnc_sideRadio;
			sleep 8;
				
			if !(NEO_coreLogic getVariable "NEO_heavyStorm") then
			{
				NEO_coreLogic setVariable ["NEO_baseRadio_casCalled", true, true];
				NEO_coreLogic setVariable ["NEO_baseRadio_casOnMission", true, true];
				
				[[],
				{
					if (!isServer) exitWith {};
					waitUntil { !isNil "BIS_fnc_init" };
					
					[] execFSM "main\cas.fsm";
				}]remoteExec ["spawn", 0];
				
				//Speech
				[NEO_radio,"ds_officer_cas_00"]remoteExec ["say", 0];
				[NEO_HQradio, ["COPY THAT SENDING BIRD FOR CAS. HQ OUT."]] spawn TOUR_fnc_sideRadio;
			}
			else
			{
				//Speech
				[NEO_radio,"ds_officer_cas_01"]remoteExec ["say", 0];
				[NEO_HQradio, ["TOO HEAVY WEATHER CONDITIONS OVER TARGET AREA. AIR-SUPPORT UNAVAILABLE. HQ OUT."]] spawn TOUR_fnc_sideRadio;
			};
		};
			
	};
};

//On CAS Cancel
if (isNil "NEO_fnc_onRadioCasCancelled") then
{
	NEO_fnc_onRadioCasCancelled =
	{
		[[player],
		{
			enableRadio true;
			enableSentences true;
			sleep 2;
			(_this select 0) sideChat "FALCON 1 YOU CAN GO RTB, WE CAN HANDLE IT FOR NOW. OVER.";
		}]remoteExec ["spawn", 0];
		
		NEO_coreLogic setVariable ["NEO_baseRadio_casCancelled", true, true];
	};
};

//On EVAC Called
if (isNil "NEO_fnc_onRadioEvacCalled") then
{
	NEO_fnc_onRadioEvacCalled =
	{
		NEO_coreLogic setVariable ["NEO_baseRadio_missionAborted", true, true];
		
		[[],
		{
			if (!isServer) exitWith {};
			waitUntil { !isNil "BIS_fnc_init" };
			
			[] execFSM "main\evac.fsm";
		}]remoteExec ["spawn", 0];
		
		//Speech
		[NEO_radio, "ds_officer_evac_00"]remoteExec ["say", 0];
		
		["NEO_task_0", "FAILED"] call A2S_setTaskState;
		["NEO_task_0", "taskfailed"] call A2S_taskHint;
		"NEO_task_0" call A2S_taskCommit;
	};
};
