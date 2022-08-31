waitUntil { !isNil "BIS_fnc_init" };

private ["_holder", "_presser", "_id"];
_holder = _this select 0;
_presser = _this select 1;
_id = _this select 2;

//If HQ is calling on the radio, player responds
if (NEO_coreLogic getVariable "NEO_baseRadio_hqCalling") then
{
	NEO_coreLogic setVariable ["NEO_baseRadio_playerResponds", true, true];
}
//Open radio interface
else
{
	while { !dialog } do
	{
		createDialog "NEO_baseRadioResource";
	};
};
