package {

	import flash.display.MovieClip;
	import flash.events.KeyboardEvent;
	import flash.events.Event;
	import flash.ui.Keyboard;
	import flash.events.FocusEvent;

	public class SearchBar extends MovieClip {

		public var homeScreen: HomeScreen;
		public var searchTerm: String;
		public var keysPressed: int;

		public function SearchBar(): void {
			// constructor code
			// searchText.addEventListener(TextEvent.TEXT_INPUT, onTextInput);

			searchText.addEventListener(FocusEvent.FOCUS_IN, onFocusIn, false, 0, true);
			searchText.addEventListener(FocusEvent.FOCUS_OUT, onFocusOut, false, 0, true);
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage, false, 0, true);
		}

		public function reset(): void {
			searchTerm = "";
			keysPressed = 0;
			searchText.text = "search...";
			homeScreen.searchActive = false;
		}
		public function onFocusIn(fE: FocusEvent): void {
			searchText.text = "";
		}
		public function onFocusOut(fE: FocusEvent): void {
			searchText.text = "search...";
		}

		public function onAddedToStage(e: Event): void {
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onDown, false, 0, true);
			//stage.addEventListener(FlexEvent.ENTER, onFlexEnter, false, 0, true);

			homeScreen = parent as HomeScreen;
		}

		/*public function onFlexEnter(fE: FlexEvent): void {
			trace(" * * FLEX ENTER * * ");

			searchTerm = searchText.text;
			searchTerm = searchTerm.substring(searchTerm.length - keysPressed, searchTerm.length);
			trace("\nSEARCH TERM: " + searchTerm);
			searchText.text = "";
			keysPressed = 0;
			stage.focus = null;

			search(searchTerm);
		}*/

		public function onRemovedFromStage(e: Event): void {
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, onDown);
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage, false, 0, true);
		}

		public function onDown(kE: KeyboardEvent): void {
			if (kE.keyCode == Keyboard.ENTER && stage.focus == searchText) {
				//trace(" * * ONDOWN ENTER * * ");
				//trace(" * * searchText.text: " + searchText.text);
				searchTerm = searchText.text;
				//trace(" * * searchTerm (pre): " + searchTerm);
				//trace(" * * searchTerm.length: " + searchTerm.length);
				//trace(" * * keysPressed: " + keysPressed);

				//find it
				//searchTerm = searchTerm.substring(searchTerm.length - keysPressed, searchTerm.length);				

				trace("\nSEARCH TERM: " + searchTerm);
				keysPressed = 0;
				stage.focus = null;
				
				if (searchTerm == "") return;

				search(searchTerm);
				searchText.text = searchTerm;
				//searchTag(searchTerm);

				homeScreen.searchActive = true;

			} else if (kE.keyCode == Keyboard.BACKSPACE) {
				keysPressed--;
				if (keysPressed < 0) keysPressed = 0;
			} else {
				keysPressed++;
			}
		}

		public function search(term: String): void {

			trace("\nStarting search for: " + term);

			var results: Array = homeScreen.appDisplay.appData.search(term);

			trace("\nSearch Results: " + results);

			homeScreen.boxLibrary.display.populate(results);
		}

		public function searchTag(tag: String): void {

			var results: Array = homeScreen.appDisplay.appData.searchTag(tag);

			trace("\nSearch Results: " + results);

			homeScreen.boxLibrary.display.populate(results);

		}


	}

}