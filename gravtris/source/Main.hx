package;

import flixel.FlxGame;
import openfl.display.Sprite;

class Main extends Sprite
{
	public function new()
	{
		var tiles:Array<Array<Int>> = [[0,0,0],[0,1,0],[0,0,0]];
		super();
		addChild(new FlxGame(0, 0, PlayState));
	}
}
