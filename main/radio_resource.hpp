class NEO_baseRadioResource
{
	idd = 566666;
	movingEnable = 0;
	onLoad = "[] call NEO_fnc_onRadioOpen";
	
	class controls
	{
		//Background
		class NEO_baseRadioBackground
		{
			idc = 577778;
			type = 0;
			style = 48;
			colorBackground[] = { };
			colorText[] = { 0,0,0,0.75};
			font = "EtelkaMonospacePro";
			sizeEx = 0.023;
			moving = 0;
			x = "(safeZoneX + (safeZoneW / 5))";
			y = "(safeZoneY + (safeZoneH / 3.25))";
			w = "(safeZoneW / 2.5)";
			h = "(safeZoneH / 4.5)";
			text = "\a3\ui_f\data\gui\RscCommon\RscBackgroundGUI\gradient_left_gs.paa"; //
			onDestroy = "[] call NEO_fnc_onRadioClose";
		};
		
		//Logo
		class NEO_baseRadioLogo : NEO_baseRadioBackground
		{
			idc = -1;
			x = "(safeZoneX + (safeZoneW / 5))";
			y = "(safeZoneY + (safeZoneH / 3.25))";
			w = "(safeZoneW / 40)";
			h = "(safeZoneH / 40)";
			text = "main\img\radio_logo.paa";
		};
		
		//Title
		class NEO_baseRadioTitle
		{ 
			idc = -1; 
			type = 13; 
			style = 0x00;
			colorBackground[] = { 0, 0, 0, 0 };
			size = "((safeZoneW / 75) + (safeZoneH / 225))";
			x = "safeZoneX + (safeZoneW / 4)"; 
			y = "safeZoneY + (safeZoneH / 3)"; 
			w = "safeZoneW / 5"; 
			h = "safeZoneH / 10";
			text = "SATELLITE RADIO";
		};
		
		//Buttons
		class NEO_baseRadioButton_CAS
		{
			idc = 577779;
			type = 16;
			style = 0x00;
			default = 0;
			shadow = 2;
			x = "safeZoneX + (safeZoneW / 4.5)";
			y = "safeZoneY + (safeZoneH / 2.4)";
			w = "(safeZoneW / 5)";
			h = "(safeZoneH / 20)";
			sizeEx = 1;
			color[] = {0.85, 0.85, 0.85, 1.0};
			color2[] = {0.95, 0.95, 0.95, 1};
			colorBackground[] = {1, 1, 1, 0.6};
			colorbackground2[] = {1, 1, 1, 0.3};
			colorDisabled[] = {1, 1, 1, 0.25};
			colorFocused[] = {0, 0, 0, 0.5};
			colorBackgroundFocused[] = {1, 1, 1, 0.35};
			periodOver = 0.8;
			
			class HitZone
			{
				left = "safeZoneW / 100";
				top = "safeZoneH / 100";
				right = "safeZoneW / 100";
				bottom = "safeZoneH / 100";
			};
			
			class ShortcutPos
			{
				left = "safeZoneW / 100";
				top = "safeZoneH / 100";
				w = "safeZoneW / 100";
				h = "safeZoneH / 100";
			};
			
			class TextPos
			{
				left = "safeZoneW / 50";
				right = "safeZoneW / 50";
				top = "safeZoneH / 75";
				bottom = "safeZoneH / 100";
			};
			animTextureNormal = "\a3\ui_f\data\gui\RscCommon\RscShortcutButtonMain\normal_ca.paa";
			animTextureDisabled = "\a3\ui_f\data\gui\RscCommon\RscShortcutButtonMain\disabled_ca.paa";
			animTextureOver = "\a3\ui_f\data\gui\RscCommon\RscShortcutButtonMain\over_ca.paa";
			animTextureFocused = "\a3\ui_f\data\gui\RscCommon\RscShortcutButtonMain\focus_ca.paa";
			animTexturePressed = "\a3\ui_f\data\gui\RscCommon\RscShortcutButtonMain\down_ca.paa";
			animTextureDefault = "\a3\ui_f\data\gui\RscCommon\RscShortcutButtonMain\normal_ca.paa";
			period = 0.4;
			font = "EtelkaMonospacePro";
			size = "(safeZoneW / 125) + (safeZoneH / 125)";
			text = "- Call Close Air Support";
			soundEnter[] = {"\a3\ui_f\data\Sound\RscButton\soundEnter", 0.09, 1};
			soundPush[] = {"\a3\ui_f\data\Sound\RscButton\soundPush", 0.0, 0};
			soundClick[] = {"\a3\ui_f\data\Sound\RscButton\soundClick", 0.07, 1};
			soundEscape[] = {"\a3\ui_f\data\Sound\RscButton\soundEscape", 0.09, 1};
			textureNoShortcut = "";
			action = "[] call NEO_fnc_onRadioCasCalled; while { dialog } do { closeDialog 0 }";
			
			class Attributes
			{
				font = "EtelkaMonospacePro";
				color = "#E5E5E5";
				align = "left";
				shadow = "true";
			};
			
			class AttributesImage
			{
				font = "EtelkaMonospacePro";
				color = "#E5E5E5";
				align = "left";
			};
		};
		class NEO_baseRadioButton_ABORT : NEO_baseRadioButton_CAS
		{
			idc = 577781;
			text = "- Call EVAC (ABORT MISSION)";
			y = "safeZoneY + (safeZoneH / 2.25)";
			action = "[] call NEO_fnc_onRadioEvacCalled; while { dialog } do { closeDialog 0 }";
		};
		class NEO_baseRadioButton_CLOSE : NEO_baseRadioButton_CAS
		{
			idc = 577782;
			default = 1;
			text = "CLOSE";
			x = "safeZoneX + (safeZoneW / 3.1)";
			y = "safeZoneY + (safeZoneH / 2.1)";
			w = "(safeZoneW / 10)";
			action = "while { dialog } do { closeDialog 0 }";
		};
	};
};
