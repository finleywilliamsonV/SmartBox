package  {
	
	import flash.display.MovieClip;
	
	
	public class ItemLibrary_ItemDisplay extends MovieClip {
		
		public var item:Item;
		public var itemName:String;
		
		public function ItemLibrary_ItemDisplay(_item : Item) {
			// constructor code
			item = _item;
			itemName = item.name;
			itemText.text = itemName;
		}
	}
	
}
