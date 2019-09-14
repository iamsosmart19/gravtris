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

class HowToState extends FlxState {
	var endButton: FlxButton;
	var howto:FlxText;
	public function clickEnd():Void {
	       FlxG.switchState(new MenuState());
	}
	override public function create():Void {
		endButton = new FlxButton(30, FlxG.height-30, "Return to Menu", clickEnd);
		add(endButton);

		howto = new FlxText(FlxG.width / 2 - 200, FlxG.height / 2 - 40, 600, 11);
		howto.alignment = LEFT; 
		howto.text = "This game was partly(completely) inspired by Tetris.\n" + 
					 "However, the twist is that the player starts in the \n" +
					 "middle of the board, and the board itself rotates around.\n" + 
					 "\nCONTROLS:\n" + 
					 " - left and write to move tromino, and up to rotate" + 
					 "" 
					 ;
		add(howto);
		super.create();
	}

	override public function update(elapsed:Float):Void {
		 //
		 super.update(elapsed);
	}

}
