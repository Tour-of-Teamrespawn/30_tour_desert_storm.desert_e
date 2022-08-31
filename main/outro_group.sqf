if (!isServer) exitWith {};
waitUntil { !isNil "BIS_fnc_init" };

private ["_grp"];
_grp = _this select 0;

{
	private ["_unit"];
	_unit = _x;

	_unit action ["Eject", vehicle _unit];
	[_unit] orderGetIn false;
	_unit setBehaviour "SAFE";
	_unit forceSpeed 1.5;
	waitUntil { _unit == vehicle _unit };
	_unit setUnitPos "UP";

	[_unit] spawn
	{
		private ["_unit", "_center", "_staticArray", "_static"];
		_unit = _this select 0;
		_center = NEO_basePosition;
		_staticArray = [];
		_static = objNull;
		
		{
			if (isNil { _x getVariable "NEO_staticWeaponOccupied" }) then
			{
				if ((_x emptyPositions "gunner") > 0) then 
				{
					_staticArray set [(count _staticArray), _x];
				};
			};
		} forEach (nearestObjects [_center, ["B_HMG_high_F"], 125]);

		if ((count _staticArray > 0) && (_unit != leader group _unit)) then
		{
			_static = _staticArray call BIS_fnc_selectRandom;
			_static setVariable ["NEO_staticWeaponOccupied", true];

			_unit assignAsGunner _static;
			[_unit] orderGetIn true;
			_static setVehicleAmmo 1;
			waitUntil { vehicle _unit != _unit };
		}
		else
		{
			_unit doMove ([NEO_basePosition, ([10, 50] call BIS_fnc_randomNum), (random 360)] call BIS_fnc_relPos);
			waitUntil { unitReady _unit };
			doStop _unit;
			_unit setUnitPos (["MIDDLE", "AUTO"] call BIS_fnc_selectRandom);
		};
		
		_unit forceSpeed -1;
	};
	
	sleep 5;
	
} forEach units _grp;
