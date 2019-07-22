package;

import flixel.FlxState;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.math.FlxPoint;
import flixel.math.FlxRandom;
import flixel.FlxG;

class PlayState extends FlxState
{
	var tiles:Array<Array<Int>>;
	var sprs:Array<Array<FlxSprite>>;
	var title:FlxText;
	var tromino:Tetromino;
	var downinterval:Float;
	var downtimer:Float;
	var magicnumber:Int; //for xmino x-1
	var softdrop:Bool;
	var bag:Array<Int>;
	var arrow:FlxSprite;
	var flipScreen:Bool;
	override public function create():Void
	{
		super.create();	
		this.magicnumber = 3; //needs to be before .tiles
		this.tiles = prosthetise([for(i in 0...16) [for(j in 0...16) 0]]);
		this.bag = [0,1,2,3,4,5,6]; //needs to be before .tromino
		this.downinterval = 1.0;
		this.downtimer = 0.0;
		this.softdrop = false;
		this.flipScreen = false;
		this.tromino = new Tetromino(next_bag(), this.flipScreen);
		this.arrow = new FlxSprite();
		this.arrow.loadGraphic("assets/images/arrow.png");
		if (!this.flipScreen) {
		   add(this.arrow);
		}
		this.arrow.x = 500;
		this.arrow.y = 500;
		//sprite init
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
		////trace(this.downtimer);

		//BEGINNING OF INPUT CODE
		controls(this.tromino);
		//END OF INPUT CODE
		//TODO -- REFACTOR INPUT
		
		//TODO: CONTROLS LINKED TO SINGLE TETROMINOS
		if (this.downtimer > this.downinterval) {
		   this.tromino.down();
		   if (tromino_collide_tiles(this.tromino, this.tiles)) {
		      this.tromino.up();
		      die();
		   }
		   this.downtimer = 0.0;
		}

		//END OF GAMEPLAY CODE


		//BEGINNING OF DISPLAY CODE
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

		switch (this.tromino.grav()) {
		       case 0: this.arrow.angle = 0;
		       case 1: this.arrow.angle = 270;
		       case 2: this.arrow.angle = 180;
		       case 3: this.arrow.angle = 90;}
			
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
	       ////trace( offset_matrix(tromino.blocks(), tromino.x(), tromino.y(), tiles[0].length, tiles.length));
	       return deprosthetise(overlay_matrices(tiles, offset_matrix(tromino.blocks(), tromino.x()+this.magicnumber, tromino.y()+this.magicnumber, tiles[0].length, tiles.length)));
	}

	public function prosthetise(tiles:Array<Array<Int>>):Array<Array<Int>> {
	       var newtiles:Array<Array<Int>>;
	       newtiles = [for(i in 0...(tiles.length+(this.magicnumber*2)))  [for(j in 0...(tiles[0].length+(this.magicnumber*2))) -1]];
	       for (yC in 0...tiles.length) {
	       	   for (xC in 0...tiles[yC].length) {
				   newtiles[yC+this.magicnumber][xC+this.magicnumber] = tiles[yC][xC];
			   }
	       }
	       return newtiles;
	}

	public function deprosthetise(tiles:Array<Array<Int>>):Array<Array<Int>> {
	       var newtiles:Array<Array<Int>>;
	       newtiles = [for(i in 0...(tiles.length-(this.magicnumber*2)))  [for(j in 0...(tiles[0].length-(this.magicnumber*2))) 0]];
	       for (yC in 0...tiles.length) {
	       	   for (xC in 0...tiles[yC].length) {
				   if (((yC+this.magicnumber*2)<(tiles.length)) && ((xC+this.magicnumber*2)<(tiles[yC].length))) {
					  newtiles[yC][xC] = tiles[yC+this.magicnumber][xC+this.magicnumber];
				   }
			   }
	       }
	       return newtiles;
	}

	public function matrices_collidep(m1:Array<Array<Int>>, m2:Array<Array<Int>>):Bool {
		var m1Iter:Iterator<Array<Int>> = m1.iterator();
		var m2Iter:Iterator<Array<Int>> = m2.iterator();
		while (m1Iter.hasNext() && m2Iter.hasNext()) 
		{
			var m1Row:Array<Int> = m1Iter.next();
			var m2Row:Array<Int> = m2Iter.next();
			var r1Itr:Iterator<Int> = m1Row.iterator();
			var r2Itr:Iterator<Int> = m2Row.iterator();
			while (r1Itr.hasNext() && r2Itr.hasNext()) 
			{
				var m1a:Int = r1Itr.next();				
				var m2a:Int = r2Itr.next();
				if ((m1a != 0) && (m2a != 0)) {
				   return true;
				}
			}
		}
		return false;
	}

