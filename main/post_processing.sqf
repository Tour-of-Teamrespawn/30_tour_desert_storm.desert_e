if (isDedicated) exitWith {};
waitUntil { !isNil "BIS_fnc_init" };
waitUntil { !isNull player };
waitUntil { player == player };

//Main
NEO_mainColor = ppEffectCreate ["colorCorrections", 1550];
NEO_mainColor ppEffectAdjust 
[
/*Brightness*/	1.03,								//changed! was: 1
/*Contrast*/  	1.03,
/*Offset*/   	-0.005, 
/*BlendColor*/	[0.0, 0.0, 0.0, 0.0], 
/*Colorize*/  	[1, 0.9, 0.8, 0.65],  
/*Colorize*/  	[0.199, 0.587, 0.114, 0.0]
];
NEO_mainColor ppEffectEnable true;
NEO_mainColor ppEffectCommit 0;





