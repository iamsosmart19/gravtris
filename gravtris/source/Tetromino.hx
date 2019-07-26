package;

import flixel.FlxState;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.math.FlxPoint;

class Tetromino {
	private var blks:Array<Array<Int>>;
	private var xC:Int;
	private var yC:Int;
	private var gravity:Int;
	private var flip:Bool;
	private var hiddenGrav:Int;

	public function new(type:Int, flipScreen:Bool) {
		switch type {
			case 0:
				// O tetromino
				this.blks = [[5, 5], [5, 5]];
			case 1:
				// I tetromino
				this.blks = [[0, 0, 0, 0, 0], [0, 0, 0, 0, 0], [0, 2, 2, 2, 2], [0, 0, 0, 0, 0], [0, 0, 0, 0, 0]];
			case 2:
				// T tetromino
				this.blks = [[0, 7, 0], [7, 7, 7], [0, 0, 0]];
			case 3:
				// L tetromino
				this.blks = [[0, 0, 4], [4, 4, 4], [0, 0, 0]];
			case 4:
				// J tetromino
				this.blks = [[3, 0, 0], [3, 3, 3], [0, 0, 0]];
			case 5:
				// S tetromino
				this.blks = [[0, 6, 6], [6, 6, 0], [0, 0, 0]];
			case 6:
				// Z tetromino
				this.blks = [[8, 8, 0], [0, 8, 8], [0, 0, 0]];
			default:
				this.blks = [for (i in 0...3) [for (i in 0...3) 0]];
		}
		this.xC = 10;
		this.yC = 10;
		this.gravity = 0;
		this.hiddenGrav = 0;
		this.flip = flipScreen;
	}

	public function blocks():Array<Array<Int>> {
		return this.blks;
	}

	public function grav():Int {
		if (!flip) {
			return this.gravity;
		} else {
			return this.hiddenGrav;
		}
	}

	public function setGravity(grav:Int) {
		if (!flip) {
			this.gravity = grav;
		} else {
			this.hiddenGrav = grav;
		}
	}

	public function rotateCW() {
		// function that rotates the tetromino clockwise
		var newblks:Array<Array<Int>> = [for (i in 0...blks.length) [for (j in 0...blks.length) 0]];
		for (y in 0...blks.length) {
			for (x in 0...blks.length) {
				newblks[x][y] = blks[y][x];
			}
		}
		for (row in newblks) {
			row.reverse();
		}
		blks = newblks;
	}

	public function rotateCCW() {
		// function that rotates the tetromino counter-clockwise
		var newblks:Array<Array<Int>> = [for (i in 0...blks.length) [for (j in 0...blks.length) 0]];
		for (row in blks) {
			row.reverse();
		}
		for (y in 0...blks.length) {
			for (x in 0...blks[0].length) {
				newblks[x][y] = blks[y][x];
			}
		}
		blks = newblks;
	}

	public function x():Int {
		return this.xC;
	}

	public function y():Int {
		return this.yC;
	}

	public function setX(x:Int) {
		this.xC = x;
	}

	public function setY(y:Int) {
		this.yC = y;
	}

	public function up() {
		switch this.gravity {
			case 0:
				this.yC -= 1;
			case 1:
				this.xC -= 1;
			case 2:
				this.yC += 1;
			case 3:
				this.xC += 1;
		}
	}

	public function down() {
		switch this.gravity {
			case 0:
				this.yC += 1;
			case 1:
				this.xC += 1;
			case 2:
				this.yC -= 1;
			case 3:
				this.xC -= 1;
		}
	}

	public function right() {
		switch this.gravity {
			case 0:
				this.xC += 1;
			case 1:
				this.yC += 1;
			case 2:
				this.xC -= 1;
			case 3:
				this.yC -= 1;
		}
	}

	public function left() {
		switch this.gravity {
			case 0:
				this.xC -= 1;
			case 1:
				this.yC -= 1;
			case 2:
				this.xC += 1;
			case 3:
				this.yC += 1;
		}
	}
}
