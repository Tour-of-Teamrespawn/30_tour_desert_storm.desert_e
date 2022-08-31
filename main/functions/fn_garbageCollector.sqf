private ["_logic", "_checkDelay"];
_logic = NEO_coreLogic;
_checkDelay = 120;

if (isNil { _logic getVariable "NEO_garbage" }) then
{
	_logic setVariable ["NEO_garbage", []];
};

while { true } do
{
	private ["_garbage"];
	_garbage = _logic getVariable "NEO_garbage";
	
	{
		deleteVehicle _x;
		_garbage = _garbage - [_x];
	} forEach _garbage;
	
	_logic setVariable ["NEO_garbage", _garbage];
	sleep _checkDelay;
};
