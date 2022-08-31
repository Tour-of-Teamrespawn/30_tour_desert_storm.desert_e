waitUntil { !isNil "BIS_fnc_init" };

NEO_fnc_createMarker = compile preprocessFileLineNumbers "main\functions\fn_createMarker.sqf";
NEO_fnc_garbageCollector = compile preprocessFileLineNumbers "main\functions\fn_garbageCollector.sqf";
NEO_fnc_garbageAdd = compile preprocessFileLineNumbers "main\functions\fn_garbageAdd.sqf";
TOUR_fnc_loadouts = compile preProcessFileLineNumbers "main\functions\fn_loadouts.sqf";
