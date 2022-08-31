if (isDedicated) exitWith {};
waituntil { !isNil "BIS_fnc_init" };
//waituntil { !isNull player }; //for newspapers
//waituntil { player == player }; //for newspapers
waituntil { !isNil { NEO_coreLogic getVariable "NEO_sandStorm_density" } };

private ["_obj", "_radius", "_density", "_height"];
_obj = if (count _this > 0) then { _this select 0 } else { player };
_radius = if (count _this > 1) then { _this select 1 } else { 250 };
_density = if (count _this > 2) then { _this select 2 } else { (1.6 * (_radius * 2)) };
_height = if (count _this > 3) then { _this select 3 } else { -1 };
_velocity = if (count _this > 4) then { _this select 4 } else { [(0 + (random 5)), (3 + (random 7)), 0] };

//Variable
NEO_showDust = true;

//Wind Sound
if (!isDedicated) then
{
	[] spawn 
	{ 
		while { NEO_showDust } do 
		{
			if !(NEO_coreLogic getVariable "NEO_heavyStorm") then
			{
				playSound "ds_wind_00";
				sleep 35;
			}
			else
			{
				playSound "ds_wind_01";
				sleep 35;
			};
		};
	};
};

/* can't get working in A3 so far
//--- Newspapers
_newspapers = true;
_pos = position player;
 sleep 1;
 systemchat "newspapers";
 
_result = if (_newspapers) then 
{
	_newsParams = [["\a3\data_f_orange\ParticleEffects\Universal\orangeDrop.p3d", 1, 0, 1], "", "SpaceObject", 1, 5, [0, 0, 1], _velocity, 1, 1.25, 1, 0.2, [0,1,1,1,0], [[1,1,1,1]], [0.7], 1, 0, "", "", _obj];
	_newsRandom = [0, [30, 30, 0], [5, 5, 0], 2, 0.3, [0, 0, 0, 0], 10, 0];
	_newsCircle = [10, [1, 1, 0]];
	_newsInterval = 1;

	_times = "#particlesource" createVehicleLocal (player getRelPos [5, random 359]);  
	_times setParticleParams _newsParams;
	_times setParticleRandom _newsRandom;
	_times setParticleCircle _newsCircle;
	_times setDropInterval _newsInterval;

	_newsParams set [0,["\a3\data_f_orange\ParticleEffects\Universal\orangeDrop.p3d", 1, 0, 1]];
	_herald = "#particlesource" createVehicleLocal (player getRelPos [5, random 359]);  
	_herald setParticleParams _newsParams;
	_herald setParticleRandom _newsRandom;
	_herald setParticleCircle _newsCircle;
	_herald setDropInterval _newsInterval;

	_newsParams set [0,["\a3\data_f_orange\ParticleEffects\Universal\orangeDrop.p3d", 1, 0, 1]];
	_tribune = "#particlesource" createVehicleLocal (player getRelPos [5, random 359]);  
	_tribune setParticleParams _newsParams;
	_tribune setParticleRandom _newsRandom;
	_tribune setParticleCircle _newsCircle;
	_tribune setDropInterval _newsInterval;
};
*/

//Dust Loop
while { NEO_showDust } do
{
	for "_i" from 0 to _density do
	{
		private ["_lifeTime", "_color", "_size", "_velocity"];
		_lifeTime = (70 + (random 30));
		_color = [1, 0.85, 0.7, (0.25 + (random 0.2))];
		_size = NEO_coreLogic getVariable "NEO_sandStorm_density";
		_velocity = if !(NEO_coreLogic getVariable "NEO_heavyStorm") then { [(0 + (random 5)), (3 + (random 7)), 0] } else { [(5 + (random 7)), (5 + (random 7)), 0] };
		
		private ["_pos"];
		_pos = [_obj, (random _radius), (random 360)] call BIS_fnc_relPos;
		_pos set [2, _height];
		
		drop 
		[
			"\a3\data_f\cl_basic.p3d", 
			"",
			"Billboard",
			_lifeTime,
			_lifeTime,
			_pos,
			_velocity,
			5,
			0.2,
			0.1565,
			0.001,
			_size,
			[[1,1,1,0],_color,_color,_color,[1,1,1,0]],
			[0],
			0,
			0,
			"",
			"",
			""
		];
	};
	
	sleep 5;
};




