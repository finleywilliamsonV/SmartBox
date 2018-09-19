package {

	public class Item {

		public var appData:AppData;
		public var name: String;
		public var location:String;
		public var tags: Array;
		public var photo: Photo ;
		public var box:Box;
		
		public var dateCreated : Date;
		public var dateInMiliseconds : int;

		public function Item(_appData:AppData = null, _name: String = "Empty Item" , _tags: Array = null, _photo: Photo = null): void {
			// constructor code

			appData = _appData;
			name = _name;
			photo = _photo;
			
			if (_tags) {
				tags = _tags;
			} else {
				tags = [];
			}
			
			dateCreated = new Date();
			dateInMiliseconds = dateCreated.time;
			
			/*for(var i:int = 0; i < 10000000; i++) {
				
			}*/
			//trace(info);
		}
		
		public function resetAndAddTags(newTags:Array) : void {	// for use with edit item screen
			tags = [];
			addTags(newTags);
			appData.checkAllTags();
		}
		
		public function addTags(newTags:Array) : void {
			
			for (var i: int = 0; i < newTags.length; i++) {
				addTag(newTags[i]);
			}
			
			//GlobalVariables.instance.appData.saveData();
		}
		
		public function addTag(newTag:String): void {
			var tagIsPresent : Boolean = false;
			for (var i: int = 0; i < tags.length; i++) {
				if (tags[i] == newTag) {
					tagIsPresent = true;
					break;
				}
			}
			
			if (tagIsPresent == false) {
				tags.push(newTag.toUpperCase());
				appData.checkAllTags();
			}
			//GlobalVariables.instance.appData.saveData();
		}

		public function hasTag(tag:String):Boolean {
			for (var i: int = 0; i < tags.length; i++) {
				if (tags[i].toUpperCase() == tag.toUpperCase()) return true;
			}
			return false;
		}
		
		public function toString(): String {
			return name;	// CHANGE TO INFO - find it
		}
		
		public function get info(): String {
			//return (String("\n--- ITEM ---\nName: " + name + "\n" + "Created: " + dateCreated.toLocaleString()  + "\n" + "In Miliseconds: " + dateInMiliseconds + "\n" + "Photo: " + photo + "\n" + "Tags: " + tags + "\n"));
			return (String("\n--- ITEM ---\nName: " + name + "\n" + "Created: " + dateCreated.toLocaleString() + "\n" + "Location: " + location + "\n" + "Box: " + box.name + "\n" + "Tags: " + tags.join(", ") + "\n" ));
		}

		public function destroy(): void {
			photo = null;
			tags = null;
			dateCreated = null;
			box = null;
		}

	}
}