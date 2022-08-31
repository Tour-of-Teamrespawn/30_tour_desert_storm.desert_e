if (!isServer) exitWith {};
waitUntil { !isNil "BIS_fnc_init" };

/* //added these using the editor
private ["_baseSign"];
_baseSign = createVehicle ["SignM_FOB_Blanik_EP1", [1332.33,1461.67,0], [], 0, "CAN_COLLIDE"];
_baseSign setDir 90; _baseSign setPosATL [1328,1461.67,0];
[nil, nil, "per", rSETOBJECTTEXTURE, _baseSign, 0, "main\img\fob.paa"] call RE;

private ["_weaponCache"];
_weaponCache = createVehicle ["Info_Board_EP1", [1431.42,1436.84,0], [], 0, "CAN_COLLIDE"]; 
_weaponCache setDir 90; _weaponCache setPosATL [1431.42,1436.84,0];
[nil, nil, "per", rSETOBJECTTEXTURE, _weaponCache, 0, "main\img\explosion_risk.paa"] call RE;

private ["_bunker"];
_bunker = createVehicle ["Infostand_1_EP1", [1407.1,1426.71,0], [], 0, "CAN_COLLIDE"]; 
_bunker setDir 180; _bunker setPos (getPos _bunker);
[nil, nil, "per", rSETOBJECTTEXTURE, _bunker, 0, "main\img\tour.paa"] call RE;

private ["_laptop"];
_laptop = createVehicle ["Laptop_EP1", [1409.69,1418.25,1.02503], [], 0, "CAN_COLLIDE"];
[nil, _laptop, "per", rENABLESIMULATION, false] call RE;
_laptop setDir 180; _laptop setPosATL [1409.69,1418.25,1.02503];
*/

while { alive TOUR_laptop } do
{
	TOUR_laptop setObjectTextureGlobal [0, format ["main\img\laptop_%1.paa", (round (random 4))]];
	sleep 120;
};
