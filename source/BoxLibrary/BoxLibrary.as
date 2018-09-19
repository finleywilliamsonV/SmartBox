package {

	import flash.display.MovieClip;


	public class BoxLibrary extends MovieClip {

		public var unsortedDisplayList: Array = [];
		public var displayList: Array = [];

		public var displayItems:Array = [];
		public var locationDisplays:Array = [];
		public var boxDisplays:Array = [];
		
		public var display:BoxLibrary_Display;
		
		public var locations: Array = [];
		public var boxes: Array = [];
		
		public var parentScreen:HomeScreen;

		public function BoxLibrary(parScreen:HomeScreen): void {
			// constructor code
			parentScreen = parScreen;
			display = new BoxLibrary_Display();
			addChild(display);
		}

		public function populateList(newBoxes: Array): void {
			trace("\n - STARTING POPULATE LIST - ");
			trace("\nALL BOXES: " + newBoxes);
			var tempLocation: String;
			var tempBox: Box;
			var tempIndex: int;
			unsortedDisplayList = [];
			for (var i: int = 0; i < newBoxes.length; i++) {
				tempBox = newBoxes[i];
				//trace(tempBox);

				tempIndex = unsortedDisplayList.indexOf(tempBox.location);
				if (tempIndex < 0) { // new location
					locations.push(tempBox.location);
					unsortedDisplayList.push(tempBox.location);
					unsortedDisplayList.push(new Array(tempBox));
				} else {
					unsortedDisplayList[tempIndex + 1].push(tempBox);
				}
			}

			//trace(unsortedDisplayList);

			if (locations.length == 0) {
				trace("NO LOCATIONS!!!");
				return;
			}

			trace("\n - START SORT LOCATIONS - ");

			var sortedLocations: Array = [];
			var compareString : String;
			var storedIndex:int;
			var storedLength : int = locations.length;

			while (sortedLocations.length < storedLength) {
				compareString = "zzzzzzzzzzzzz";
				//trace("\nLocations: " +locations);
				for (var j: int = 0; j < locations.length; j++) {
					tempLocation = locations[j];
					//trace("tempLocation: " + tempLocation);
					if (tempLocation < compareString) {
						//trace(tempLocation + " is < " + compareString);
						compareString = tempLocation;
						storedIndex  = j;
					}
				}
				sortedLocations.push(compareString);
				locations.splice(storedIndex, 1);
			}
			
			trace("\nSORTED LOCATIONS: " + sortedLocations);
			
			parentScreen.appDisplay.appData.locations = sortedLocations;
			
			trace("\n - START SORT DISPLAY -");
			
			for (var k:int = 0; k < sortedLocations.length; k++) {
				tempLocation = sortedLocations[k];
				displayList.push(tempLocation);
				displayList.push(unsortedDisplayList[unsortedDisplayList.indexOf(tempLocation) + 1]);
			}
			
			trace("\nSORTED: " + displayList);
			
			trace("\n - START LIST DISPLAY -");
			
			display.populate(displayList);
		}
		
		public function reset() : void {
			display.reset();
			
			unsortedDisplayList = [];
			displayList = [];
			displayItems = [];
			locationDisplays = [];
			boxDisplays = [];
			locations = [];
			boxes = [];
			
		}
	}

}