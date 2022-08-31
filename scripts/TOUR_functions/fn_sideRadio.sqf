/*
	Send message in side radio.
	Multiple strings of text are automatically sent with a short delay between each.
	This function should be used with the SPAWN command, since it contains sleep commands.
	
	Params:
	(_this select 0) == Unit <Object>
	(_this select 1) == Array of strings <Array>
*/

private ["_unit","_text"];
_unit = [_this,0,objNull,[objNull]] call BIS_fnc_param;
_text = [_this,1,["No Text"],[[]]] call BIS_fnc_param;
if !(isNull _unit) then
{
	if ((alive _unit)&&((count _text)>0)) then
	{
		//sleep 1;
		{
			enableRadio true;
			sleep 0.2;
			_unit sideChat _x;
			sleep 1;
			enableRadio false;
			sleep 4;
		} forEach _text;
		sleep 1;
	};
};
	
	