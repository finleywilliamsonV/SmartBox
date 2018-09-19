package {

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	import flash.display.Loader;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;

	// numItemsText dateCreatedText

	public class BoxInfoScreen extends MovieClip {

		public var appDisplay: AppDisplay;
		public var appData: AppData;
		public var box: Box;

		public var savedPhoto: Photo;
		public var l :Loader;

		public function BoxInfoScreen(_appDisplay: AppDisplay): void {
			// constructor code

			appDisplay = _appDisplay;
			appData = appDisplay.appData;
			
			stockBoxImage.visible = false;

			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}

		public function onAddedToStage(e: Event): void {
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			addEventListener(MouseEvent.CLICK, onClick);
		}

		public function onRemovedFromStage(e: Event): void {
			removeEventListener(MouseEvent.CLICK, onClick);
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}

		public function setup(boxToReview: Box) {
			box = boxToReview;
			nameText.text = box.name;
			locationText.text = box.location;
			tagsText.text = box.tags.join(", ");
			numItemsText.text = String(box.items.length);
			dateCreatedText.text = String(String(box.dateCreated.month + 1) + "/" + box.dateCreated.date + "/" + box.dateCreated.fullYear);

			// resize name text
			if (nameText.text.length > 9) {

				var prevWidth = nameText.width;
				var prevHeight = nameText.height;

				nameText.scaleX = 1 - ((nameText.text.length - 8) / 20);
				nameText.scaleY = 1 - ((nameText.text.length - 8) / 20);

				nameText.x += (prevWidth - nameText.width) / 2;
				nameText.y += (prevHeight - nameText.height) / 2;
			}


			savedPhoto = boxToReview.photo;
			
			if (savedPhoto) {
				addChild(savedPhoto);
				savedPhoto.x = addPhotoButton.x;
				savedPhoto.y = addPhotoButton.y;
				
			} else if (boxToReview.photoFilePath) {
				
				
				
			} else {
				stockBoxImage.visible = true;
			}
			
			trace("Box name: " + box.name);
			trace("Box appData: " + box.appData);
			trace("Box location: " + box.location);
			trace("Box photo: " + box.photo);
			trace("Box photoFilePath: " + box.photoFilePath);
			trace("Box tags: " + box.tags);
			trace("Box items: " + box.items);
		}

		public function onClick(mE: MouseEvent) {
			trace("\nCLICK!");
			trace(mE.target);
			trace(mE);

			mE.stopPropagation();

			var target = mE.target;

			if (target is MoveButton) {
				trace("MOVE BOX");
				// --> MOVE BOX SCREEN
				appDisplay.boxInfoScreenToMoveBoxScreen(box);

			} else if (target is DeleteButton) {
				trace("DELETE BOX");
				// --> DELETE BOX POP-UP
				appData.remove(box);
				appDisplay.boxInfoScreenToHomeScreen();

			} else if (target is EditButton) {
				trace("EDIT BOX");
				// --> EDIT BOX SCREEN
				appDisplay.boxInfoScreenToEditBoxScreen(box);

			} else if (target is ExitButton) {
				appDisplay.boxInfoScreenToBoxScreen();
			}


			//parentScreen.switchScreens(this, parentScreen.locationScreen);
		}

		public function reset(): void {
			box = null;
			nameText.text = "";
			locationText.text = "";
			tagsText.text = "";
			numItemsText.text = "";
			dateCreatedText.text = "";

			if (savedPhoto && savedPhoto.parent == this) {
				removeChild(savedPhoto);
			}
			savedPhoto = null;

			nameText.scaleX = 1;
			nameText.scaleY = 1;

			nameText.x = -275;
			nameText.y = 500;
		}
	}

}