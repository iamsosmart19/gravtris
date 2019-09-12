package;

import flixel.FlxGame;
import openfl.display.Sprite;

class Main extends Sprite {
	public function new() {
		// does this file own anything? Whom knows
		super();
		addChild(new FlxGame(0, 0, MenuState));
	}
}
