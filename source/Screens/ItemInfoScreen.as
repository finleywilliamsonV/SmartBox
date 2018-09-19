package  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	// numItemsText dateCreatedText
	
	public class ItemInfoScreen extends MovieClip {
		
		public var appDisplay: AppDisplay;
		public var item:Item;
		
		public var savedPhoto:Photo;
		
		public function ItemInfoScreen(_appDisplay: AppDisplay): void {
			// constructor code
			
			appDisplay = _appDisplay;
			
			stockItemImage.visible = false;
			
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
		
		public function setup(itemToReview:Item) {
			item = itemToReview;
			nameText.text = item.name;
			locationText.text = item.location;
			boxText.text = item.box.name;
			tagsText.text = item.tags.join(", ");
			dateCreatedText.text = String(String(item.dateCreated.month + 1) + "/" + item.dateCreated.date + "/" + item.dateCreated.fullYear);
			trace("\n -	-	-	-	-	-	-	-	-	" + item.dateCreated.month);
			savedPhoto = itemToReview.photo;
			if (savedPhoto) {
				addChild(savedPhoto);
				savedPhoto.x = addPhotoButton.x;
				savedPhoto.y = addPhotoButton.y;
			} else {
				stockItemImage.visible = true;
			}
		}
		
		public function onClick(mE:MouseEvent) {
			trace("\nCLICK!");
			trace(mE.target);
			trace(mE);
			
			mE.stopPropagation();
			
			var target = mE.target;
			
			if (target is MoveButton) {
				trace("MOVE ITEM");
				// --> MOVE ITEM SCREEN
				appDisplay.itemInfoScreenToMoveItemScreen(item);
				
			} else if (target is DeleteButton) {
				trace("DELETE ITEM");
				// --> DELETE ITEM POP-UP
				item.box.remove(item);
				appDisplay.itemInfoScreenToBoxScreen();

			} else if (target is EditButton) {
				trace("EDIT ITEM");
				// --> EDIT ITEM SCREEN
				appDisplay.itemInfoScreenToEditItemScreen(item);

			} else if (target is ExitButton) {
				appDisplay.itemInfoScreenToBoxScreen();
			}
			
			
			//parentScreen.switchScreens(this, parentScreen.locationScreen);
		}
		
		public function reset():void {
			item = null;
			nameText.text = "";
			locationText.text = "";
			boxText.text = "";
			tagsText.text = "";
			dateCreatedText.text = "";
			
			if (savedPhoto && savedPhoto.parent == this) {
				removeChild(savedPhoto);
			}
			savedPhoto = null;
		}
	}
	
}
