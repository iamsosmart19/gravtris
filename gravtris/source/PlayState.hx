package;

import flixel.FlxState;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.math.FlxPoint;

class PlayState extends FlxState
{
	var tiles:Array<Array<Int>>;
	var sprs:Array<Array<FlxSprite>>;
	var title:FlxText;
	var tromino:Tetromino;
	var downinterval:Float;
	var downtimer:Float;
	override public function create():Void
	{
		super.create();	@:generic
		this.tiles = [for(i in 0...16) [for(j in 0...16) 0]];
		this.tromino = new Tetromino(2);
		this.downinterval = 1.0;
		this.downtimer = 0.0;
		var size:Int = 20;
		var gap:Int = 4;
		var cury:Int = gap * 5;
		var curx:Int = gap * 5;
		var stx:Int = curx;
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

		title = new FlxText(stx + size * 16 + 80, 100, 200);
		title.text = "GRAVTRIS";	
		title.setFormat("assets/font.ttf", 24, FlxColor.WHITE, CENTER);
		title.setBorderStyle(OUTLINE, FlxColor.BLUE, 1);
		add(title);
	}

	override public function update(elapsed:Float):Void
	{
		//update timers
		this.downtimer += elapsed;
		//trace(this.downtimer);
		if (this.downtimer > this.downinterval) {
		   this.tromino.down();
		   this.downtimer = 0.0;
		}
		//do something -- anything!
		var realones:Array<Array<Int>> = tromino_plus_tiles(this.tromino, this.tiles);
		//trace(realones);
		var tileIter:Iterator<Array<Int>> = realones.iterator();
		var sprsIter:Iterator<Array<FlxSprite>> = this.sprs.iterator();
		while (tileIter.hasNext() && sprsIter.hasNext()) 
		{
			var tileRow:Array<Int> = tileIter.next();
			var sprsRow:Array<FlxSprite> = sprsIter.next();
			var trowItr:Iterator<Int> = tileRow.iterator();
			var srowItr:Iterator<FlxSprite> = sprsRow.iterator();
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
	
	public function offset_matrix(matrix:Array<Array<Int>>, x:Int, y:Int, xSize:Int, ySize:Int):Array<Array<Int>>{
	       var returnmatrix:Array<Array<Int>>;
	       returnmatrix = [for(i in 0...ySize) [for(j in 0...xSize) 0]];
	       for (yC in 0...matrix.length) {
	       	   for (xC in 0...matrix[yC].length) {
		       returnmatrix[yC+y][xC+x] = matrix[yC][xC];
		   }
	       }
	       return returnmatrix;
	}
	//if m1 and m2 arent the same size when you call this you WILL die
	public function overlay_matrices(m1:Array<Array<Int>>, m2:Array<Array<Int>>):Array<Array<Int>> {
	       var returnmatrix:Array<Array<Int>>;
	       returnmatrix = [for(i in 0...m1.length) [for(j in 0...m1[0].length) 0]];
	       for (yC in 0...returnmatrix.length) {
	       	   for (xC in 0...returnmatrix[0].length) {
		       returnmatrix[yC][xC] = m1[yC][xC] | m2[yC][xC]; //fck it. bitwise or
		   }
	       }
	       return returnmatrix;
	}

	public function tromino_plus_tiles(tromino:Tetromino, tiles:Array<Array<Int>>):Array<Array<Int>> {
	       //trace( offset_matrix(tromino.blocks(), tromino.x(), tromino.y(), tiles[0].length, tiles.length));
	       return overlay_matrices(tiles, offset_matrix(tromino.blocks(), tromino.x(), tromino.y(), tiles[0].length, tiles.length));
	}
	       
}	

