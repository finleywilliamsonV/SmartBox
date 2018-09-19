package {

	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.events.MouseEvent;
	import flash.events.Event;


	public class NewItemScreen extends MovieClip {

		public var appDisplay: AppDisplay;
		public var appData: AppData;
		public var box: Box;

		public var newItemName: String;
		public var newItemTags: Array;
		public var newItemPhoto: Photo;

		public var tagLibrary: TagLibrary;

		public var savedPhoto: Photo;

		public function NewItemScreen(_appDisplay: AppDisplay): void {
			// constructor code
			appDisplay = _appDisplay;
			appData = appDisplay.appData;

			tagLibrary = new TagLibrary(appData);
			addChild(tagLibrary);
			tagLibrary.x = 25;
			tagLibrary.y = 800;
			//tagLibrary.y = 25;

			//trace("appData: " + appData);

			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}

		public function onAddedToStage(e: Event): void {
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			addEventListener(MouseEvent.CLICK, onClick);
		}

		public function onRemovedFromStage(e: Event): void {
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			removeEventListener(MouseEvent.CLICK, onClick);
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}

		public function onClick(mE: MouseEvent) {
			trace("\nCLICK!");
			trace(mE.target);
			//trace(mE);

			var target = mE.target;

			if (target is FinishButton) {

				finalizeItem();


			} else if (target is AddPhotoButton) {

				addPhotoButton.takePicture();


			} else if (target is ReturnButton || target is ExitButton) {
				appDisplay.newItemScreenToBoxScreen();
			}
		}

		public function setup(thisBox: Box): void {
			box = thisBox;
			nameText.text = "Item " + (GlobalVariables.instance.numItems + 1);

			
			tagLibrary.setup();
			
			// random tags
			/*var tagsArray:Array = [];
			for (var i : int = 0; i < (1+ int(Math.random()*2));i++) {
				tagsArray.push(String("TAG " + String(int((Math.random() * 6) + 1))));
			}*/

			// *) display tags -> setup tagLibrary - UNNECESSARY - 
			// tagsText.text = tagsArray.join(", ");

			if (savedPhoto) {
				addChild(savedPhoto);
				savedPhoto.x = addPhotoButton.x;
				savedPhoto.y = addPhotoButton.y;
			}
		}

		public function finalizeItem(): void {
			trace("NAME SET TO: " + nameText.text);
			newItemName = nameText.text;

			// *) save tags
			trace("TAGS SET TO: " + tagLibrary.tagsSelected.join(", "));
			newItemTags = tagLibrary.tagsSelected.concat(tagLibrary.deletableTagArray);

			trace("PIC SET TO: " + newItemPhoto);


			box.add(new Item(appData, newItemName, newItemTags, newItemPhoto));
			appDisplay.newItemScreenToBoxScreen();
		}
		
		public function storePhotoData(_photo: Photo): void {
			newItemPhoto = _photo;
			savedPhoto = _photo;
			addChild(savedPhoto);
			savedPhoto.x = addPhotoButton.x;
			savedPhoto.y = addPhotoButton.y;
		}

		public function reset(): void {
			box = null;
			nameText.text = "";

			// 1) reset tagLibrary
			// tagsText.text = "";
			tagLibrary.reset();

			if (savedPhoto && savedPhoto.parent == this) {
				removeChild(savedPhoto);
			}
			savedPhoto = null;
			newItemPhoto = null;
		}

		/*public function processTagsText() : Array {
			trace("\nPROCESSING TAG TEXT");
			tagsText.text = tagsText.text.toUpperCase();
			
			var returnArray : Array = [];
			var tagTextArray : Array = tagsText.text.split("");
			
			var tempLetter:String;
			var tempString:String = "";
			var startingIndex:int = 0;
			
			for (var i : int = 0; i < tagTextArray.length; i++) {
				tempLetter = tagTextArray[i];
				
				if (tempLetter == ",") {
					returnArray.push(tempString);
					tempString = "";
					i++;
					
				} else if (i == tagTextArray.length-1) {
					tempString += tempLetter;
					returnArray.push(tempString);
					tempString = "";
					
				} else {
					tempString += tempLetter;
				}
			}
			
			trace("TAGS: " + returnArray.join(", "));
			return returnArray;
		}*/

		/*public function finalizeItem(fillWith: int = 0): void {
			trace("\n	8	8	8	8	8	8	8	8	8	8	8	8	8	BREAK");
			trace("\nFINALIZING ITEM: " + newItemName, newItemTags, newItemPhoto);
			var newItem: Item = new Item(appData, newItemName, newItemTags, newItemPhoto);
			box.add(newItem);
		}*/


	}

}