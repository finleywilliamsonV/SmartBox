package {

	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.events.MouseEvent;
	import flash.events.Event;


	public class EditItemScreen extends MovieClip {

		public var appDisplay: AppDisplay;
		public var appData: AppData;
		
		public var tagLibrary: TagLibrary;
		
		public var itemToEdit : Item;
		public var editedItemName: String;
		public var editedItemPicture: * ;
		public var editedItemLocation: String;

		public function EditItemScreen(_appDisplay: AppDisplay): void {
			// constructor code
			appDisplay = _appDisplay;
			appData = appDisplay.appData;
			
			tagLibrary = new TagLibrary(appData);
			addChild(tagLibrary);
			tagLibrary.x = 25;
			tagLibrary.y = 800;
			
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

		public function setup(thisItem:Item): void {
			itemToEdit = thisItem;
			nameText.text = thisItem.name;
			
			tagLibrary.setup();
			tagLibrary.setSelected(thisItem.tags);
			
			trace("SET SELECTED: " + thisItem.tags);
		}
		
		public function onClick(mE:MouseEvent) {
			trace("\nCLICK!");
			trace(mE.target);
			trace(mE);
			
			mE.stopPropagation();
			
			var target = mE.target;
			
			if (target is FinishButton) {
				trace("FINALIZING EDITS");
				finalizeEdits();
				appDisplay.editItemScreenToBoxScreen();
			} else if (target == nameText) {
				target.setSelection(0, target.getLineLength(0));
			} else if (target is CancelButton) {
				trace("CANCELLING EDITS");
				appDisplay.editItemScreenToBoxScreen();
			} else if (target is ExitButton) {
				appDisplay.editItemScreenToBoxScreen();
			} else if (target is AddPhotoButton) {
				addPhotoButton.takePicture();
			}
		}
		

		public function finalizeEdits(): void {
			trace("NAME SET TO: " + nameText.text);
			itemToEdit.name = nameText.text;
			trace("TAGS SET TO: " + tagLibrary.tagsSelected.join(", "));
			itemToEdit.resetAndAddTags(tagLibrary.tagsSelected);
			trace("PIC SET TO: " + editedItemPicture);
			itemToEdit.photo = editedItemPicture;
		}
		
		public function reset(): void {
			itemToEdit = null;
			nameText.text = "";
			tagLibrary.reset();
		}

	}

}