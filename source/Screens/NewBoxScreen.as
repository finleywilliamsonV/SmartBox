package {

	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.events.MouseEvent;
	import flash.events.Event;


	public class NewBoxScreen extends MovieClip {

		public var appDisplay: AppDisplay;
		public var appData: AppData;
		public var nameScreen: NewBox_Name;
		public var locationScreen: NewBox_Location;
		public var reviewScreen: NewBox_Review;

		public var newBoxName: String;
		public var newBoxPhoto: Photo;
		public var newBoxLocation: String;

		public function NewBoxScreen(_appDisplay: AppDisplay): void {
			// constructor code
			appDisplay = _appDisplay;
			appData = appDisplay.appData;

			nameScreen = new NewBox_Name(this);
			locationScreen = new NewBox_Location(this);
			reviewScreen = new NewBox_Review(this);
		}

		public function setup(): void {
			nameScreen.setup();
			addChild(nameScreen);
		}
		
		// numItemsText dateCreatedText

		public function finalizeBox(fillWith:int = 0): Box {
			trace("\nFINALIZING BOX: " + newBoxName, newBoxLocation);
			var newBox: Box = new Box(appData, newBoxName, newBoxLocation, newBoxPhoto);
			appData.add(newBox);
			if (fillWith > 0) {
				appData.docClass.fillBox(newBox, fillWith);
			}
			resetAll();
			return newBox;
		}

		public function switchScreens(fromThis: MovieClip, toThis: MovieClip): void {
			trace("APP DATA BOXES: " + appData.boxes);
			
			removeChild(fromThis);
			addChild(toThis);

			if (toThis is NewBox_Review) {
				toThis.setup(newBoxName, newBoxLocation);
			} else {
				toThis.setup();
			}
		}

		public function resetAll(): void {

			removeChildren();
			nameScreen.reset();
			locationScreen.reset();
			reviewScreen.reset();
			
			newBoxPhoto = null;
		}

	}

}