/*
	Synchronize weather in multiplayer
	Modified from timeSyncMP by Kain_Lowsta
*/

TOUR_logic = [_this,0,objNull,[objNull]] call BIS_fnc_param;
TOUR_variable = [_this,1,"TOUR_var_serverWeather",[""]] call BIS_fnc_param;

if (!isNull TOUR_logic) then
{
	waitUntil { !(isNil { (TOUR_logic getVariable TOUR_variable) }) };

	if 
	(
		(((TOUR_logic getVariable TOUR_variable) select 0) != overcast)
		or
		(((TOUR_logic getVariable TOUR_variable) select 1) != windStr)
	) 
	then 
	{
		skipTime -24;
		86400 setOvercast ((TOUR_logic getVariable TOUR_variable) select 0);
		skipTime 24;
		0 = [] spawn {
			sleep 0.1;
			simulWeatherSync;
			
		0 setWaves ((TOUR_logic getVariable TOUR_variable) select 1);
		};
	};
};

