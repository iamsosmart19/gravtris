package;

import flixel.FlxState;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.math.FlxPoint;
import flixel.math.FlxRandom;
import flixel.FlxG;

class PlayState extends FlxState {
	var tiles:Array<Array<Int>>; // stores tile values (filled, colour)
	var sprs:Array<Array<FlxSprite>>; // displays tiles to screen
	var title:FlxText; // come on bro
	var tromino:Tetromino; // tetromino used in game
	var magicnumber:Int; // for xmino x-1
	var softdrop:Bool; // bruh
	var bag:Array<Int>; // possible tetrominos
	var arrow:FlxSprite;
	var flipScreen:Bool; // screen flip option
	var lineCount:Int;
	var level:Int;
	var levelDisp:FlxText;
	var lineDisp:FlxText;
	var downinterval:Float; // time for tromino to be dropped
	var downtimer:Float; // checks time till downinterval has passed, then reset to 0
	var moveTimer:Float; // timer for mov
	var moveInterval:Float;
	var setjustDropped:Bool;
	var justDropped:Bool;
	var pauseTimer:Float; // checks time till pauseInterval has passed, then reset to 0
	var pauseInterval:Float; // time after tromino has been dropped
	var offsets:Array<Array<Array<Array<Int>>>>; //table for storing all the offset values 

	override public function create():Void {
		super.create();
		this.magicnumber = 3; // needs to be before .tiles
		this.tiles = prosthetise([for (i in 0...24) [for (j in 0...24) 0]]);
		this.bag = [0, 1, 2, 3, 4, 5, 6]; // needs to be before .tromino
		this.downinterval = 0.7;
		this.downtimer = 0.0;
		this.softdrop = false;
		this.flipScreen = true;
		this.tromino = new Tetromino(next_bag(), this.flipScreen);
		this.arrow = new FlxSprite();
		this.arrow.loadGraphic("assets/images/arrow.png");
		if (!this.flipScreen) {
			add(this.arrow);
		}
		this.lineCount = 0;
		this.level = 0;
		this.moveTimer = 0;
		this.moveInterval = 0.1;
		this.justDropped = false;
		this.setjustDropped = false;
		this.pauseInterval = 0.1;
		this.pauseTimer = 0.0;
		// sprite init
		var size:Int = 20;
		var gap:Int = 4;
		var cury:Int = gap * 5;
		var curx:Int = gap * 5;
		var stx:Int = curx;
		this.sprs = new Array<Array<FlxSprite>>();
		// 20 by 20 matrix, in case it wasnt obvious
		this.sprs = [
			for (i in 0...24) [for (j in 0...24) new FlxSprite().makeGraphic(size, size, FlxColor.WHITE)]
		];
		//offsets table: yes i know it's horrific
		//offset access: 1 is the I tromino
		//offset access access: rotation
		//offset access access access: offset n
		//offset access access access access: 0 is x, 1, is y
		this.offsets = new Array<Array<Array<Array<Int>>>>();
		this.offsets = 
			[[[[0,   0],[0,  0],[0,   0],[0,   0],[0,   0]],  // *, rot 0, offsets 0-4
			  [[0,   0],[1,  0],[1,   1],[0,  -2],[1,  -2]],  // *, rot 1, offsets 0-4
			  [[0,   0],[0,  0],[0,   0],[0,   0],[0,   0]],  // *, rot 2, offsets 0-4
			  [[0,   0],[-1, 0],[-1,  1],[0,  -2],[-1, -2]]], // *, rot 3, offsets 0-4
			 [[[0,   0],[-1, 0],[2,   0],[-1,  0],[2,   0]],  // I, rot 0, offsets 0-4
			  [[-1,  0],[0,  0],[0,   0],[0,  -1],[0,   2]],  // I, rot 1, offsets 0-4
			  [[-1, -1],[1, -1],[-2, -1],[1,   0],[-2,  0]],  // I, rot 2, offsets 0-4
			  [[0,  -1],[0  -1],[0,   1],[0,   1],[0,  -2]]]  // I, rot 3, offsets 0-4
			];
		var lastx:Int = 0;
		for (row in this.sprs) {
			for (spr in row) {
				spr.x = curx;
				spr.y = cury;
				// Increments x by the sprite size + the gap (to look sexy)
				curx += size + gap;
				// Renders sprite
				add(spr);
			}
			// Increments y by the sprite size + the gap (oooh yeah)
			cury += size + gap;
			lastx = curx;
			curx = stx;
		}

		title = new FlxText(lastx + 80, 250, 300);
		title.text = "GRAVTRIS";
		title.setFormat("assets/font.ttf", 24, FlxColor.WHITE, CENTER);
		title.setBorderStyle(OUTLINE, FlxColor.BLUE, 1);

		levelDisp = new FlxText(lastx + 80, 280, 300);
		levelDisp.text = "Level: 0";
		levelDisp.setFormat("assets/font.ttf", 24, FlxColor.WHITE, CENTER);

		lineDisp = new FlxText(lastx + 80, 310, 300);
		lineDisp.text = "Lines: 0";
		lineDisp.setFormat("assets/font.ttf", 24, FlxColor.WHITE, CENTER);

		arrow.x = lastx + 80;
		arrow.y = 310;
		add(title);
		add(levelDisp);
		add(lineDisp);
	}

