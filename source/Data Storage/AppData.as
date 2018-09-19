package {
	import flash.net.SharedObject;
	import flash.utils.IDataOutput;
	import flash.utils.IDataInput;
	import flash.utils.IExternalizable;
	import flash.net.registerClassAlias;
	import flash.display.Loader;

	public class AppData implements IExternalizable {

		public var docClass: DocClass;
		public var boxes: Array;
		public var tags: Array;
		public var locations: Array;
		public var tutorialChecks:Array;

		public var showBoxResults: Boolean = true;

		public function AppData(_docClass: DocClass = null) {
			// constructor code
			docClass = _docClass;
			boxes = [];
			tags = [];
			locations = [];
			tutorialChecks = [1,1,1,1];
		}

		public function writeExternal(output: IDataOutput): void {
			output.writeObject(docClass);
			output.writeObject(boxes);
			output.writeObject(tags);
			output.writeObject(locations);
			output.writeObject(tutorialChecks);
		}

		public function readExternal(input: IDataInput): void {
			docClass = input.readObject();
			boxes = input.readObject();
			tags = input.readObject();
			locations = input.readObject();
			tutorialChecks = input.readObject();
		}

		public function saveData(): void {
			trace("\n * * SAVE DATA CALL FROM APPDATA * * ");
			trace("boxes: " + boxes);
			trace("tags: " + tags);
			trace("locations: " + locations);
			trace("tutorialChecks: " + tutorialChecks);
			//GlobalSharedObject.instance.saveData(boxes, tags, locations);
			registerClassAlias("AppData", AppData);
			registerClassAlias("Box", Box);
			registerClassAlias("Item", Item);
			registerClassAlias("Photo", Photo);
			registerClassAlias("Loader", Loader);
			var newSharedObject: SharedObject = SharedObject.getLocal(GlobalSharedObject.localString);
			newSharedObject.data.appData = this as AppData;
			newSharedObject.flush();
		}

		
		// NOT USED !!!
		public function restoreData(): void {

			registerClassAlias("AppData", AppData);
			registerClassAlias("Box", Box);
			registerClassAlias("Item", Item);
			registerClassAlias("Photo", Photo);
			registerClassAlias("Loader", Loader);
			var newSharedObject: SharedObject = SharedObject.getLocal(GlobalSharedObject.localString);
			var loadedAppData: AppData = newSharedObject.data.appData as AppData;

			boxes = loadedAppData.boxes;
			tags = loadedAppData.tags;
			locations = loadedAppData.locations;
			tutorialChecks = loadedAppData.tutorialChecks;
		}

		public function add(box: Box): void {
			boxes.push(box);
			trace("\n\n* * * * * * * * * * * * * * * * * * * * \nAppData: Adding Box" + box.info);
			trace("* * * * * * * * * * * * * * * * * * * *\n");
			saveData();
		}
		
		public function checkAllTags() : void {
			trace("\nAppData: begin checkAllTags()");
			tags = [];
			for (var i:int = 0; i < boxes.length; i ++) {
				boxes[i].checkAllTags();
				checkTags(boxes[i]);
			}
			saveData();
		}

		private function checkTags(box: Box): void {
			var tempTag: String;
			for (var i: int = 0; i < box.tags.length; i++) {
				tempTag = box.tags[i];
				if (tags.indexOf(tempTag) < 0) {
					tags.push(tempTag);
					trace("\nAppData: adding tag - " + tempTag);
					trace("AppData: all tags - " + tags);
				}
			}
		}

		public function remove(box: Box): void {
			boxes.splice(boxes.indexOf(box), 1);
			box.destroy();
			checkAllTags();
		}
		
		public function searchNameAndTags(searchTerm:String) : Array {
			var results: Array = [];
			
			results = results.concat(search(searchTerm));
			
			for each ( var tempTag : String in tags) {
				
				if (tempTag == searchTerm) {
					results.push(new Tag(searchTerm));
				}
				
			}
			
			trace("	-	-	-	-	-	-	-	-	-	-	-	-	-	-	SEARCH ALL RESULTS !!!");
			trace(results);
			
			return results;
		}

		public function search(searchTerm: String): Array {
			var tempBox: Box;
			var results: Array = [];

			//boxes
			var boxResults: Array = GlobalVariables.search(searchTerm, boxes);
			for (var i: int = 0; i < boxResults.length; i++) {
				if (showBoxResults) results.push(boxResults[i]);
			}

			//items
			var itemResults: Array;
			for (var j: int = 0; j < boxes.length; j++) {
				tempBox = boxes[j];
				itemResults = [];
				itemResults = GlobalVariables.search(searchTerm, tempBox.items);
				for (var k: int = 0; k < itemResults.length; k++) {
					results.push(itemResults[k]);
				}
			}
			
			var tagObjects:Array = [];
			for each(var tempTag:String in tags) {
				tagObjects.push(new Tag(tempTag));
				trace(tempTag);
			}
			
			trace("1: " + tagObjects);
			var tagResults:Array = GlobalVariables.search(searchTerm, tagObjects);
			
			trace("2: " + tagResults);
			
			results = results.concat(tagResults);
			trace("3: " + results);

			return results;
		}

		public function searchTag(tag: String): Array {
			var tempBox: Box;
			var tempItem: Item;
			var results: Array = [];

			trace("\n\n - APP DATA: SEARCHING TAGS FOR '" + tag + "' -");

			for (var i: int = 0; i < boxes.length; i++) {
				tempBox = boxes[i];

				if (tempBox.hasTag(tag)) {

					if (showBoxResults) results.push(tempBox);

					for (var j: int = 0; j < tempBox.items.length; j++) {

						tempItem = tempBox.items[j];

						if (tempItem.hasTag(tag)) {

							results.push(tempItem);
						}
					}
				}
			}
			return results;
		}

		public function destroyAllBoxes(): void {
			for (var i: int = boxes.length - 1; i >= 0; i--) {
				boxes[i].destroy();
			}
			saveData();
		}

		public function moveItem(item: Item, newBox: Box): void {
			var oldItems: Array = item.box.items;
			oldItems.splice(oldItems.indexOf(item), 1);
			item.box.checkAllTags();
			newBox.add(item);
			saveData();
		}

		public function moveBox(box: Box, newLocation: String): void {
			box.location = newLocation;

			var tempItem: Item;
			for (var i: int = 0; i < box.items.length; i++) {
				tempItem = box.items[i];
				tempItem.location = box.location;
			}
			saveData();
		}

		/*
		
		move box
		
		change location -> update below?
		
		2 new display methods
		
		*/

		public function getBoxByName(nameString: String): Box {
			for (var i: int = boxes.length - 1; i >= 0; i--) {
				if (boxes[i].name == nameString) {
					return boxes[i]
				}
			}
			return null;
		}

		public function traceAllData(): void {

			var tempBox: Box;
			var tempItem: Item;

			for (var i: int = 0; i < boxes.length; i++) {
				tempBox = boxes[i];
				trace(tempBox);
				for (var j: int = 0; j < tempBox.items.length; j++) {
					tempItem = tempBox.items[j];
					trace(tempItem.info);
				}
			}
		}

		public function get totalBoxes(): int {
			return boxes.length;
		}
		public function get totalItems(): int {
			var total: int = 0;

			for (var i: int = 0; i < boxes.length; i++) {
				total += boxes[i].items.length;
			}
			return total;
		}

		public function destroy(): void {
			destroyAllBoxes();
			docClass = null;
			boxes = null;
			//tags = null;
			//locations = null;
		}
	}

}