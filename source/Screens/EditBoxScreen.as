package {

	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.events.MouseEvent;
	import flash.events.Event;


	public class EditBoxScreen extends MovieClip {

		public var appDisplay: AppDisplay;
		public var appData: AppData;
		public var nameScreen: EditBox_Name;
		public var locationScreen: EditBox_Location;
		public var reviewScreen: EditBox_Review;

		public var boxToEdit : Box;
		public var editedBoxName: String;
		public var editedBoxPicture: * ;
		public var editedBoxLocation: String;

		public function EditBoxScreen(_appDisplay: AppDisplay): void {
			// constructor code
			appDisplay = _appDisplay;
			appData = appDisplay.appData;

			nameScreen = new EditBox_Name(this);
			locationScreen = new EditBox_Location(this);
			reviewScreen = new EditBox_Review(this);
		}

		public function setup(thisBox:Box): void {
			boxToEdit = thisBox;
			nameScreen.setup(boxToEdit);
			addChild(nameScreen);
		}
		
		// numItemsText dateCreatedText

		public function switchScreens(fromThis: MovieClip, toThis: MovieClip): void {
			trace("APP DATA BOXES: " + appData.boxes);
			
			removeChild(fromThis);
			addChild(toThis);

			if (toThis is EditBox_Review) {
				toThis.setup(boxToEdit, editedBoxName, editedBoxLocation, editedBoxPicture);
			} else {
				toThis.setup(boxToEdit);
			}
		}

		public function finalizeEdits(): void {
			boxToEdit.name = editedBoxName;
			boxToEdit.location = editedBoxLocation;
			boxToEdit.photo = editedBoxPicture;
		}

		public function resetAll(): void {

			removeChildren();
			nameScreen.reset();
			locationScreen.reset();
			reviewScreen.reset();
		}

	}

}