package;

import flixel.FlxState;
import flixel.FlxSprite;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.math.FlxPoint;
import flixel.math.FlxRandom;
import flixel.FlxG;

class SettingsState extends FlxState {
	var endButton: FlxButton;
	public function clickEnd():Void {
	       FlxG.switchState(new MenuState());
	}
	override public function create():Void {
		endButton = new FlxButton(30, FlxG.height-30, "Return to Menu", clickEnd);
		add(endButton);
		super.create();
	}

	override public function update(elapsed:Float):Void {
		 //
		 super.update(elapsed);
	}

}
