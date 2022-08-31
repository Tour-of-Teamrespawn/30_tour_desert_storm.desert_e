/*
	Synchronize time in multiplayer
*/
private ["_logic","_variable"];
_logic = [_this,0,objNull,[objNull]] call BIS_fnc_param;
_variable = [_this,1,"TOUR_var_serverTime",[""]] call BIS_fnc_param;

if (!isNull _logic) then
{
	waitUntil { !(isNil { (_logic getVariable _variable) }) };

	if (
		((_logic getVariable _variable)!=0)
		&&
		((date select 3)==0)
	) then
	{
		skipTime (_logic getVariable _variable);
	};
};

