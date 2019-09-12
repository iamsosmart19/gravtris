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

class OverState extends FlxState {
	var playButton:FlxButton;
	var endButton:FlxButton;
	public function clickPlay():Void {
	       FlxG.switchState(new PlayState());
	}
	public function clickEnd():Void {
	       FlxG.switchState(new MenuState());
	}
	override public function create():Void {
		playButton = new FlxButton(0, 0, "Play Again", clickPlay);
		playButton.screenCenter();
		add(playButton);
		endButton  = new FlxButton(playButton.x, playButton.y+40, "Return to Menu", clickEnd);
		add(endButton);
		super.create();
	}

	override public function update(elapsed:Float):Void {
		 //
		 super.update(elapsed);
	}

}