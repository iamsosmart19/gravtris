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
	var howToPlayButton:FlxButton;
	var settingsButton:FlxButton;
	var creditsButton:FlxButton;
	var title:FlxText;
	var flipScreen: Bool;

	public function clickPlay():Void {
	       FlxG.switchState(new PlayState(flipScreen));
	}

	public function clickHowPlay():Void {
	       FlxG.switchState(new HowToState());
	}

	public function clickSetPlay():Void {
	       FlxG.switchState(new SettingsState());
	}

	public function clickCredPlay():Void {
	       FlxG.switchState(new CreditsState());
	}

	public function new(?flipDaScreen:Bool = true) {
		flipScreen = flipDaScreen;
		super();
	}

	override public function create():Void {
		title = new FlxText(FlxG.width / 2 - 175, FlxG.height / 2 - 100, 400, "GRAVTRIS", 64);
		add(title);

		//Start Game
		playButton = new FlxButton(0, 0, "Play", clickPlay);
		playButton.setPosition(FlxG.width / 2 - 10 - playButton.width, FlxG.height / 2 - 10);
		add(playButton);

		//Redirects to how to play screen
		howToPlayButton = new FlxButton(0, 0, "How To Play", clickHowPlay);
		howToPlayButton.setPosition(FlxG.width / 2 + 10, FlxG.height / 2 - 10);
		add(howToPlayButton);

		//Start Game
		settingsButton = new FlxButton(0, 0, "Settings", clickSetPlay);
		settingsButton.setPosition(FlxG.width / 2 - 10 - playButton.width, FlxG.height / 2 + 10);
		add(settingsButton);

		//Start Game
		creditsButton = new FlxButton(0, 0, "Credits", clickCredPlay);
		creditsButton.setPosition(FlxG.width / 2 + 10, FlxG.height / 2 + 10);
		add(creditsButton);

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
