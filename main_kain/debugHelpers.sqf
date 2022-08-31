/*
	Debug helpers. By Kain_Lowsta [Tour]
*/

/*
	Function: Return a group, by inputing the name seen in spectator mode
	Params: string - name of group, as seen in spectator mode
	Returns: group, or false if none found
	Usage: _grp = ["Alpha 2-4"] call KAIN_fnc_getGroupFromName;
*/
KAIN_fnc_getGroupFromName = 
{
	params ["_name"];
	private ["_name", "_grp", "_allGroups", "_grpIndex"];
	
	_grp = false;
	if ((typeName _name=="STRING")&&(_name!="")) then 
	{
		_name = format ["R %1", _name]; //add "R " to the group name since that is at start, even though it doesnt show in the spectator menu!
		_allGroups = allGroups;
		_grpIndex = _allGroups findIf {str _x==_name};
		if (_grpIndex<0) exitWith {systemchat "Error: KAIN_fnc_getGroupFromName: No groups with that name we found"};
		_grp = _allGroups select _grpIndex;
		
	} else {systemchat "Error: KAIN_fnc_getGroupFromName: You didn't pass a group name as a string!!"};
	_grp
};

/*
	Function: Mark position of selected group's next waypoint in 3D. Display further info about all the group's waypoints in systemchat
	Params: string - name of group, as seen in spectator mode
	Returns: Nothing
	Usage: ["Alpha 2-4"] call KAIN_fnc_showWaypoint;
*/
KAIN_fnc_showWaypoint = 
{
	params ["_name"];
	[_name] spawn 
	{
		params ["_name"];
		_grp = [_name] call KAIN_fnc_getGroupFromName;
		_wps = waypoints _grp;
		{systemchat format ["Waypoint: %2 Type: %1 - Position: %3", waypointType [_grp, _forEachIndex], _forEachIndex, waypointPosition [_grp, _forEachIndex]];} forEach _wps;
		
		_wpPos = waypointPosition [_grp, 0];
		_wpPos set [2, (_wpPos select 2)+4];
		if (isNil "KAIN_waypointHelper_01") then {KAIN_waypointHelper_01 = "VR_3DSelector_01_complete_F" createVehicle [0,0,0];};
		KAIN_waypointHelper_01 setPos _wpPos;
	};
};



/*





//show a group's assigned vehicle roles
[] spawn 
{
	_grp = ["Alpha 2-4"] call KAIN_fnc_getGroupFromName;
	{systemchat str assignedVehicleRole _x; sleep 0.5} foreach units _grp;
};


//delete all waypoints, then add a new one
[] spawn 
{
	_grp = ["Alpha 2-4"] call KAIN_fnc_getGroupFromName;

	private ["_grp"];
	for "_i" from count waypoints _grp - 1 to 0 step -1 do
	{
		deleteWaypoint [_grp, _i];
	};

	_wp = _grp addWaypoint [getPos NEO_basePosition, 30];
	_wp setWaypointSpeed "NORMAL";
	_wp setWaypointType "GUARD";

	systemchat format ["group's waypoints: %1", waypoints _grp];
};


