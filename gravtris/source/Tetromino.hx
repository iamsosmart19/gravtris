package;

import flixel.FlxState;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.math.FlxPoint;

class Tetromino {
	private var blocks:Array<Array<Int>>;
	private var xC:Int;
   	private var yC:Int;
	public function new(type:Int) {
		switch type {
			case 0:
				// O tetromino
				this.blocks = [ [0, 1, 1],
								[0, 1, 1],	
								[0, 0, 0]];
			case 1:
				// I tetromino
				this.blocks = [ [0, 0, 0, 0],
								[1, 1, 1, 1],
								[0, 0, 0 ,0],
								[0, 0, 0, 0]];
			case 2:
				// T tetromino
				this.blocks = [ [0, 1, 0],
								[1, 1, 1],
								[0, 0, 0]];
			case 3:
				// L tetromino
				this.blocks = [ [0, 0, 1],
								[1, 1, 1],
								[0, 0, 0]];
			case 4:
				// J tetromino
				this.blocks = [ [1, 0, 0],
								[1, 1, 1],
								[0, 0, 0]];
			case 5:
				// S tetromino
				this.blocks = [ [0, 1, 1],
								[1, 1, 0],
								[0, 0, 0]];
			case 6:
				// Z tetromino
				this.blocks = [ [1, 1, 0],
								[0, 1, 1],
								[0, 0, 0]];
			default:
				this.blocks = [for (i in 0...3) [for (i in 0...3) 0]];
		}
		xC = 8 - this.blocks.length;
		yC = 8 - this.blocks.length;
	}
	
	private function rotate() {
		//function that rotates the tetromino
	}

	private function x():Int {
		return xC;
	}
	
	private function y():Int {
		return yC;
	}
	
	private function down() {
		yC -= 1;
	}

	private function right() {
		xC += 1;
	}

	private function left() {
		xC -= 1;
	}

}