	override public function update(elapsed:Float):Void {
		// update timers
		if (this.justDropped) {
			this.pauseTimer += elapsed;
		} else {
			this.downtimer += elapsed;
			this.moveTimer += elapsed;
		}
		//trace(this.pauseTimer);
		////trace(this.justDropped);
		////////trace(this.downtimer);
		if (this.pauseTimer > this.pauseInterval) {
			if(this.flipScreen) {
				rotate();
			}
			this.justDropped = false;
			this.setjustDropped = false;
			this.pauseTimer = 0.0;
		}

		trace('nope: '+justDropped);
		// trace ( this.downtimer );
		// BEGINNING OF INPUT CODE
		//trace(this.pauseTimer);
		controls(this.tromino);
		// END OF INPUT CODE
		// TODO -- REFACTOR INPUT

		// TODO: CONTROLS LINKED TO SINGLE TETROMINOS
		if (this.downtimer > this.downinterval && !this.justDropped) {
			this.tromino.down();
			if (tromino_collide_tiles(this.tromino, this.tiles)) {
				this.tromino.up();
				// haxe.Timer.delay(die.bind(), 200);
				die();
			}
			this.downtimer = 0.0;
		}

		// END OF GAMEPLAY CODE
		if (!this.justDropped) {
			// BEGINNING OF DISPLAY CODE
			var realones:Array<Array<Int>> = tromino_plus_tiles(this.tromino, this.tiles);
			//////trace(realones);
			var tileIter:Iterator<Array<Int>> = realones.iterator();
			var sprsIter:Iterator<Array<FlxSprite>> = this.sprs.iterator();
			while (tileIter.hasNext() && sprsIter.hasNext()) {
				var tileRow:Array<Int> = tileIter.next();
				var sprsRow:Array<FlxSprite> = sprsIter.next();
				var trowItr:Iterator<Int> = tileRow.iterator();
				var srowItr:Iterator<FlxSprite> = sprsRow.iterator();
				while (trowItr.hasNext() && srowItr.hasNext()) {
					var tile:Int = trowItr.next();
					var spr:FlxSprite = srowItr.next();
					switch (tile) {
						case 0:
							spr.color = FlxColor.GRAY;
						case 1:
							spr.color = FlxColor.WHITE;
						case 2:
							spr.color = FlxColor.CYAN;
						case 3:
							spr.color = FlxColor.BLUE;
						case 4:
							spr.color = FlxColor.ORANGE;
						case 5:
							spr.color = FlxColor.YELLOW;
						case 6:
							spr.color = FlxColor.GREEN;
						case 7:
							spr.color = FlxColor.PURPLE;
						case 8:
							spr.color = FlxColor.RED;
					}
				}
			}

			switch (this.tromino.grav()) {
				case 0:
					this.arrow.angle = 0;
				case 1:
					this.arrow.angle = 270;
				case 2:
					this.arrow.angle = 180;
				case 3:
					this.arrow.angle = 90;
			}
		}
		if(this.setjustDropped) {
			this.justDropped = true;
		}

		super.update(elapsed);
	}

