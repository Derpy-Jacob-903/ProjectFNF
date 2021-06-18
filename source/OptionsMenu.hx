package;

import Controls.Control;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;

class OptionsMenu extends MusicBeatState
{
	public static var instance:OptionsMenu;

	var selector:FlxText;
	var curSelected:Int = 0;

	var controlsStrings:Array<String> = [];

	private var grpControls:FlxTypedGroup<Alphabet>;

	public var acceptInput:Bool = true;

	var optionsText:FlxText;
	var optionsDesc:FlxText;

	override function create()
	{
		instance = this;

		var menuBG:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		controlsStrings = CoolUtil.coolTextFile(Paths.txt('options'));
		menuBG.color = FlxColor.GRAY;
		menuBG.setGraphicSize(Std.int(menuBG.width * 1.1));
		menuBG.updateHitbox();
		menuBG.screenCenter();
		menuBG.antialiasing = true;
		add(menuBG);
		optionsText = new FlxText(FlxG.width * 0.7, 5, 0, "", 32);
		optionsText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, RIGHT);
		optionsDesc = new FlxText(830, 80, 450, "", 32);
		optionsDesc.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, RIGHT);
		var optionsBG:FlxSprite = new FlxSprite(optionsText.x - 6, 0).makeGraphic(Std.int(FlxG.width * 0.55), 80, 0xFF000000);
		optionsBG.alpha = 0.6;
		add(optionsBG);
		add(optionsText);
		add(optionsDesc);

		
			grpControls = new FlxTypedGroup<Alphabet>();
			add(grpControls);
			controlsStrings[controlsStrings.length + 1] = "setCustomize Keybinds";
			for (i in 0...controlsStrings.length)
			{
				switch(controlsStrings[i].substring(3).split(" || ")[0]) {
					case "Ghost Tapping":
						if (!FlxG.save.data.ghosttapping)
							FlxG.save.data.ghosttapping = controlsStrings[curSelected].split(" || ")[2];
					case "Downscroll":
						if (!FlxG.save.data.downscroll)
							FlxG.save.data.downscroll = controlsStrings[curSelected].split(" || ")[2];
					case "Miss Shake":
						if (!FlxG.save.data.missshake)
							FlxG.save.data.missshake = controlsStrings[curSelected].split(" || ")[2];
					case "Dad Notes Visible":
						if (!FlxG.save.data.dadnotesvisible)
							FlxG.save.data.dadnotesvisible = controlsStrings[curSelected].split(" || ")[2];
					}
					FlxG.save.flush();


				if (controlsStrings[i].indexOf('set') != -1)
				{
					var controlLabel:Alphabet = new Alphabet(0, (70 * i) + 30, controlsStrings[i].substring(3).split(" || ")[0], true, false);
					controlLabel.isMenuItem = true;
					controlLabel.targetY = i;
					grpControls.add(controlLabel);
				}
				// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
			}
		 

		super.create();
		changeSelection();
	//	openSubState(new OptionsSubState());
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		
			if (controls.ACCEPT)
			{
				// hey, atleast its not yanderedev
				//trace(controlsStrings[curSelected].substring(3).split(" || ")[0]);
				switch(controlsStrings[curSelected].substring(3).split(" || ")[0]) {
					case "Downscroll":
						//trace("Before: " + FlxG.save.data.downscroll);
						FlxG.save.data.downscroll = !FlxG.save.data.downscroll;
						optionsText.text = FlxG.save.data.downscroll;
						//trace("After: " + FlxG.save.data.downscroll);
					case "Ghost Tapping":
						//trace("Before: " + FlxG.save.data.ghosttapping);
						FlxG.save.data.ghosttapping = !FlxG.save.data.ghosttapping;
						optionsText.text = FlxG.save.data.ghosttapping;
						//trace("After: " + FlxG.save.data.ghosttapping);
					case "Miss Shake":
						FlxG.save.data.missshake = !FlxG.save.data.missshake;
						optionsText.text = FlxG.save.data.missshake;//FlxG.save.data.dadnotesvisible
					case "Dad Notes Visible":
						FlxG.save.data.dadnotesvisible = !FlxG.save.data.dadnotesvisible;
						optionsText.text = FlxG.save.data.dadnotesvisible;
					default: // lol
						OptionsMenu.instance.openSubState(new KeyBindMenu());
				}
				FlxG.save.flush();
				// this could be us but FlxG savedata sucks dick and im too lazy too see how kade engine did it
			//	FlxG.save.data[controlsStrings[curSelected].split(" || ")[1]] = !FlxG.save.data.options[controlsStrings[curSelected].split(" || ")[1]];
			}
				if (controls.BACK)
					FlxG.switchState(new MainMenuState());
				if (controls.UP_P)
					changeSelection(-1);
				if (controls.DOWN_P)
					changeSelection(1);
		 
	}

	function waitingInput():Void
	{
		if (FlxG.keys.getIsDown().length > 0)
		{
			PlayerSettings.player1.controls.replaceBinding(Control.LEFT, Keys, FlxG.keys.getIsDown()[0].ID, null);
		}
		// PlayerSettings.player1.controls.replaceBinding(Control)
	}

	var isSettingControl:Bool = false;

	function changeBinding():Void
	{
		if (!isSettingControl)
		{
			isSettingControl = true;
		}
	}

	function changeSelection(change:Int = 0)
	{
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		curSelected += change;

		if (curSelected < 0)
			curSelected = grpControls.length - 1;
		if (curSelected >= grpControls.length)
			curSelected = 0;


		//trace(controlsStrings[curSelected].substring(3).split(" || ")[0]);
		switch(controlsStrings[curSelected].substring(3).split(" || ")[0]) {
			case "Ghost Tapping":
				optionsText.text = FlxG.save.data.ghosttapping;
			case "Downscroll":
				optionsText.text = FlxG.save.data.downscroll;
			case "Miss Shake":
				optionsText.text = FlxG.save.data.missshake;
			case "Dad Notes Visible":
				optionsText.text = FlxG.save.data.dadnotesvisible;
			default: // lol im lazy
				optionsText.text = "Press ENTER";
				optionsDesc.text = "Customize the keys you use. (Up down left right)";
		}
		// how did it take me this long to figure this out bruh (still applies here)
		optionsDesc.text = controlsStrings[curSelected].split(" || ")[1];

		// selector.y = (70 * curSelected) + 30;
		var bullShit:Int = 0;
		for (item in grpControls.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;
			
			item.alpha = 0.6;
			// item.setGraphicSize(Std.int(item.width * 0.8));

			if (item.targetY == 0)
			{
				item.alpha = 1;
				// item.setGraphicSize(Std.int(item.width));
			}
		}
	}
}