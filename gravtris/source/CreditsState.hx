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
	var endButton: FlxButton;
	var credits:FlxText;
	public function clickEnd():Void {
	       FlxG.switchState(new MenuState());
	}
	override public function create():Void {
		endButton = new FlxButton(30, FlxG.height-30, "Return to Menu", clickEnd);
		add(endButton);

		credits = new FlxText();
		credits.text = "Developed by Chris Ahn and Ethan du Toit.";
		credits.screenCenter();
		add(credits);
		super.create();
	}

	override public function update(elapsed:Float):Void {
		 //
		 super.update(elapsed);
	}

}
