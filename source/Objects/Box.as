package {
	import flash.utils.IExternalizable;
	import flash.utils.IDataOutput;
	import flash.utils.IDataInput;
	import flash.net.registerClassAlias;

	public class Box {

		public var appData: AppData;
		public var name: String;
		public var location: String;
		public var photo: Photo;
		public var photoFilePath: String;
		public var tags: Array;
		public var items: Array;

		public var dateCreated: Date;

		/*
		
		
		Remove item, -> check to remove
		possibly create a checkAllTags method
		
		
		
		*/

		public function Box(_appData: AppData = null, _name: String = null, _location: String = null, _photo: Photo = null): void {
			// constructor code

			appData = _appData;

			name = _name;
			location = _location;
			photo = _photo;
			if (photo) {
				photoFilePath = photo.filePath;
			}
			tags = [];
			items = [];

			dateCreated = new Date();
		}

		public function add(newItem: Item): void {
			trace("\nBOX: ADDING NEW ITEM");
			trace(newItem);
			trace(newItem.tags);
			newItem.box = this;
			newItem.location = location;
			items.push(newItem);
			appData.checkAllTags();
		}

		public function remove(newItem: Item): void {
			items.splice(items.indexOf(newItem), 1);
			newItem.destroy();
			appData.checkAllTags();
		}

		public function checkAllTags(): void {
			trace("\n" + name + ": begin checkAllTags()");
			tags = [];
			var updates: int = 0;
			for (var i: int = 0; i < items.length; i++) {

				checkTags(items[i]);

				/*if (checkTags(items[i])) {
					updates++;
				}*/
			}

			//if (updates > 0) {
			//appData.checkAllTags();
			//}
		}


		private function checkTags(thisItem: Item): void {

			var tempItemTag: String;
			//var tempBoxTag: String;
			//var updateRequired: Boolean = false;

			for (var i: int = 0; i < thisItem.tags.length; i++) {
				tempItemTag = thisItem.tags[i];

				if (tags.indexOf(tempItemTag) < 0) {
					tags.push(tempItemTag);
					//updateRequired = true;
				}
			}

			//if (updateRequired) {
			//appData.
			//}

			//return updateRequired;
		}


		public function sortByDate(): void {
			//trace("\n - Begin Sort by Date - \n");
			var tempItem: Item;
			for (var i: int = 0; i < items.length; i++) {
				tempItem = items[i];
				//trace(tempItem + " " + tempItem.dateInMiliseconds);
			}

			items.sortOn('dateInMiliseconds', Array.NUMERIC);
			//trace("\n --- SORTED ---\n");
			for (var j: int = 0; j < items.length; j++) {
				tempItem = items[j];
				//trace(tempItem + " " + tempItem.dateInMiliseconds);
			}
		}

		public function randomize(repeats: int = 20): void {

			//trace("RAND");
			var r: int;
			var tempItem: Item;

			for (var i: int = 0; i < repeats; i++) {
				//trace("\nRepeat #" + (i+1));

				tempItem = items.pop();
				//trace("tempItem: " + tempItem);
				//trace("items: " + items);
				r = Math.random() * items.length;
				//trace("r: " + r);
				items.insertAt(r, tempItem);
				//trace("items: " + items);
			}
		}

		public function destroyAllItems(): void {
			for (var i: int = items.length - 1; i >= 0; i--) {
				items[i].destroy();
			}
			GlobalVariables.instance.appData.saveData();
		}

		public function hasTag(tag: String): Boolean {
			for (var i: int = 0; i < tags.length; i++) {
				if (tags[i].toUpperCase() == tag.toUpperCase()) return true;
			}
			return false;
		}

		public function get info(): String {
			return (String("\n--- BOX ---\nName: " + name + "\n" + "Created: " + dateCreated.toLocaleString() + "\n" + "Location: " + location + "\n" + "Tags: " + tags.join(", ") + "\n" + "Items: " + items.length + "\n"));
		}

		public function toString(): String {
			//return (String("\n--- BOX ---\nName: " + name + "\n" + "Created: " + dateCreated.toLocaleString() + "\n" + "Photo: " + photo + "\n" + "Tags: " + tags + "\n" + "Items: " + items.join(", ") + "\n"));
			//return (String("\n--- BOX ---\nName: " + name + "\n" + "Created: " + dateCreated.toLocaleString() + "\n" + "Location: " + location + "\n" + "Tags: " + tags.join(", ") + "\n" + "Items: " + items.join(", ") + "\n"));
			//return String(name + " - " + location);
			return String(name);
		}

		public function destroy(): void {
			photo = null;
			tags = null;
			dateCreated = null;

			destroyAllItems();
			items = null;
		}

	}
}