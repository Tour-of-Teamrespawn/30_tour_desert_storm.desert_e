/* 
###MISSION_VERSION 1.04
*/
waituntil { !isNil { BIS_fnc_init } };


diag_log text "";
diag_log text "==========================================================================";
diag_log text format["|=============================   %1   ===================================|", missionName];
diag_log text "==========================================================================";
diag_log text "";


//NEO_debugOn = true;


_db = [] execVM "main_kain\debugParams.sqf";
waitUntil {scriptDone _db};
_db = [] execVM "main_kain\debugHelpers.sqf";
waitUntil {scriptDone _db};


enableRadio false;
enableSentences true;
enableSaving [false, false];
setViewDistance 1000;
setObjectViewDistance [1000, 70];

_rc = [] execVM "main_kain\respawnControl.sqf";
waitUntil {scriptDone _rc};
_mt = KAIN_core execVM "scripts\A2S_MultiTask\a2s_multitask.sqf";
waitUntil {scriptDone _mt};
//_fr = [KAIN_core] execVM "scripts\TOUR_FieldRadio\TOUR_FieldRadio.sqf";
private ["_f"]; _f = NEO_coreLogic execVM "main\functions\fn_init.sqf";
waitUntil {scriptDone _f};
[] call (compile preprocessFileLineNumbers "main\radio_init.sqf");
_w = [] execVM "main_kain\setWeather.sqf";

if (isServer) then
{
	[] spawn NEO_fnc_garbageCollector;
	[] execVM "briefing_tasks.sqf";
	[] execVM "main\callsigns.sqf";
	if (isNil "KAIN_debugOn_quickStart") then {[] execVM "main\intro_server.sqf";};
	[] execVM "main\mission_time.sqf";
	[] execVM "main\enemy_spawn.sqf";
	[] execVM "main\dust_sync.sqf";
	[] execVM "main\spawn_signs.sqf";
	[] execVM "main\spawn_wrecks.sqf";
	if (isDedicated) then { [NEO_basePosition] execVM "main\dust.sqf" };
	[] execVM "main_kain\endMission.sqf";
	[] execVM "main_kain\destroyDish.sqf";
};

if (!isDedicated) then
{
	waitUntil { !isNil { player } };
	waitUntil { !isNull player };
	waitUntil { !(player != player) };
	
	[] call A2S_tasksSync;
	
	if (isNil "KAIN_debugOn_quickStart") then {[] execVM "main\intro_client.sqf";};
	_f = [] execVM "main_kain\clientFunctions.sqf";
	waitUntil {scriptDone _f};
	_m = [] execVM "main_kain\medicTent.sqf";
	waitUntil {scriptDone _m};
	[] execVM "main_kain\moveOptic.sqf";
	[] execVM "briefing_notes.sqf";
	[] execVM "main\post_processing.sqf";
	[] execVM "main\dust.sqf";
	[] execVM "main_kain\clientSetup.sqf";
	//[] execVM "scripts\TOUR_name_recog\TOUR_name_recog.sqf";
	
};