package {

	import flash.display.MovieClip;


	public class ItemLibrary_Display extends MovieClip {


		public function ItemLibrary_Display() {
			// constructor code
			y = 400;
		}

		public function populate(elements: Array): void {
			removeChildren();
			for (var l: int = 0; l < elements.length; l++) {

				var tempElement: * = elements[l];
				
				var newItemDisplay: ItemLibrary_ItemDisplay = new ItemLibrary_ItemDisplay(tempElement);
				addChild(newItemDisplay);
				newItemDisplay.y = (numChildren - 1) * 75;


			}
		}
		
		public function reset() : void {
			removeChildren();
		}

	}

}