package  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	// numItemsText dateCreatedText
	
	public class MoveItemScreen extends MovieClip {
		
		public var appDisplay: AppDisplay;
		public var item:Item;
		
		public function MoveItemScreen(_appDisplay: AppDisplay): void {
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
		
		public function setup(itemToMove:Item) {
			item = itemToMove;
			itemText.text = item.name;
			moveText.text = item.box.name;
		}
		
		public function onClick(mE:MouseEvent) {
			trace("\nCLICK!");
			trace(mE.target);
			trace(mE);
			
			mE.stopPropagation();
			
			var target = mE.target;
			
			if (target is AcceptButton) {
				trace("MOVE ITEM TO " + moveText.text);
				// --> MOVE ITEM
				
				// get box object name from moveText
				
				var tempBox : Box = appDisplay.appData.getBoxByName(moveText.text);
				if (tempBox) {
					appDisplay.appData.moveItem(item,tempBox);	// move
					appDisplay.moveItemScreenToItemInfoScreen(item);
				}
				

			} else if (target is ExitButton) {
				appDisplay.moveItemScreenToItemInfoScreen(item);
			}
			
		}
		
		public function reset():void {
			item = null;
			moveText.text = "";
			itemText.text = "";
		}
	}
	
}
