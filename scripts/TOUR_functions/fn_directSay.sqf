/*
	Send message in direct radio. Message must be defined in Description.ext
	Params:
	(_this select 0) == Unit <Object>
	(_this select 1) == Classname of item in CfgRadio <String>
*/

private ["_unit","_text"];
_unit = [_this,0,objNull,[objNull]] call BIS_fnc_param;
_text = [_this,1,"",[""]] call BIS_fnc_param;
if ((!(isNull _unit))&&(_text!="")) then
{
	if (alive _unit) then
	{
		enableSentences true;
		sleep 0.5;
		_unit directSay _text;
		sleep 0.5;
		enableSentences false;
	};
};
	
	