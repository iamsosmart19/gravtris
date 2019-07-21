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
	public function new(type:Int) {
		switch type {
			case 0:
				// O tetromino
				this.blks = [ [1, 1],
								[1, 1]];
			case 1:
				// I tetromino
				this.blks = [	[0, 0, 0, 0],
								[1, 1, 1, 1],
								[0, 0, 0 ,0],
								[0, 0, 0, 0]];
			case 2:
				// T tetromino
				this.blks = [	[0, 1, 0],
								[1, 1, 1],
								[0, 0, 0]];
			case 3:
				// L tetromino
				this.blks = [	[0, 0, 1],
								[1, 1, 1],
								[0, 0, 0]];
			case 4:
				// J tetromino
				this.blks = [	[1, 0, 0],
								[1, 1, 1],
								[0, 0, 0]];
			case 5:
				// S tetromino
				this.blks = [	[0, 1, 1],
								[1, 1, 0],
								[0, 0, 0]];
			case 6:
				// Z tetromino
				this.blks = [	[1, 1, 0],
								[0, 1, 1],
								[0, 0, 0]];
			default:
				this.blks = [for (i in 0...3) [for (i in 0...3) 0]];
		}
		this.xC = 7;
		this.yC = 6;
	}

	public function blocks():Array<Array<Int>> {
		return this.blks;
	}
	
	public function rotate() {
		//function that rotates the tetromino
		var newblks:Array<Array<Int>> = [for(i in 0...blks.length) [for(j in 0...blks.length) 0]];
		for (y in 0...blks.length) 
		{
			for(x in 0...blks[0].length) 
			{
				newblks[y][x] = blks[y][x];
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
	       this.yC += 1;
	}
	
	public function down() {
	       this.yC -= 1;
	}

	public function right() {
	       this.xC += 1;
	}

	public function left() {
	       this.xC -= 1;
	}

}
