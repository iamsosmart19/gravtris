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
		//			   1 2 3 4 5 6 7 8 9 1011
		this.tiles = [for(i in 0...16) [for(j in 0...16) 0]];

		var size:Int = 10;
		var cury:Int = 0;
		var curx:Int = 0;
		var stx:Int = curx;
		var gap:Int = 2;
		this.sprs = new Array<Array<FlxSprite>>();
		//16 by 16 matrix, in case it wasnt obvious
		this.sprs = [ for(i in 0...16) [for(j in 0...16) new FlxSprite().makeGraphic(size, size, FlxColor.WHITE)]];
		for (row in this.sprs)
		{
		    for (spr in row)
		    {
				spr.x = curx;
				spr.y = cury;
				//Increments x by the sprite size + the gap (to look sexy)
				curx += size + gap;
				//Renders sprite
				add(spr);
		    }
			//Increments y by the sprite size + the gap (oooh yeah)
		    cury += size + gap;
		    curx = stx;
		}

	}

	override public function update(elapsed:Float):Void
	{
		//do something -- anything!
		var tileIter:Iterator<Array<Int>> = this.tiles.iterator();
		var sprsIter:Iterator<Array<FlxSprite>> = this.sprs.iterator();
		var curx:Int = 0;
		var cury:Int = 0;
		while (tileIter.hasNext() && sprsIter.hasNext())
		{
			var tileRow:Array<Int>= tileIter.next();
			var sprsRow:Array<FlxSprite> = sprsIter.next();
			var trowItr:Iterator<Int> = tileRow.iterator();
			var srowItr:Iterator<FlxSprite> =sprsRow.iterator();
			while (trowItr.hasNext() && srowItr.hasNext())
			{
				var tile:Int = trowItr.next();				
				var spr:FlxSprite  = srowItr.next();
				if (tile == 0)
				{
					spr.color = FlxColor.GRAY;
				} else if (tile == 1)
				{
					spr.color = FlxColor.WHITE;
				}
			}

		}
			
					
		super.update(elapsed);
	}
}
