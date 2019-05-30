package;

import flixel.FlxState;
import flixel.FlxSprite;
import flixel.util.FlxColor;

class PlayState extends FlxState
{
	var tiles:Array<Array<Int>>;
	var sprs:Array<Array<FlxSprite>>;
	override public function create():Void
	{
		super.create();
		this.tiles = [[0,0,0],[0,1,0],[0,0,0]];
		var size:Int = 10;
		var cury:Int = 0;
		var curx:Int = 0;
		var stx:Int = curx;
		var gap:Int = 2;
		this.sprs = New Array();
		//3 by 3 matrix, in case it wasnt obvious
		for (i in 0...2)
		{
			this.sprs.push([new FlxSprite().makeGraphic(size, size, FlxColor.GRAY),
					new FlxSprite().makeGraphic(size, size, FlxColor.GRAY),
					new FlxSprite().makeGraphic(size, size, FlxColor.GRAY)]);
		}
		//this.sprs = [[new FlxSprite().makeGraphic(size, size, FlxColor.GRAY),new FlxSprite().makeGraphic(size, size, FlxColor.GRAY),new FlxSprite().makeGraphic(size, size, FlxColor.GRAY)],[new FlxSprite().makeGraphic(size, size, FlxColor.GRAY),new FlxSprite().makeGraphic(size, size, FlxColor.GRAY),new FlxSprite().makeGraphic(size, size, FlxColor.GRAY)],[new FlxSprite().makeGraphic(size, size, FlxColor.GRAY),new FlxSprite().makeGraphic(size, size, FlxColor.GRAY),new FlxSprite().makeGraphic(size, size, FlxColor.GRAY)]];
		for (row in this.sprs)
		{
		    for (spr in row)
		    {
			spr.x = curx;
			spr.y = cury;
			curx += size + gap;
			add(spr);
		    }
		    cury += size + gap;
		    curx = stx;
		}

	}

	override public function update(elapsed:Float):Void
	{

		for (row in this.tiles)
		{
			for (tile in row)
			{
			// do something
			}
		}
					
		super.update(elapsed);
	}
}
