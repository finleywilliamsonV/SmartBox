package {

	import flash.display.MovieClip;


	public class ItemLibrary extends MovieClip {
		
		public var display:ItemLibrary_Display;
		public var box: Box;

		public function ItemLibrary(): void {
			// constructor code
			display = new ItemLibrary_Display();
			addChild(display);
		}

		public function populateList(newBox: Box): void {
			trace("\n - STARTING POPULATE ITEM LIST - ");
			box = newBox;
			display.populate(newBox.items);
		}
		
		public function reset() : void {
			box = null;
			display.reset();
		}
	}

}