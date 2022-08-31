private ["_obj"];
_obj = _this;

_obj addEventHandler ["Killed", 
{
	if (!local (_this select 0)) exitWith {};
	
	private ["_obj", "_logic", "_garbage"];
	_obj = _this select 0;
	_logic = NEO_coreLogic;
	_garbage = _logic getVariable "NEO_garbage";
	
	_garbage set [count _garbage, _obj];
	_logic setVariable ["NEO_garbage", _garbage];
}];
