_player = player;
if ("rhsusf_acc_T1_low_fwd" in (_player weaponAccessories primaryWeapon _player)) then
{
	//allow moving of weapon optic to rear rail
	KAIN_fnc_opticRearAction = 
	{
		player addAction
		[
			"Mount optic REAR",	
			{
				params ["_target", "_caller", "_actionId", "_arguments"]; 
				//_mode = currentWeaponMode _caller;
				_weapon = currentWeapon _caller;
				_ammo = _caller ammo _weapon;
								
				//animate
				_caller playAction "MountOptic";
				waitUntil {((animationState _caller == "mountoptic") && (moveTime _caller > 2)) or !(alive _caller)}; //wait until correct frame of animation
				_caller removePrimaryWeaponItem "rhsusf_acc_T1_low_fwd";
				_caller addPrimaryWeaponItem "rhsusf_acc_T1_low";
				
				//display reverse action
				[] call KAIN_fnc_opticFrontAction;
				
				//switch firemode back after it is set to safe
				_caller setAmmo [_weapon, 0];
				_caller forceWeaponFire [_weapon, "Single"];
				_caller setAmmo [_weapon, _ammo];
				
				_caller removeAction _actionId;
			},
			nil, 1.5, false		
		];
	};
	
	//allow moving of weapon optic to front rail
	KAIN_fnc_opticFrontAction = 
	{
		player addAction
		[
			"Mount optic FRONT",	
			{
				params ["_target", "_caller", "_actionId", "_arguments"];
				//_mode = currentWeaponMode _caller;
				_weapon = currentWeapon _caller;
				_ammo = _caller ammo _weapon;

				//animate
				_caller playAction "MountOptic";
				waitUntil {((animationState _caller == "mountoptic") && (moveTime _caller > 1.8)) or !(alive _caller)}; //wait until correct frame of animation				
				_caller removePrimaryWeaponItem "rhsusf_acc_T1_low";
				_caller addPrimaryWeaponItem "rhsusf_acc_T1_low_fwd";
				
				//display reverse action
				[] call KAIN_fnc_opticRearAction;
				
				//switch firemode back after it is set to safe
				_caller setAmmo [_weapon, 0];
				_caller forceWeaponFire [_weapon, "Single"];
				_caller setAmmo [_weapon, _ammo];
				
				_caller removeAction _actionId;
			},
			nil, 1.5, false		
		];
	};
};