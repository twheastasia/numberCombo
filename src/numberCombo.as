package
{
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.ui.Keyboard;
	
	[SWF(frameRate="24", width="480", height="800", backgroundColor="0xFFFFFF")]
	public class numberCombo extends Sprite
	{
		private static const DISTANCE_BETWEEN_CELLS:int = 110;
		private static const MAX_WIDTH:int = 4;
		private static const MAX_HEIGHT:int = 4;
		
		private var currentScoresBoard:MovieClip;
		private var bestScoresBoard:MovieClip;
		private var options:MovieClip;
		private var cellBg:MovieClip;
		private var cellsArray:Array = [];
		
		private var loader:Loader;
		private var mainSwf:MovieClip;
		private var positions:Array = [];
		private var currentCellsPos:Array = [];		
		
		public function numberCombo()
		{
		    loader = new Loader();
			var urlRequest:URLRequest = new URLRequest("../resources/2048_cs6.swf");
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onloadCompleted);
			loader.load(urlRequest);
		}
		
		private function onloadCompleted(event:Event):void
		{
			mainSwf = event.target.content as MovieClip;
			currentScoresBoard = mainSwf.getChildByName("currentScoresBoard") as MovieClip;
			bestScoresBoard = mainSwf.getChildByName("bestScoresBoard") as MovieClip;
			options = mainSwf.getChildByName("options") as MovieClip;
			cellBg = mainSwf.getChildByName("cellBg") as MovieClip;
			positions = initPositions();
			this.addChild(mainSwf);
			
			currentScoresBoard["currentScores"].text = "0";
			bestScoresBoard["bestScores"].text = "0";
			
			randomOneCell(2);
			
			options.addEventListener(MouseEvent.CLICK, onOptionsClicked);
			stage.addEventListener(KeyboardEvent.KEY_DOWN,onKeyboardEvent); 
		}
		
		private function onKeyboardEvent(event:KeyboardEvent):void
		{
			switch(event.keyCode){ 
				case Keyboard.UP: 
					moveUpCell();
					break; 
				case Keyboard.DOWN: 
					moveDownCell(); 
					break; 
				case Keyboard.LEFT: 
					moveLeftCell();
					break; 
				case Keyboard.RIGHT: 
					moveRightCell(); 
					break; 
				default: 
					break; 
			} 
			randomOneCell(2);
		}
				
		private function moveUpCell():void
		{
			var i:int;
			var j:int;
			for(i = 0; i < MAX_HEIGHT -1; i++){
				for(j = 0; j < MAX_WIDTH; j++){
					if(currentCellsPos[i][j] < currentCellsPos[i+1][j]){
						logSquare(currentCellsPos);
						currentCellsPos[i][j] = 1;
						currentCellsPos[i+1][j] = 0;
						moveSingleCell(cellsArray[i+1][j], i, j);
						logSquare(currentCellsPos);
					}
				}
			}
		}
		
		private function moveDownCell():void
		{
			var i:int;
			var j:int;
			for(i = MAX_HEIGHT-1; i > 0; i--){
				for(j = 0; j < MAX_WIDTH; j++){
					if(currentCellsPos[i][j] < currentCellsPos[i-1][j]){
						logSquare(currentCellsPos);
						currentCellsPos[i][j] = 1;
						currentCellsPos[i-1][j] = 0;
						moveSingleCell(cellsArray[i-1][j], i, j);
						logSquare(currentCellsPos);
					}
				}
			}
		}
		
		private function moveLeftCell():void
		{
			var i:int;
			var j:int;
			for(i = 0; i < MAX_HEIGHT; i++){
				for(j = 0; j < MAX_WIDTH - 1; j++){
					if(currentCellsPos[i][j] < currentCellsPos[i][j+1]){
						logSquare(currentCellsPos);
						currentCellsPos[i][j] = 1;
						currentCellsPos[i][j+1] = 0;
						moveSingleCell(cellsArray[i][j+1], i, j);
						logSquare(currentCellsPos);
					}
				}
			}
		}
		
		private function moveRightCell():void
		{
			var i:int;
			var j:int;
			for(i = 0; i < MAX_HEIGHT; i++){
				for(j = MAX_WIDTH; j > 0; j--){
					if(currentCellsPos[i][j] < currentCellsPos[i][j-1]){
						logSquare(currentCellsPos);
						currentCellsPos[i][j] = 1;
						currentCellsPos[i][j-1] = 0;
						moveSingleCell(cellsArray[i][j-1], i, j);
						logSquare(currentCellsPos);
					}
				}
			}
		}
		
		private function moveSingleCell(cell:MovieClip, afterMove_x:int ,afterMove_y:int):void
		{
			cell.x = positions[afterMove_x][afterMove_y][0];
			cell.y = positions[afterMove_x][afterMove_y][1];
			var temp:MovieClip = new MovieClip;
			temp = cellsArray[afterMove_x][afterMove_y];
			cellsArray[afterMove_x][afterMove_y] = cell;
			cell = temp;
		}
		
		private function combineTwoCells(first_cell_i:int,first_cell_j:int, second_cell_i:int, second_cell_j:int):void
		{
			cellsArray[first_cell_i][first_cell_j]["cellNumber"].text = int(cellsArray[second_cell_i][second_cell_j]["cellNumber"].text)*2;
			
		}
		
		/*
		public function getClassInstance(classPath:String):MovieClip
		{
			var classRef:Class = getDefinitionByName(classPath) as Class;
			var classInstance:MovieClip  = new classRef();
			return classInstance;
		}
		*/
		
		private function getCell(numbers:int):MovieClip{
			var classRef:Class =  loader.contentLoaderInfo.applicationDomain.getDefinition("cell") as Class;
			var classInstance:MovieClip  = new classRef();
			classInstance["cellNumber"].text = numbers;
			return classInstance;
		}
		
		private function initPositions():Array
		{
			var i:int;
			var j:int;
			var pos:Array = [];
			for ( i = 0; i < MAX_HEIGHT; i++){
				for ( j = 0; j < MAX_WIDTH; j++){
					if(pos[i] == null){
						pos[i] = [];
					}
					if(currentCellsPos[i] == null){
						currentCellsPos[i] = [];
					}
					if(cellsArray[i] == null){
						cellsArray[i] = [];
					}
					pos[i][j] = [j*DISTANCE_BETWEEN_CELLS, i*DISTANCE_BETWEEN_CELLS];
					currentCellsPos[i][j] = 0;
					cellsArray[i][j] = new MovieClip;
				}
			}
			return pos;
		}
		
		private function randomOneCell(numbers:int=2):void
		{
			var cell:MovieClip = new MovieClip;
			cell = getCell(numbers);
			var posX:int = Math.random()*MAX_WIDTH;
			var posY:int = Math.random()*MAX_HEIGHT;
			if(isGameOver(currentCellsPos)){
				trace("Game Over!");
				return;
			}
			if(currentCellsPos && currentCellsPos[posX][posY] == 0){
				cell.x = positions[posX][posY][0];
				cell.y = positions[posX][posY][1];
				currentCellsPos[posX][posY] = 1;
				cellsArray[posX][posY] = cell;
				cellBg.addChild(cell);
			}else{
				randomOneCell(numbers);
			}
		}
		
		private function isGameOver(array:Array):Boolean
		{
			var i:int;
			var j:int;
			for(i=0;i<MAX_HEIGHT;i++){
				for(j=0;j<MAX_WIDTH;j++){
					if(array[i][j] == 0){
						return false;
					}
				}
			}
			return true;
		}
		
		private function onOptionsClicked(event:MouseEvent):void
		{
			//randomOneCell(cellsArray[0]);
		}
		
		private function onRemove():void
		{
			loader.removeEventListener(Event.COMPLETE, onloadCompleted);
			loader = null;
		}
		
		private function logSquare(array:Array):void
		{
			var i:int;
			var j:int;
			var row:String = "";
			for(i=0;i<MAX_HEIGHT;i++){
				for(j=0;j<MAX_WIDTH;j++){
					row += array[i][j] + " ";
				}
				row += "\n";
			}
			trace(row)
		}
	}
}