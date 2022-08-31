//Here we spawn Wrecks around FOB
//Make sure to spawn only one C-130 (if one actually spawns)
if (!isServer) exitWith {};
waitUntil { !isNil "BIS_fnc_init" };

private ["_center", "_minDist", "_maxDist", "_count", "_typeArray"];
_center = getPos NEO_basePosition;
_minDist = 150;
_maxDist = 300;
_count = [35, 50] call BIS_fnc_randomNum;
_typeArray = ["Land_Wreck_HMMWV_F", "Land_Wreck_Car2_F", "Land_Wreck_Heli_Attack_02_F", "Land_Bulldozer_01_wreck_F", "Land_Wreck_Truck_F", "Land_UWreck_MV22_F", "Land_Wreck_Heli_Attack_01_F", "Land_Wreck_Ural_F", 
"Land_UWreck_Heli_Attack_02_F", "Land_Wreck_Skodovka_F", "Land_Wreck_Car_F", "Land_Wreck_Offroad_F", "Land_Wreck_UAZ_F", "Land_Wreck_Slammer_F", "Land_Wreck_Slammer_hull_F", "Land_Wreck_T72_turret_F"];
_airTypes = ["Land_Wreck_Heli_Attack_01_F", "Land_Wreck_Heli_Attack_02_F", "Land_UWreck_Heli_Attack_02_F", "Land_UWreck_MV22_F"];

for "_i" from 1 to _count do
{
	private ["_type", "_pos", "_wreck"];
	_type = _typeArray call BIS_fnc_selectRandom;
	if (_type == "Land_UWreck_MV22_F") then { _typeArray = _typeArray - ["Land_UWreck_MV22_F"] };
	_pos = [_center, ([_minDist, _maxDist] call BIS_fnc_randomNum), (random 360)] call BIS_fnc_relPos;
	_pos set [2, 0];
	_wreck = createVehicle [_type, _pos, [], 0, "CAN_COLLIDE"];
	_wreck setDir (random 360);
	_wreck setPosATL _pos;
	
	if (_type in _airTypes) then 
	{
		_crater = createVehicle ["CraterLong", _pos, [], 0, "CAN_COLLIDE"];
		_crater setDir getDir _wreck;
		
	};
};

