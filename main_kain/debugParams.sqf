if (isMultiplayer) then //use parameters set by admin
{
	//skip cutscene
	if (("KAIN_par_quickStart" call BIS_fnc_getParamValue) == 1) then {KAIN_debugOn_quickStart = true};
	
	//change amount of time before enemy attacks
	KAIN_ds_attackDelay = "KAIN_par_attackDelay" call BIS_fnc_getParamValue;
	
	//god mode
	if !(isDedicated) then 
	{
		if (("KAIN_par_invincibility" call BIS_fnc_getParamValue) == 1) then 
		{
			KAIN_fnc_godmode = {};
			player addEventHandler ["HandleDamage", {0}];
			player allowDamage false;
			player addAction ["kill all enemies",
			{
				{if (side _x != side player) then {vehicle _x setdamage 1}} forEach (allunits-(playableunits+switchableunits))
				
			}, nil, 1.5, false];
		};
	};
} 
else //manual settings for SP
{
	//hints and markers showing the enemy spawning process
	KAIN_debugOn_spawnEnemy = true;
	
	//skip cutscene
	KAIN_debugOn_quickStart = true; //in SP set value manually here
	
	//change amount of time before enemy attacks
	KAIN_ds_attackDelay = 3;  //1 = 5 mins,   3 = 0 secs;
	
	//god mode
	if !(isDedicated) then 
	{
		//player addEventHandler ["HandleDamage", {0}];
		//player allowDamage false;
		player addAction ["kill all enemies",
		{
			{if (side _x != side player) then {vehicle _x setdamage 1}} forEach (allunits-(playableunits+switchableunits))
			
		}, nil, 1.5, false];
	};
}; 


