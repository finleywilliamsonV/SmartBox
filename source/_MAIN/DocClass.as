package {

	import flash.display.MovieClip;
	import flash.net.registerClassAlias;
	import flash.net.SharedObject;
	import flash.display.Loader;

	public class DocClass extends MovieClip {

		//#antique #misc #(persons name) -> other more descriptive tags?

		public var letters: Array = new Array("A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z");
		public var letterIndexBox: int = 0;
		public var letterIndexItem: int = 0;



		// APP VARIABLES
		public var appData: AppData;
		public var appDisplay: AppDisplay;


		public function DocClass() {
			// constructor code
			trace("\n - WTB - \n");

			loadAppData();

			//fillAppData(1,"Basement");
			//fillAppData(2,"Attic");
			//fillAppData(2,"Garage");
			//fillAppData(1,"Closet");
			//fillAppData(4,"Storage Unit");

			//appData.traceAllData();

			trace("\nALL TAGS: " + appData.tags.join(", "));

			appDisplay = new AppDisplay(appData);
			addChild(appDisplay);

			//trace(Math.pow(10,20476849));

			//trace(appData.searchTags("Photos"));


			//trace("\n\n- - -   APP DATA   - - -");
			//trace("Total Boxes: " + appData.totalBoxes);
			//trace("Total Items: " + appData.totalItems);
			//trace("- - - - - - - - - - - - -\n\n");

			//trace(appData.search("MAG"));

			//trace("\n					~  Results  ~\n" + appData.searchTags("Skateboards"));


			//// SORT EXAMPLE
			//var box_01 : Box = new Box("Box 1", "Attic");
			//fillBox(box_01, 20);
			//
			//trace("\n\n_____________________________\n\n");
			//trace("  -  Start Sort Example  -");
			//trace("\n_____________________________\n\n");
			//trace("\nBefore Randomization");
			//trace(box_01);
			//
			//box_01.randomize();
			//
			//trace("After Randomization, Before Sort");
			//trace(box_01);

			//box_01.sortByDate();
			//
			//trace("\nAfter Sort");
			//trace(box_01);



			/* SEARCH EXAMPLE 
			
			var item_01 : Item = new Item("Red Hat");
			var item_02 : Item = new Item("Red Hatsy");
			var item_03 : Item = new Item("Red Ha");
			var item_04 : Item = new Item("Bred Hat");
			var item_05 : Item = new Item("Ed Ha");
			
			var box_01 : Box = new Box("Box 1", "Attic");
			
			box_01.add(item_01);
			box_01.add(item_02);
			box_01.add(item_03);
			box_01.add(item_04);
			box_01.add(item_05);
			
			trace("\n\n_____________________________\n\n");
			trace("  -  Start Search Example  -");
			trace("\n_____________________________\n\n");
			
			var searchTerm : String = "red";
			var searchResults : Array = GlobalVariables.search(searchTerm, box_01.items);
			
			trace("\n\n_____________________\n");
			trace("   SEARCH COMPLETE");
			trace("______________________\n");
			trace("Search Term: " + searchTerm);
			trace("Terms Matching: (" + searchResults.length + "/" + box_01.items.length + ")");
			trace("Search Results: " + searchResults.join(", "));
			*/

		}

		public function loadAppData(): void {
			registerClassAlias("AppData", AppData);
			registerClassAlias("Box", Box);
			registerClassAlias("Item", Item);
			registerClassAlias("Photo", Photo);
			registerClassAlias("Loader", Loader);
			var newSharedObject: SharedObject = SharedObject.getLocal(GlobalSharedObject.localString);

			if (newSharedObject.data.appData == null) {
				trace(" + Creating new AppData");
				appData = new AppData(this);
			} else {
				trace(" + Retrieving stored AppData");
				appData = newSharedObject.data.appData as AppData;
				appData.docClass = this;
				trace(" + appData: " + appData);
				trace(" + docClass: " + appData.docClass);
				trace(" + boxes: " + appData.boxes);
				trace(" + tags: " + appData.tags);
				trace(" + locations: " + appData.locations);
				trace(" + tutorialChecks: " + appData.tutorialChecks);
			}

			GlobalVariables.instance.appData = appData;
		}

		public function fillBox(thisBox: Box, numOfItems: int): void {

			for (var i: int = 0; i < numOfItems; i++) {
				thisBox.add(new Item(appData, "Item " + String(letters[letterIndexItem] + "-" + String(i + 1) + " : " + randomLetters(8))));
			}

			letterIndexItem++;
		}

		public function fillAppData(numOfBoxes: int, location: String): void {

			var tempBox: Box;
			for (var i: int = 0; i < numOfBoxes; i++) {
				tempBox = new Box(appData, "Box " + String(letters[letterIndexBox]), location);
				letterIndexBox++;
				fillBox(tempBox, 5);
				randomlyTagItems(tempBox.items);
				appData.add(tempBox);
			}
		}

		public function randomLetters(numberOfLetters: int): String {
			var letterString: String = "";

			for (var i: int = 0; i < numberOfLetters; i++) {
				letterString += String(letters[int(Math.random() * letters.length)]);
			}

			return letterString;
		}

		public function randomlyTagItems(theseItems: Array): void {

			var r: int;

			for (var i: int = 0; i < theseItems.length; i++) {
				r = Math.random() * GlobalVariables.DEFAULT_TAGS.length;
				theseItems[i].addTag(GlobalVariables.DEFAULT_TAGS[r]);
			}


		}
	}

}