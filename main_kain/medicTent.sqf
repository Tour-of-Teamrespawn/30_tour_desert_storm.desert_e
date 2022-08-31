//Allow healing at medic tent using ACE medical
KAIN_healAtTentAction = 
{
	player addAction
	[
		"TREAT YOUR WOUNDS",	
		{
			params ["_target", "_caller", "_actionId", "_arguments"];
			_latrine = KAIN_medicBag;
			_victim = _caller;
			_dir = getDir _victim;
			TOUR_latrinePosLeft = KAIN_medicBag modelToWorld [0.856995,-0.0739746,-0.113819];
			_latrineDir = ((getDir KAIN_medicBag) - 90);
			_latrine setVariable ["TOUR_medicTentInUse", [true, _victim], true];
			
			//stop any momentum
			_victim setVelocity [0, 0, 0];
			[_victim, getPos _victim] call TOUR_fnc_teleportPlayerMP;
			_victim setDir _dir;
			
			//force player to look in a certain direction
			[_victim, TOUR_latrinePosLeft, 0.01, "true", -1, true] spawn TOUR_fnc_turnTowards; //_this select 2 = _increment in degrees (affects speed)
			waitUntil {!isNil "TOUR_turnTarget"}; //make sure TOUR_fnc_turnTowards is running
					
			//wait for player to stop moving thier mouse or pressing movement keys
			_stamp = time;
			private _condition = false;
			waitUntil
			{
				if
				((
					(round (_victim getDir TOUR_turnTarget)) == ((round getDir _victim)) && //correct direction
					(animationState _victim != "amovpercmstpsnonwnondnon_turnr") && //stopped turning anim
					(animationState _victim != "amovpercmstpsnonwnondnon_turnl") ////stopped turning anim
				) 
				or ((_victim distance _latrine) > 6) or !(alive _victim)) //failsafes
				
				then 
				{
					//remove player input controls
					disableUserInput true;
					_stamp = time;
					waitUntil {(userInputDisabled) or !(alive _victim) or ((time-_stamp)>3)};
					TOUR_turn_playAnim = false; //stop animations playing, but keep setting direction
					_condition = true; //exit
				};
				_condition
			}; _condition = nil;	
			
			//make player walk to correct position to start the anim
			_victim playActionNow "WalkF"; 
			_stamp = time;
			waitUntil {((_victim distance _latrine) < 1.4) or ((_victim distance _latrine) > 6) or !(alive _victim) or ((time-_stamp)>5)};
					
			//stop moving
			TOUR_turnToward_active = false; //this will terminate TOUR_fnc_turnTowards
			waitUntil {isNil "TOUR_turnTarget"};
			_victim playActionNow "Stop";
			
			//keep player accurately alligned
			[_victim, TOUR_latrinePosLeft] call TOUR_fnc_teleportPlayerMP;
			_victim setDir _latrineDir;
			
			//animate
			_caller playmove "ainvpknlmstpslaywrfldnon_medic";
			waitUntil {(animationState _caller=="ainvpknlmstpslaywrfldnon_medic") or !(alive _target)};
			waitUntil {(animationState _caller!="ainvpknlmstpslaywrfldnon_medic") or !(alive _target)};
			
			//heal
			[_caller] call ace_medical_treatment_fnc_fullHealLocal;
			
			//set free
			if (userInputDisabled) then {disableUserInput false}; //dont set more than once or... gremlins
			TOUR_turnToward_active = false; //this will terminate TOUR_fnc_turnTowards
			_victim setDir _latrineDir;
			_latrine setVariable ["TOUR_medicTentInUse", [false, objNull], true];
			
			//60 second cooldown after each use
			_caller removeAction _actionId;
			[] spawn {sleep 60;[] call KAIN_healAtTentAction};
			
		},
		nil, 10, true, true, "", "((_this distance KAIN_medicStation) < 2) && !((KAIN_medicBag getVariable [""TOUR_medicTentInUse"", [false, objNull]]) select 0)" 		
	];
	
};