	public function tromino_collide_tiles(tromino:Tetromino, tiles:Array<Array<Int>>):Bool {
	       return matrices_collidep(tiles, offset_matrix(tromino.blocks(), tromino.x()+this.magicnumber, tromino.y()+this.magicnumber, tiles[0].length, tiles.length));
	}

	public function next_bag():Int {
	       if (this.bag.length == 0) {
	       	  this.bag = [0,1,2,3,4,5,6];
               }
	       FlxG.random.shuffle(this.bag);
	       return this.bag.pop();
	}

	public function controls(tromino:Tetromino) {
	       if (!this.flipScreen) {
	       var relDownPressed:Bool = false;
	       var relUpPressed:Bool = false;
	       var relLeftPressed:Bool = false;
	       var relRightPressed:Bool = false;
	       var relDownReleased:Bool = false;
	       switch tromino.grav() {
	       	      case 0:
	       	      {
			relDownPressed = FlxG.keys.justPressed.DOWN;
			relDownReleased = FlxG.keys.justReleased.DOWN;
			relUpPressed = FlxG.keys.justPressed.UP;
			relLeftPressed = FlxG.keys.justPressed.LEFT;
			relRightPressed = FlxG.keys.justPressed.RIGHT;
		      };
		      case 1:
	       	      {
			relDownPressed = FlxG.keys.justPressed.RIGHT;
			relDownReleased = FlxG.keys.justReleased.RIGHT;
			relUpPressed = FlxG.keys.justPressed.LEFT;
			relLeftPressed = FlxG.keys.justPressed.UP;
			relRightPressed = FlxG.keys.justPressed.DOWN;
		      };		      
		      case 2:
	       	      {
			relDownPressed = FlxG.keys.justPressed.UP;
			relDownReleased = FlxG.keys.justReleased.UP;
			relUpPressed = FlxG.keys.justPressed.DOWN;
			relLeftPressed = FlxG.keys.justPressed.RIGHT;
			relRightPressed = FlxG.keys.justPressed.LEFT;
		      };
		      case 3:
	       	      {
			relDownPressed = FlxG.keys.justPressed.LEFT;
			relDownReleased = FlxG.keys.justReleased.LEFT;
			relUpPressed = FlxG.keys.justPressed.RIGHT;
			relLeftPressed = FlxG.keys.justPressed.DOWN;
			relRightPressed = FlxG.keys.justPressed.UP;
		      };		      
		  		      
		}
		if (relDownPressed) {
		   if (!this.softdrop) {
		      this.downinterval /= 8;
		      this.softdrop = true;
		   }
		}

		if (relDownReleased) {
		   if (this.softdrop) {
		      this.downinterval *= 8;
		      this.softdrop = false;
		   }
		}

		if (relLeftPressed) {
		   this.tromino.left();
		   if (tromino_collide_tiles(this.tromino, this.tiles)) {
		      this.tromino.right();
		   }
		}

		if (relRightPressed) {
		   this.tromino.right();
		   if (tromino_collide_tiles(this.tromino, this.tiles)) {
		      this.tromino.left();
		   }
		}

		if (FlxG.keys.justPressed.X || relUpPressed) {
		   this.tromino.rotateCW();
		   if (tromino_collide_tiles(this.tromino, this.tiles)) {
		      this.tromino.rotateCCW();
		      //TODO: super rotation system
		   }
		}

		if (FlxG.keys.justPressed.Z) {
		   this.tromino.rotateCCW();
		   if (tromino_collide_tiles(this.tromino, this.tiles)) {
		      this.tromino.rotateCW();
		      //TODO: super rotation system
		   }
		}
		if (FlxG.keys.justPressed.SPACE) {
			while(!tromino_collide_tiles(this.tromino, this.tiles)) {
				this.tromino.down();
			}
			this.tromino.up();
			die();
		}
		} else {
		if (FlxG.keys.justPressed.DOWN) {
		   if (!this.softdrop) {
		      this.downinterval /= 8;
		      this.softdrop = true;
		   }
		}

		if (FlxG.keys.justReleased.DOWN) {
		   if (this.softdrop) {
		      this.downinterval *= 8;
		      this.softdrop = false;
		   }
		}

		if (FlxG.keys.justPressed.LEFT) {
		   this.tromino.left();
		   if (tromino_collide_tiles(this.tromino, this.tiles)) {
		      this.tromino.right();
		   }
		}

		if (FlxG.keys.justPressed.RIGHT) {
		   this.tromino.right();
		   if (tromino_collide_tiles(this.tromino, this.tiles)) {
		      this.tromino.left();
		   }
		}

		if (FlxG.keys.anyJustPressed([UP, X])) {
		   this.tromino.rotateCW();
		   if (tromino_collide_tiles(this.tromino, this.tiles)) {
		      this.tromino.rotateCCW();
		      //TODO: super rotation system
		   }
		}

		if (FlxG.keys.justPressed.Z) {
		   this.tromino.rotateCCW();
		   if (tromino_collide_tiles(this.tromino, this.tiles)) {
		      this.tromino.rotateCW();
		      //TODO: super rotation system
		   }
		}
		if (FlxG.keys.justPressed.SPACE) {
			while(!tromino_collide_tiles(this.tromino, this.tiles)) {
				this.tromino.down();
			}
			this.tromino.up();
			die();
		}
		}
		
	}
	public function die() {
	      if (this.softdrop) {
	               this.downinterval *= 8;
		       this.softdrop = false;
	      }		      
	      this.tiles = prosthetise(tromino_plus_tiles(this.tromino, this.tiles));
	      this.tromino = new Tetromino(next_bag(), this.flipScreen);
	      var newgravity:Int = FlxG.random.int(0,3);
	      rem_full_lines(deprosthetise(this.tiles));
	      if (this.flipScreen) {
	      	 var gravity:Int = this.tromino.grav();
	      	 var newtiles:Array<Array<Int>> = [for(i in 0...tiles.length) [for(j in 0...tiles.length) 0]];
		 if (newgravity == gravity) {
		 }
		 else if(newgravity - gravity < 0) {
			for(i in 0...(4 - (newgravity - gravity))) 
			{
				for (y in 0...tiles.length) 
				{
					for(x in 0...tiles.length) 
					{
						newtiles[x][y] = tiles[y][x];
					}
				}
				for (row in newtiles) {
					row.reverse();
				}
			}
			tiles = newtiles;
		}
		else {
			for(i in 0...(newgravity - gravity)) 
			{
				for (y in 0...tiles.length) 
				{
					for(x in 0...tiles.length) 
					{
						newtiles[x][y] = tiles[y][x];
					}
				}
				for (row in newtiles) {
					row.reverse();
				}
			}
			tiles = newtiles;
		}}
       	      this.tromino.setGravity(newgravity);
	      this.downtimer = 0;
        }

