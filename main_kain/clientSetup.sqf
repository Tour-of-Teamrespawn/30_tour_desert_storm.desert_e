KAIN_fnc_setupClient = 
{
	params ["_player"];
	
	//stop avatar talking
	if (isMultiplayer) then
	{
		waitUntil {!(isNull (findDisplay 46))};
		[_player] call KAIN_fnc_stopTalking;
	};

	//prevent the firemode on safe bug
	[_player, "Single"] call KAIN_fnc_setFireMode;

	//healing at medic tent
	[] call KAIN_healAtTentAction;
	
	//move optic to rear rail
	[] call KAIN_fnc_opticRearAction;

	//stop static weapon disassembly bug
	_player addEventHandler ["WeaponDisassembled", 
	{
		params ["_unit", "_backpack1", "_backpack2"];
		[_unit, _backpack1, _backpack2] spawn KAIN_fnc_weaponBackpackOnFloor;
	}];

	//personal teleporter on standby
	TOUR_teleporter = "Land_HelipadEmpty_F" createVehicleLocal [0,0,0];
};

_player = player;
[_player] call KAIN_fnc_setupClient;
_player addEventHandler ["respawn",{[player] call KAIN_fnc_setupClient}]; //does this need re applying after respawn?
_player addEventHandler ["killed",{deleteVehicle TOUR_teleporter}];

//Modify equipment
waitUntil {time>1};
_player addItemToUniform "ACRE_PRC343";
_player removeItemFromBackpack "ACE_epinephrine";
if (primaryWeapon _player == "rhs_weap_savz58v_ris_grip3") then 
{
	//keep rifleman inventory tidy
	_mag = "rhs_30Rnd_762x39mm_Savz58";
	_player removeItemFromUniform _mag;
	_player addItemToVest _mag;
};