	public function offset_matrix(matrix:Array<Array<Int>>, x:Int, y:Int, xSize:Int, ySize:Int):Array<Array<Int>> {
		var returnmatrix:Array<Array<Int>>;
		returnmatrix = [for (i in 0...ySize) [for (j in 0...xSize) 0]];
		for (yC in 0...matrix.length) {
			for (xC in 0...matrix[yC].length) {
				returnmatrix[yC + y][xC + x] = matrix[yC][xC];
			}
		}
		return returnmatrix;
	}

	// if m1 and m2 arent the same size when you call this you WILL die
	public function overlay_matrices(m1:Array<Array<Int>>, m2:Array<Array<Int>>):Array<Array<Int>> {
		var returnmatrix:Array<Array<Int>>;
		returnmatrix = [for (i in 0...m1.length) [for (j in 0...m1[0].length) 0]];
		for (yC in 0...returnmatrix.length) {
			for (xC in 0...returnmatrix[0].length) {
				returnmatrix[yC][xC] = m1[yC][xC] | m2[yC][xC]; // fck it. bitwise or
			}
		}
		return returnmatrix;
	}

	public function tromino_plus_tiles(tromino:Tetromino, tiles:Array<Array<Int>>):Array<Array<Int>> {
		////////trace( offset_matrix(tromino.blocks(), tromino.x(), tromino.y(), tiles[0].length, tiles.length));
		return deprosthetise(overlay_matrices(tiles,
			offset_matrix(tromino.blocks(), tromino.x() + this.magicnumber, tromino.y() + this.magicnumber, tiles[0].length, tiles.length)));
	}

	public function prosthetise(tiles:Array<Array<Int>>):Array<Array<Int>> {
		var newtiles:Array<Array<Int>>;
		newtiles = [
			for (i in 0...(tiles.length + (this.magicnumber * 2))) [for (j in 0...(tiles[0].length + (this.magicnumber * 2))) -1]
		];
		for (yC in 0...tiles.length) {
			for (xC in 0...tiles[yC].length) {
				newtiles[yC + this.magicnumber][xC + this.magicnumber] = tiles[yC][xC];
			}
		}
		return newtiles;
	}

	public function deprosthetise(tiles:Array<Array<Int>>):Array<Array<Int>> {
		var newtiles:Array<Array<Int>>;
		newtiles = [
			for (i in 0...(tiles.length - (this.magicnumber * 2))) [for (j in 0...(tiles[0].length - (this.magicnumber * 2))) 0]
		];
		for (yC in 0...tiles.length) {
			for (xC in 0...tiles[yC].length) {
				if (((yC + this.magicnumber * 2) < (tiles.length)) && ((xC + this.magicnumber * 2) < (tiles[yC].length))) {
					newtiles[yC][xC] = tiles[yC + this.magicnumber][xC + this.magicnumber];
				}
			}
		}
		return newtiles;
	}

