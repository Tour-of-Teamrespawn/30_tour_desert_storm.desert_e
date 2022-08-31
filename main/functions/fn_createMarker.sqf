[[],
{
	private ["_pos", "_dir", "_shape", "_brush", "_type", "_text", "_size", "_color", "_follow"];
	_pos = if (typeName (_this select 0) == typeName objNull) then { getPos (_this select 0) } else { _this select 0 };
	_dir = _this select 1;
	_shape = _this select 2;
	_brush = _this select 3;
	_type = _this select 4;
	_text = _this select 5;
	_size = _this select 6;
	_color = _this select 7;
	_follow = _this select 8;
	
	private ["_marker"];
	_marker = createMarkerLocal ["NEO_debugMarker_" + format ["%1_%2", _pos, random 100], _pos];
	_marker setMarkerDirLocal _dir;
	_marker setMarkershapeLocal _shape;
	_marker setMarkerBrushLocal _brush;
	_marker setMarkerTypeLocal _type;
	_marker setMarkerTextLocal _text;
	_marker setMarkersizeLocal _size;
	_marker setMarkerColorLocal _color;
	
	if (_follow && typeName (_this select 0) == typeName objNull) then
	{
		while { alive (_this select 0) && canMove (_this select 0) } do
		{
			_marker setMarkerPosLocal (getPos (_this select 0));
			_marker setMarkerDirLocal (getDir (_this select 0));
			if ((_this select 0) isKindOf "MAN") then { _marker setMarkerColorLocal (switch (behaviour (_this select 0)) do { case "CARELESS" : { "ColorWhite" }; case "SAFE" : { "ColorGreen" }; case "AWARE" : { "ColorYellow" }; case "COMBAT" : { "ColorRed" }; case "STEALTH" : { "ColorBlue" }; })};
			sleep 0.1;
		};
		
		_marker setMarkerTypeLocal "DestroyedVehicle";
		_marker setMarkerTextLocal "";
	};
	
}]remoteExec ["spawn", 0];

true;
