//teleport player in multiplayer. Execute the following on each client prior to use: TOUR_teleporter = "Land_HelipadEmpty_F" createVehicleLocal [0,0,0];.
TOUR_fnc_teleportPlayerMP =
{
	params ["_player", "_pos"];
	TOUR_teleporter setPos _pos;
	_player attachTo [TOUR_teleporter, [0,0,0]];
	detach _player;
	TOUR_teleporter setPos [0,0,0];
};

//stop static weapon backpacks being put on bunker roofs when dissasembled
KAIN_fnc_weaponBackpackOnFloor = 
{
	params ["_unit", "_backpack1", "_backpack2"];
	{
		if ((getPos _x select 2>0.4) && (getPos _unit select 2<0.4)) then 
		{
			_wh = objectParent _x; //get the weapon holder and move that
			_pos = getPos _wh;
			_pos set [2, 0];
			_wh setPos _pos;
		}
	} forEach [_backpack1, _backpack2];
};

//stop avatar talking
KAIN_fnc_stopTalking = 
{
	params ["_player"];
	doStop _player;
	_player setspeaker "NoVoice";
	ShowRad = showRadio false;
	EnabRad = enableRadio false;
	EnabSent = enableSentences false;
	_player disableConversation true;
};

//set fire mode of currently equipped weapon
KAIN_fnc_setFireMode = 
{
	params ["_player", "_mode"];
	_weapon = currentWeapon _player;
	_ammo = player ammo _weapon;
	player setAmmo [_weapon, 0];
	player forceWeaponFire [_weapon, _mode];
	player setAmmo [_weapon, _ammo];
};

//forces player to turn toward a target object or position smoothly, with turning animation. Speed can be adjusted using _increment.
//example: _condition = "(round _unit getDir _target) != ((round getDir _unit))"; - keep turning the unit until they are facing correct direction, then exit
TOUR_fnc_turnTowards =
{
	params ["_unit", "_target", "_increment", "_condition", "_timeout", "_playAnim", "_stopped"];
	private ["_timeout"];
	
	if (_timeout<0) then {_timeout = 999999};
	TOUR_turnToward_active = true;
	TOUR_turnTarget = _target; //make global variable so target can be updated on the fly
	TOUR_turn_playAnim = _playAnim; //make global variable so target can be updated on the fly
	_prevAnim = animationState _unit;
	_stamp = time;
	
	//keep active until the conditions are met
	while {(TOUR_turnToward_active) && (call compile _condition) && (alive _unit) && ((time - _stamp) < _timeout)} do 
	{
		_relativeDir = _unit getRelDir TOUR_turnTarget;
		if ((_relativeDir > 0)&&(_relativeDir < 180)) then //if target is on unit's right
		{
			if ((round (_unit getDir TOUR_turnTarget)) != ((round getDir _unit))) then //when not facing the right way, force it
			{
				if ((animationState _unit != "amovpercmwlksnonwnondf") && (animationState _unit != "amovpercmwlksnonwnondb") && TOUR_turn_playAnim) then //dont animate when walking 
				{
					_unit playActionNow "turnR"; 
					_stopped = nil;
				}; 
				_unit setDir (getDir _unit + _increment); //still control direction even if animations are disabled
			} 
			else //when facing correct direction exit turning animations immediately 
			{
				if (isNil "_stopped") then //don't spam playActionNow repeatedly
				{
					_unit playActionNow "Stop";
					_stopped = true;
				};
			}; 
		}
		else //if target is on unit's left
		{
			if ((round (_unit getDir TOUR_turnTarget)) != ((round getDir _unit))) then 
			{
				if ((animationState _unit != "amovpercmwlksnonwnondf") && (animationState _unit != "amovpercmwlksnonwnondb") && TOUR_turn_playAnim) then 
				{
					_unit playActionNow "turnL";
					_stopped = nil;
				}; 
				_unit setDir (getDir _unit - _increment); 
			} 
			else 
			{
				if (isNil "_stopped") then 
				{
					_unit playActionNow "Stop";
					_stopped = true;
				};
			};
		};
	};
	
	_unit playActionNow "Stop";
	if ((time-_stamp) >= _timeout) then {_unit setDir (_unit getDir TOUR_turnTarget)}; //create a failsafe exit incase something goes wrong
	TOUR_turnTarget = nil;
};

