if (side player == CIVILIAN) exitWith {};
0 fadeSound 0;
0 fadeMusic 0;
cutText ["Receiving...", "BLACK FADED", 30];

//Player lowers his rifle
player playAction "stand";

//Create Camera (So player cannot move at begginning)
private ["_cam"];
_cam = "camera" camCreate (getPosATL player);
_cam cameraEffect ["INTERNAL", "BACK"];

//Motion Blur
[] spawn
{
	private ["_blur"];
	_blur = ppEffectCreate ["DynamicBlur", 450];
	_blur ppEffectAdjust [10];
	_blur ppEffectEnable true;
	_blur ppEffectCommit 0;
	waitUntil { ppEffectCommitted _blur };
	_blur ppEffectAdjust [0];
	_blur ppEffectCommit 20;
	waitUntil { ppEffectCommitted _blur };
	_blur ppEffectEnable true;
	ppEffectDestroy _blur;
};

sleep 12;	//Delay (same as server intro)

//Destroy Camera
_cam cameraEffect ["TERMINATE", "BACK"];
camDestroy _cam;

//Player gains control over character
10 fadeSound 1;
10 fadeMusic 1;
cutText ["", "BLACK IN", 10];
sleep 5;
[localize "STR_MISSIONNAME", str(date select 2) + "." + str(date select 1) + "." + str(date select 0), "MIDDLE OF THE DESERT"] call BIS_fnc_infoText;
