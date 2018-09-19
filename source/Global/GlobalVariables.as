package {
	import flash.utils.ByteArray;
	import flash.sensors.Accelerometer;

	public class GlobalVariables {

		private static var _instance: GlobalVariables;
		private static var _allowInstantiation: Boolean;

		public static var letters: Array = new Array("A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z");
		public static const DEFAULT_LOCATIONS: Array = new Array("Attic", "Basement", "Condo", "Dad's House", "Elevator Shaft", "Factory", "Gma's", "Hallway", "Igloo", "Jasement", "Kourtyard", "Lego Room", "Mom's House", "Neighbor's House", "Outside", "Patio", "Quilt Store", "Railroad", "Storage", "Underground", "Ventilation Duct", "Wattic", "X Marks the Spot", "Yellow Land", "Zordo");
		public static const DEFAULT_TAGS: Array = new Array("Clothes", "Toys", "Photos", "Books", "Movies", "Socks", "Skateboards", "Decorations", "Costumes", "Antique", "Fine China");
		
		
		// tag library
		public static const TAG_LIB_WIDTH = 700;
		public static const TAG_LIB_HEIGHT = 200;
		public static const TAG_LIB_BUFFER = 10;
		public static const TAG_LIB_TXT_L: int = 50;
		public static const TAG_LIB_TXT_S: int = 35;
		
		// location library
		public static const LOC_LIB_WIDTH = 700;
		public static const LOC_LIB_HEIGHT = 400;
		public static const LOC_LIB_BUFFER = 10;
		public static const LOC_LIB_TXT_L: int = 50;
		public static const LOC_LIB_TXT_S: int = 35;
		
		private var _numItems:int;
		private var _numBoxes:int;
		
		private var _locationNumber: int = 1;
		private var _boxNumber: int = 1;
		private var _itemNumber: int = 1;
		private var _tagNumber: int = 1;

		public static var isMobile: Boolean;

		public var appData: AppData;

		public static function get instance(): GlobalVariables {
			if (!_instance) {
				_allowInstantiation = true;
				_instance = new GlobalVariables();
				_allowInstantiation = false;

				if (Accelerometer.isSupported) {
					isMobile = true;
				} else {
					isMobile = false;
				}
			}

			return _instance;
		}

		public static function fillBox(thisBox: Box, numOfItems: int): void {

			var letterIndexBox: int = 0;
			var letterIndexItem: int = 0;

			for (var i: int = 0; i < numOfItems; i++) {
				thisBox.add(new Item(null, "Item " + String(letters[letterIndexItem] + "-" + String(i + 1) + " : " + randomLetters(8))));
			}
			letterIndexItem++;
		}

		public static function addOneItem(thisBox: Box): void {

			thisBox.add(new Item(null, "Item " + randomLetters(8)));
		}

		public static function randomLetters(numberOfLetters: int): String {
			var letterString: String = "";

			for (var i: int = 0; i < numberOfLetters; i++) {
				letterString += String(letters[int(Math.random() * letters.length)]);
			}

			trace(letterString);
			return letterString;
		}


		public static function clone(source: Object): * {
			var myBA: ByteArray = new ByteArray();
			myBA.writeObject(source);
			myBA.position = 0;
			return (myBA.readObject());
		}

		public static function search(searchTerm: String, arrayToSearch): Array {

			trace("\nBegin Search\nTerm: '" + searchTerm + "'\n")

			if (arrayToSearch.length == 0) return [];

			var matchingItems: Array = [];
			var currentItem: * ;
			var doesMatch: Boolean;

			var searchStringArray: Array = searchTerm.toUpperCase().split("");
			var currentSearchLetter: String;

			//trace("searchStringArray: " + searchStringArray);

			var itemStringArray: Array;
			var currentItemLetter: String;

			for (var i: int = 0; i < arrayToSearch.length; i++) { // arrayToSearch

				currentItem = arrayToSearch[i];
				itemStringArray = currentItem.name.toUpperCase().split("");

				//trace("\nitemStringArray: " + itemStringArray);


				for (var j: int = 0; j < itemStringArray.length; j++) { // item name letters

					var tempIndex: int = j;

					//trace("\ntempIndex = " + j);

					for (var k: int = 0; k < searchStringArray.length; k++) { // search term letters

						currentItemLetter = itemStringArray[tempIndex];
						currentSearchLetter = searchStringArray[k];

						//trace("currentItemLetter:   " + currentItemLetter);
						//trace("currentSearchLetter: " + currentSearchLetter);

						if (currentItemLetter == currentSearchLetter) {

							//trace("\n == ARE EQUAL ==");

							if (k == searchStringArray.length - 1) {

								//trace(" x END OF SEARCH STRING x");

								trace("\n -> Match Found! <-\nAdding: " + currentItem);

								matchingItems.push(currentItem);

								j = itemStringArray.length;

								break;

							}

							tempIndex++;

							//trace("tempIndex ++: " + tempIndex);
							//trace("itemStringArray.length:   " + itemStringArray.length);

							if (tempIndex == itemStringArray.length) { // runs out of item letters

								//trace("\n x END OF ITEM STRING, TRY NEXT ITEM x\n");

								j = itemStringArray.length;

								break;

								//if (k == searchStringArray.length - 1) { // also on last letter of search term
								//	
								//	matchingItems.push(currentItem);
								//	
								//	trace("\n -> Match Found! <-\nAdding: " + currentItem);
								//	
								//}
							}
						} else {
							break;
						}
					}

				}

			}

			return matchingItems;
		}

		public function get numItems(): int {
			var total : int = 0;
			for each (var b :Box in appData.boxes) {
				total += b.items.length;
			}
			return total;
		}

		public function GlobalVariables() {
			if (!_allowInstantiation) {
				throw new Error("ERROR: STOP IT FOOL, DON'T INITIALIZE!!");
			}
		}

	}

}