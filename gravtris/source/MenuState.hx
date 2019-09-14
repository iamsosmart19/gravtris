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

class MenuState extends FlxState {
	var playButton:FlxButton;
	public function clickPlay():Void {
	       FlxG.switchState(new PlayState());
	}
	override public function create():Void {
		playButton = new FlxButton(0, 0, "Play", clickPlay);
		playButton.screenCenter();
		add(playButton);
		super.create();
	}

	override public function update(elapsed:Float):Void {
		 //switch to next screen if Enter pressed
		if(FlxG.keys.justPressed.ENTER) {
			clickPlay();
		}
		 super.update(elapsed);
	}

}
