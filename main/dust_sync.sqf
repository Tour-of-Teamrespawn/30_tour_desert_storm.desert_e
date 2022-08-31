if (!isServer) exitWith {};
waituntil { !isNil "BIS_fnc_init" };

//Variable Needed
NEO_coreLogic setVariable ["NEO_heavyStorm", false, true];

//Heavy Storm at some point in mission and only during a certain time
[] spawn
{
	sleep (1000 + (random 1000));
	NEO_coreLogic setVariable ["NEO_heavyStorm", true, true];
	sleep (60 + (random 360));
	NEO_coreLogic setVariable ["NEO_heavyStorm", false, true];
};

//Dust Syncronizer
//Here we set a random size for the Sand and broadcats it to all machines
//This way, all machines show same size of sand "blobs"
while { true } do
{
	private ["_size"];
	_size = if !(NEO_coreLogic getVariable "NEO_heavyStorm") then
	{
		[
			[(4 + (random 4)),(4 + (random 4)),(4 + (random 4)),(4 + (random 4))],
			[(5 + (random 5)),(5 + (random 5)),(5 + (random 5)),(5 + (random 5))],
			[(6 + (random 6)),(6 + (random 6)),(6 + (random 6)),(6 + (random 6))],
			[(7 + (random 7)),(7 + (random 7)),(7 + (random 7)),(7 + (random 7))]
		] call BIS_fnc_selectRandom;
	}
	else
	{
		[(15 + (random 5)),(15 + (random 5)),(15 + (random 5)),(15 + (random 5))];
	};
	
	//Broadcated Variable, with the SIZE value <NUMBER>
	NEO_coreLogic setVariable ["NEO_sandStorm_density", _size, true];
	
	//Random delay between Weather Changes
	private ["_timeOut"];
	_timeOut = (time + ([240, 360] call BIS_fnc_randomNum));
	
	waitUntil { (time > _timeOut) || (NEO_coreLogic getVariable "NEO_heavyStorm") };
	if (NEO_coreLogic getVariable "NEO_heavyStorm") then { sleep 60 };
};