	public function matrices_collidep(m1:Array<Array<Int>>, m2:Array<Array<Int>>):Bool {
		var m1Iter:Iterator<Array<Int>> = m1.iterator();
		var m2Iter:Iterator<Array<Int>> = m2.iterator();
		while (m1Iter.hasNext() && m2Iter.hasNext()) {
			var m1Row:Array<Int> = m1Iter.next();
			var m2Row:Array<Int> = m2Iter.next();
			var r1Itr:Iterator<Int> = m1Row.iterator();
			var r2Itr:Iterator<Int> = m2Row.iterator();
			while (r1Itr.hasNext() && r2Itr.hasNext()) {
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
		return matrices_collidep(tiles,
			offset_matrix(tromino.blocks(), tromino.x() + this.magicnumber, tromino.y() + this.magicnumber, tiles[0].length, tiles.length));
	}

	public function next_bag():Int {
		if (this.bag.length == 0) {
			this.bag = [0, 1, 2, 3, 4, 5, 6];
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
						relLeftPressed = FlxG.keys.pressed.LEFT;
						relRightPressed = FlxG.keys.pressed.RIGHT;
					};
				case 1:
					{
						relDownPressed = FlxG.keys.justPressed.RIGHT;
						relDownReleased = FlxG.keys.justReleased.RIGHT;
						relUpPressed = FlxG.keys.justPressed.LEFT;
						relLeftPressed = FlxG.keys.pressed.UP;
						relRightPressed = FlxG.keys.pressed.DOWN;
					};
				case 2:
					{
						relDownPressed = FlxG.keys.justPressed.UP;
						relDownReleased = FlxG.keys.justReleased.UP;
						relUpPressed = FlxG.keys.justPressed.DOWN;
						relLeftPressed = FlxG.keys.pressed.RIGHT;
						relRightPressed = FlxG.keys.pressed.LEFT;
					};
				case 3:
					{
						relDownPressed = FlxG.keys.justPressed.LEFT;
						relDownReleased = FlxG.keys.justReleased.LEFT;
						relUpPressed = FlxG.keys.justPressed.RIGHT;
						relLeftPressed = FlxG.keys.pressed.DOWN;
						relRightPressed = FlxG.keys.pressed.UP;
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
				if (this.moveTimer > this.moveInterval) {
					this.moveTimer = 0;
					this.tromino.left();
					if (tromino_collide_tiles(this.tromino, this.tiles)) {
						this.tromino.right();
					}
				}
			}

			if (relRightPressed) {
				if (this.moveTimer > this.moveInterval) {
					this.moveTimer = 0;
					this.tromino.right();
					if (tromino_collide_tiles(this.tromino, this.tiles)) {
						this.tromino.left();
					}
				}
			}

			if (FlxG.keys.justPressed.X || relUpPressed) {
				var rotLoopCount:Int = 0;
				var prevrot:Int = this.tromino.rotation();
				trace("rot: "+this.tromino.rotation());
				this.tromino.rotateCW();
				var x = this.tromino.x();
				var y = this.tromino.y();
				trace("rot: "+this.tromino.rotation());
				trace("x: "+x);
				trace("y: "+y);
				while (tromino_collide_tiles(this.tromino, this.tiles) && rotLoopCount < 5) {
					if(this.tromino.type() == 0) {
						rotLoopCount = 5;
					}
					else if(this.tromino.type() > 1) {
						this.tromino.setX(this.tromino.x() + (offsets[0][prevrot][rotLoopCount][0]
															 - offsets[0][this.tromino.rotation()][rotLoopCount][0]));
						this.tromino.setY(this.tromino.y() + (offsets[0][prevrot][rotLoopCount][1]
															 - offsets[0][this.tromino.rotation()][rotLoopCount][1]));
					}
					else {
						this.tromino.setX(this.tromino.x() + (offsets[0][prevrot][rotLoopCount][0]
															 - offsets[0][this.tromino.rotation()][rotLoopCount][0]));
						this.tromino.setY(this.tromino.y() + (offsets[0][prevrot][rotLoopCount][1]
															 - offsets[0][this.tromino.rotation()][rotLoopCount][1]));
					}
					trace("new_x: "+this.tromino.x());
					trace("new_y: "+this.tromino.y());
					rotLoopCount++;
				}
				if(rotLoopCount == 5) {
					this.tromino.rotateCCW();
					this.tromino.setX(x);
					this.tromino.setY(y);
				}
			}

			if (FlxG.keys.justPressed.Z) {
				var rotLoopCount:Int = 0;
				var prevrot:Int = this.tromino.rotation();
				trace("rot: "+this.tromino.rotation());
				this.tromino.rotateCCW();
				var x = this.tromino.x();
				var y = this.tromino.y();
				trace("rot: "+this.tromino.rotation());
				trace("x: "+x);
				trace("y: "+y);
				while (tromino_collide_tiles(this.tromino, this.tiles) && rotLoopCount < 5) {
					if(this.tromino.type() == 0) {
						rotLoopCount = 5;
					}
					else if(this.tromino.type() > 1) {
						this.tromino.setX(this.tromino.x() + (offsets[0][prevrot][rotLoopCount][0]
															 - offsets[0][this.tromino.rotation()][rotLoopCount][0]));
						this.tromino.setY(this.tromino.y() + (offsets[0][prevrot][rotLoopCount][1]
															 - offsets[0][this.tromino.rotation()][rotLoopCount][1]));
					}
					else {
						this.tromino.setX(this.tromino.x() + (offsets[0][prevrot][rotLoopCount][0]
															 - offsets[0][this.tromino.rotation()][rotLoopCount][0]));
						this.tromino.setY(this.tromino.y() + (offsets[0][prevrot][rotLoopCount][1]
															 - offsets[0][this.tromino.rotation()][rotLoopCount][1]));
					}
					trace("new_x: "+this.tromino.x());
					trace("new_y: "+this.tromino.y());
					rotLoopCount++;
				}
				if(rotLoopCount == 5) {
					this.tromino.rotateCW();
					this.tromino.setX(x);
					this.tromino.setY(y);
				}
			}
			if (FlxG.keys.justPressed.SPACE) {
				while (!tromino_collide_tiles(this.tromino, this.tiles)) {
					this.tromino.down();
				}
				this.tromino.up();
				die();
				// haxe.Timer.delay(die.bind(), 200);
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

			if (FlxG.keys.pressed.LEFT) {
				if (this.moveTimer > this.moveInterval) {
					this.moveTimer = 0;
					this.tromino.left();
					if (tromino_collide_tiles(this.tromino, this.tiles)) {
						this.tromino.right();
					}
				}
			}

			if (FlxG.keys.pressed.RIGHT) {
				if (this.moveTimer > this.moveInterval) {
					this.moveTimer = 0;
					this.tromino.right();
					if (tromino_collide_tiles(this.tromino, this.tiles)) {
						this.tromino.left();
					}
				}
			}

			if (FlxG.keys.anyJustPressed([UP, X])) {
				var rotLoopCount:Int = 0;
				var prevrot:Int = this.tromino.rotation();
				trace("rot: "+this.tromino.rotation());
				this.tromino.rotateCW();
				var x = this.tromino.x();
				var y = this.tromino.y();
				trace("rot: "+this.tromino.rotation());
				trace("x: "+x);
				trace("y: "+y);
				while (tromino_collide_tiles(this.tromino, this.tiles) && rotLoopCount < 5) {
					if(this.tromino.type() == 0) {
						rotLoopCount = 5;
					}
					else if(this.tromino.type() > 1) {
						this.tromino.setX(this.tromino.x() + (offsets[0][prevrot][rotLoopCount][0]
															 - offsets[0][this.tromino.rotation()][rotLoopCount][0]));
						this.tromino.setY(this.tromino.y() + (offsets[0][prevrot][rotLoopCount][1]
															 - offsets[0][this.tromino.rotation()][rotLoopCount][1]));
					}
					else {
						this.tromino.setX(this.tromino.x() + (offsets[0][prevrot][rotLoopCount][0]
															 - offsets[0][this.tromino.rotation()][rotLoopCount][0]));
						this.tromino.setY(this.tromino.y() + (offsets[0][prevrot][rotLoopCount][1]
															 - offsets[0][this.tromino.rotation()][rotLoopCount][1]));
					}
					trace("new_x: "+this.tromino.x());
					trace("new_y: "+this.tromino.y());
					rotLoopCount++;
				}
				if(rotLoopCount == 5) {
					this.tromino.rotateCCW();
					this.tromino.setX(x);
					this.tromino.setY(y);
				}
			}

			if (FlxG.keys.justPressed.Z) {
				var rotLoopCount:Int = 0;
				var prevrot:Int = this.tromino.rotation();
				trace("rot: "+this.tromino.rotation());
				this.tromino.rotateCCW();
				var x = this.tromino.x();
				var y = this.tromino.y();
				trace("rot: "+this.tromino.rotation());
				trace("x: "+x);
				trace("y: "+y);
				while (tromino_collide_tiles(this.tromino, this.tiles) && rotLoopCount < 5) {
					if(this.tromino.type() == 0) {
						rotLoopCount = 5;
					}
					else if(this.tromino.type() > 1) {
						this.tromino.setX(this.tromino.x() + (offsets[0][prevrot][rotLoopCount][0]
															 - offsets[0][this.tromino.rotation()][rotLoopCount][0]));
						this.tromino.setY(this.tromino.y() + (offsets[0][prevrot][rotLoopCount][1]
															 - offsets[0][this.tromino.rotation()][rotLoopCount][1]));
					}
					else {
						this.tromino.setX(this.tromino.x() + (offsets[0][prevrot][rotLoopCount][0]
															 - offsets[0][this.tromino.rotation()][rotLoopCount][0]));
						this.tromino.setY(this.tromino.y() + (offsets[0][prevrot][rotLoopCount][1]
															 - offsets[0][this.tromino.rotation()][rotLoopCount][1]));
					}
					trace("new_x: "+this.tromino.x());
					trace("new_y: "+this.tromino.y());
					rotLoopCount++;
				}
				if(rotLoopCount == 5) {
					this.tromino.rotateCW();
					this.tromino.setX(x);
					this.tromino.setY(y);
				}
			}
			if (FlxG.keys.justPressed.SPACE) {
				while (!tromino_collide_tiles(this.tromino, this.tiles)) {
					this.tromino.down();
				}
				this.tromino.up();
				die();
				// haxe.Timer.delay(die.bind(), 200);
			}
		}
	}

	public function die():Void {
		if (this.softdrop) {
			this.downinterval *= 8;
			this.softdrop = false;
		}
		this.tiles = prosthetise(tromino_plus_tiles(this.tromino, this.tiles));
		newtromino();
		this.downtimer = 0;
		this.setjustDropped = true;
		// Sys.sleep(0.1);
	}

	// need to define recreate gravity in this as well
	public function newtromino():Void {
		this.tromino = new Tetromino(next_bag(), this.flipScreen);
		if (tromino_collide_tiles(this.tromino, this.tiles)) {
			gameover();
		}
		var prevlines:Int = this.lineCount;
		spaceFill(rem_full_lines(deprosthetise(this.tiles)));
		this.lineDisp.text = "Lines: " + Std.string(this.lineCount);
		if (Std.int(this.lineCount / 10) > Std.int(prevlines / 10)) {
			this.level += 1;
			this.downinterval /= 1.2;
			this.levelDisp.text = "Level: " + Std.string(this.level);
		}
		if (!this.flipScreen) {
			var newgravity:Int = FlxG.random.int(0, 3);
			this.tromino.setGravity(newgravity);
		}
	}

	public function rotate():Void {
		var newgravity:Int = FlxG.random.int(0, 3);
		if (this.flipScreen) {
			var gravity:Int = this.tromino.grav();
			var newtiles:Array<Array<Int>> = [for (i in 0...tiles.length) [for (j in 0...tiles.length) 0]];
			if (newgravity == gravity) {} else if (newgravity - gravity < 0) {
				for (i in 0...(4 - (newgravity - gravity))) {
					for (y in 0...tiles.length) {
						for (x in 0...tiles.length) {
							newtiles[x][y] = tiles[y][x];
						}
					}
					for (row in newtiles) {
						row.reverse();
					}
				}
				tiles = newtiles;
			} else {
				for (i in 0...(newgravity - gravity)) {
					for (y in 0...tiles.length) {
						for (x in 0...tiles.length) {
							newtiles[x][y] = tiles[y][x];
						}
					}
					for (row in newtiles) {
						row.reverse();
					}
				}
				tiles = newtiles;
			}
		}
		this.tromino.setGravity(newgravity);
		//trace(this.tromino.grav());
	}

	public function rem_full_lines(tiles:Array<Array<Int>>):Array<Int> {
		var rowarray:Array<Int> = filled_rows(tiles, false);
		var colarray:Array<Int> = filled_columns(tiles, false);
		var gravitarry:Array<Int> = [];
		for (i in 0...tiles.length) {
			for (j in 0...tiles[i].length) {
				if ((colarray.indexOf(j) != -1) || (rowarray.indexOf(i) != -1)) {
					tiles[i][j] = 0;
				}
			}
		}
		for (i in colarray) {
			lineCount += 1;
			if (i <= this.tiles.length / 2) {
				gravitarry.push(3);
			} else {
				gravitarry.push(1);
			}
		}
		for (i in rowarray) {
			lineCount += 1;
			if (i <= this.tiles[0].length / 2) {
				gravitarry.push(2);
			} else {
				gravitarry.push(0);
			}
		}
		// //trace(gravitarry);
		// //trace(rowarray);
		// //trace(colarray);
		this.tiles = prosthetise(tiles);
		return gravitarry;
	}

	public function filled_rows(matrix:Array<Array<Int>>, empty:Bool):Array<Int> {
		var rowarray:Array<Int> = [];
		var full:Bool = false;
		for (index in 0...matrix.length) {
			full = true;
			for (i in matrix[index]) {
				if (empty ? i != 0 : i == 0) {
					full = false;
				}
			}
			if (full) {
				rowarray.push(index);
			}
		}
		return rowarray;
	}

	public function filled_columns(tiles:Array<Array<Int>>, empty:Bool):Array<Int> {
		var colarray:Array<Int> = [];
		var tracker:Array<Bool> = [for (x in 0...tiles[0].length) true];
		for (row in tiles) {
			for (i in 0...row.length) {
				if (empty ? row[i] != 0 : row[i] == 0) {
					tracker[i] = false;
				}
			}
		}
		for (i in 0...tracker.length) {
			if (tracker[i]) {
				colarray.push(i);
			}
		}
		return colarray;
	}

	public function spaceFill(gravarray:Array<Int>) {
		// //trace(gravarray);
		var dptiles:Array<Array<Int>> = deprosthetise(this.tiles);
		var splittiles:Array<Array<Int>>;
		for (gravdirection in gravarray) {
			switch (gravdirection) {
				case 0:
					splittiles = [
						for (y in Std.int(dptiles.length / 2)...dptiles.length) [for (x in 0...dptiles[0].length) dptiles[y][x]]
					];
					for (i in filled_rows(splittiles, true)) {
						splittiles.splice(i, 1);
						splittiles.unshift([for (x in 0...dptiles[0].length) 0]);
					}
					dptiles = [
						for (y in 0...Std.int(dptiles.length / 2)) [for (x in 0...dptiles[0].length) dptiles[y][x]]
					].concat(splittiles);
				case 1:
					splittiles = [
						for (y in 0...dptiles.length) [for (x in Std.int(dptiles[0].length / 2)...dptiles[0].length) dptiles[y][x]]
					];
					for (i in filled_columns(splittiles, true)) {
						for (row in splittiles) {
							row.splice(i, 1);
							row.unshift(0);
						}
					}
					for (i in 0...splittiles.length) {
						for (j in 0...splittiles[0].length) {
							dptiles[i][Std.int(dptiles[0].length / 2) + j] = splittiles[i][j];
						}
					}
				case 2:
					splittiles = [
						for (y in 0...Std.int(dptiles.length / 2)) [for (x in 0...dptiles[0].length) dptiles[y][x]]
					];
					for (i in filled_rows(splittiles, true)) {
						splittiles.splice(i, 1);
						splittiles.push([for (x in 0...dptiles.length) 0]);
					}
					dptiles = splittiles.concat([
						for (y in Std.int(dptiles.length / 2)...dptiles.length) [for (x in 0...dptiles.length) dptiles[y][x]]
					]);
				case 3:
					splittiles = [
						for (y in 0...dptiles.length) [for (x in 0...Std.int(dptiles[0].length / 2)) dptiles[y][x]]
					];
					for (i in filled_columns(splittiles, true)) {
						for (row in splittiles) {
							row.splice(i, 1);
							row.push(0);
						}
					}
					for (i in 0...splittiles.length) {
						for (j in 0...splittiles[0].length) {
							dptiles[i][j] = splittiles[i][j];
						}
					}
			}
		}
		this.tiles = prosthetise(dptiles);
	}

	public function gameover() {
		trace("You Lose!");
	}
}
