package  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	// numItemsText dateCreatedText
	
	public class MoveBoxScreen extends MovieClip {
		
		public var appDisplay: AppDisplay;
		public var box:Box;
		
		public function MoveBoxScreen(_appDisplay: AppDisplay): void {
			// constructor code
			
			appDisplay = _appDisplay;
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		public function onAddedToStage(e:Event) : void {
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			addEventListener(MouseEvent.CLICK, onClick);
		}
		
		public function onRemovedFromStage(e:Event) : void {
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			removeEventListener(MouseEvent.CLICK, onClick);
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		public function setup(boxToMove:Box) {
			box = boxToMove;
			boxText.text = box.name;
			moveText.text = box.location;
		}
		
		public function onClick(mE:MouseEvent) {
			trace("\nCLICK!");
			trace(mE.target);
			trace(mE);
			
			mE.stopPropagation();
			
			var target = mE.target;
			
			if (target is AcceptButton) {
				trace("MOVE BOX TO " + moveText.text);
				// --> MOVE BOX
				appDisplay.appData.moveBox(box, moveText.text);
				appDisplay.moveBoxScreenToBoxInfoScreen(box);
			
				

			} else if (target is ExitButton) {
				appDisplay.moveBoxScreenToBoxInfoScreen(box);
			}
			
		}
		
		public function reset():void {
			box = null;
			moveText.text = "";
			boxText.text = "";
		}
	}
	
}
