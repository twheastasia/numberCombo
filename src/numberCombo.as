package
{
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
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
		
		public function numberCombo()
		{
		    loader = new Loader();
			var urlRequest:URLRequest = new URLRequest("../resources/2048.swf");
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
			
			cellsArray[0] = getCell(4);
			randomOneCell(cellsArray[0]);
			cellBg.addChild(cellsArray[0]);
			options.addEventListener(MouseEvent.CLICK, onOptionsClicked);
			this.addEventListener(Event.ENTER_FRAME, onKeyClicked);
		}
		
		private function onKeyClicked(event:Event):void
		{
			
		}
		
		
		/*
		public function getClassInstance(classPath:String):MovieClip
		{
			var classRef:Class = getDefinitionByName(classPath) as Class;
			var classInstance:MovieClip  = new classRef();
			return classInstance;
		}
		*/
		
		private function getCell(numbers:int = 2):MovieClip{
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
					pos[i][j] = [i*DISTANCE_BETWEEN_CELLS, j*DISTANCE_BETWEEN_CELLS];
				}
			}
			return pos;
		}
		
		private function randomOneCell(cell:MovieClip):void
		{
			var posX:int = Math.random()*MAX_WIDTH;
			var posY:int = Math.random()*MAX_HEIGHT;
			cell.x = positions[posX][posY][0];
			cell.y = positions[posX][posY][1];
		}
		
		private function onOptionsClicked(event:MouseEvent):void
		{
			randomOneCell(cellsArray[0]);
		}
		
		private function onRemove():void
		{
			loader.removeEventListener(Event.COMPLETE, onloadCompleted);
			loader = null;
		}
	}
}