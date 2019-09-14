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

class CreditsState extends FlxState {
	public function clickEnd():Void {
	       FlxG.switchState(new MenuState());
	}
	override public function create():Void {
		super.create();
	}

	override public function update(elapsed:Float):Void {
		 //
		 super.update(elapsed);
	}

}
