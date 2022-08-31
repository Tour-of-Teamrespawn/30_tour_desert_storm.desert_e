//set the weather to create very poor visibility
KAIN_fnc_desertStormWeather = 
{
	//vars
	_now = 0;
	_forcast = 2100; //weather changes smoothly to forcast values over 35mins
	
	//set current overcast, then set the forcast on server and client
	_now setOvercast 0.45;
	_forcast setOvercast 0.51;
	
	//set current fog, then set the forcast on server only
	if (isServer) then
	{
		_now setFog [0.89,0.0151473,-58.3137]; 				//[_ammount, _decay, _base]
		_forcast setFog [0.95,0.01,-49.9848];
	};
};

//set the weather during the briefing
waitUntil { !isNil "BIS_fnc_init" };
[] call KAIN_fnc_desertStormWeather;


/*
	//values as set in editor

	overcast start: 45%
	overcast forcast: 51%
	
	Fog start: 90%
		decay: 2%
		base: -58.31
		
	Fog forcast: 94%
		decay: 1%
		base: -49.98
		
	//actual ingame fog values: paste data	
	start: [0.9,0.0151473,-58.3137]
	forcast: [0.95,0.01,-49.9848]

*/