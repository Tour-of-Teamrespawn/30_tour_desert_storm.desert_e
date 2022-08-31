if (!isServer) exitWith {};
waitUntil { !isNil "BIS_fnc_init" };

NEO_HQradio = (createGroup WEST) createUnit ["Logic", [10,20, 1500], [], 0, "NONE"];
NEO_HQradio setGroupIdGlobal ["HQ"];

NEO_CASradio = (createGroup WEST) createUnit ["Logic", [20,20, 1500], [], 0, "NONE"];
NEO_CASradio setGroupIdGlobal ["FALCON"];

NEO_EVACradio = (createGroup WEST) createUnit ["Logic", [20,30, 1500], [], 0, "NONE"];
NEO_EVACradio setGroupIdGlobal ["EAGLE"];

NEO_BRAVO2radio = (createGroup WEST) createUnit ["Logic", [20,40, 1500], [], 0, "NONE"];
NEO_BRAVO2radio setGroupIdGlobal ["BRAVO-TWO"];

{publicVariable _x} forEach ["NEO_HQradio", "NEO_CASradio", "NEO_EVACradio", "NEO_BRAVO2radio"];