	public function rem_full_lines(tiles:Array<Array<Int>>):Array<Int> {
	       var rowarray:Array<Int> = [];
	       var full:Bool = false;
	       for(index in 0...tiles.length) {
	       		 full = true;
			 for (i in tiles[index]) {
			     if (i == 0) {
			     	full = false;
		             }
			 }
			 if(full) {
			 	  rowarray.push(index);
		         }
		}
		var colarray:Array<Int> = [];
		var tracker:Array<Bool> = [for (x in 0...tiles[0].length) true];
		for (row in tiles) {
		    for (i in 0...row.length) {
		    	if (row[i] == 0) {
			   tracker[i] = false;
			}
	            }
		}
		for (i in 0...tracker.length) {
		    if (tracker[i]) { colarray.push(i);}}
		var gravitarry:Array<Int> = [];
		for (i in 0...tiles.length) {
		    for (j in 0...tiles[i].length) {
		    	if ((colarray.indexOf(j)!=-1) || (rowarray.indexOf(i)!=-1)) {
			   tiles[i][j] = 0;
			}
	 	}}
		for (i in colarray) {
		    if (i <= this.tiles.length/2) {
		       gravitarry.push(0);
		    } else { gravitarry.push(2); }}
		for (i in rowarray){
		    if (i <= this.tiles[0].length/2) {
		       gravitarry.push(3);
		    } else { gravitarry.push(1); }}
		
		this.tiles = prosthetise(tiles);
		return gravitarry;
	}
	       	       
	       
}	

