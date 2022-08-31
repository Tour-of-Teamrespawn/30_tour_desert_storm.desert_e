/*
	Restrict access to vehicles. Run on clients only.
	First array is vehicle types to restrict.
	Second array is classes allowed to use the vehicles. All other classes will be ejected.
	Default settings are Commander, Gunner and Driver positions restricted.
	Params:
	(_this select 0) == Array of vehicle classnames <Array>
	(_this select 1) == Array of unit classnames <Array>
	(_this select 2) == Message to player being ejected from vehicle <String> (Optional)
	(_this select 3) == Restrict Commander position <Boolean> (Optional)
	(_this select 4) == Restrict Gunner position <Boolean> (Optional)
	(_this select 5) == Restrict Driver position <Boolean> (Optional)
*/

_this spawn 
{
	private ["_v","_u","_m","_c","_g","_d"];
	_v = [_this,0,[],[[]]] call BIS_fnc_param;
	_u = [_this,1,[],[[]]] call BIS_fnc_param;
	_m = [_this,2,"You are not permitted to operate this vehicle, and have been ejected.",[""]] call BIS_fnc_param;
	_c = [_this,3,true,[true]] call BIS_fnc_param;
	_g = [_this,4,true,[true]] call BIS_fnc_param;
	_d = [_this,5,true,[true]] call BIS_fnc_param;

	if (((count _v)>0)&&((count _u)>0)) then
	{
		while {true} do
		{
			if (((((driver (vehicle player))==player) && _d) || 
			(((gunner (vehicle player))==player) && _g) || 
			(((commander (vehicle player))==player) && _c)) && 
			(((vehicle player) in _v) || 
			((toLower (typeOf (vehicle player))) in _v)) && 
			!(((toLower (typeOf player)) in _u) || 
			(player in _u) || 
			((getPlayerUID player) in _u))) then
			{
				if (((driver (vehicle player))==player)||(isNull (driver (vehicle player)))) then
				{
					player action ["EngineOff",(vehicle player)];
				};
				moveOut player;
				cutText [_m, "PLAIN"];
			};
			sleep 0.5;
		};
	};
};
	
	