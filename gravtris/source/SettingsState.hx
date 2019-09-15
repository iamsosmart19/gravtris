package;

import flixel.FlxState;
import flixel.FlxSprite;
import flixel.addons.ui.FlxUICheckBox;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.math.FlxPoint;
import flixel.math.FlxRandom;
import flixel.FlxG;

class SettingsState extends FlxState {
	var endButton: FlxButton;
	var turnScreen: FlxUICheckBox; 
	var title: FlxText;
	var flipScreen:Bool;
	public function clickEnd():Void {
	       FlxG.switchState(new MenuState(flipScreen));
	}
	public function turnScreenClicked():Void { 
		trace("clicked");
		flipScreen = !(flipScreen);
	}
	override public function create():Void {
		flipScreen = true;

		endButton = new FlxButton(30, FlxG.height-30, "Return to Menu", clickEnd);
		add(endButton);

		//Title

		//Turn Screen option
		turnScreen = new FlxUICheckBox(FlxG.width / 2 - 100, FlxG.height / 2 - 30, null, null, "Turn the Screen?", 100);
		turnScreen.callback = turnScreenClicked.bind();
		turnScreen.checked = true;
		add(turnScreen);
		super.create();
	}

	override public function update(elapsed:Float):Void {
		 //
		 super.update(elapsed);
	}

}
