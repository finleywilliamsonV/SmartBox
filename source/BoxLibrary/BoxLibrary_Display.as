package {

	import flash.display.MovieClip;


	public class BoxLibrary_Display extends MovieClip {


		public function BoxLibrary_Display() {
			// constructor code
			y = 250;
		}
		
		public function reset() : void {
			removeChildren();
		}

		public function populate(elements: Array): void {
			removeChildren();
			for (var l: int = 0; l < elements.length; l++) {

				var tempElement: * = elements[l];

				if (tempElement is String) {
					var newLocationDisplay: BoxLibrary_LocationDisplay = new BoxLibrary_LocationDisplay(elements[l]);
					addChild(newLocationDisplay);
					newLocationDisplay.y = (numChildren - 1) * 75;
					
				} else if (tempElement is Array) {

					for (var m: int = 0; m < tempElement.length; m++) {
						var newBoxDisplay: BoxLibrary_BoxDisplay = new BoxLibrary_BoxDisplay(tempElement[m]);
						addChild(newBoxDisplay);
						newBoxDisplay.y = (numChildren - 1) * 75;

					}
				} else if (tempElement is Box) {
					var newBoxDisplay: BoxLibrary_BoxDisplay = new BoxLibrary_BoxDisplay(tempElement);
					addChild(newBoxDisplay);
					newBoxDisplay.y = (numChildren - 1) * 75;

				} else if (tempElement is Item) {
					var newItemDisplay: BoxLibrary_ItemDisplay = new BoxLibrary_ItemDisplay(tempElement);
					addChild(newItemDisplay);
					newItemDisplay.y = (numChildren - 1) * 75;
					
				} else if (tempElement is Tag) {
					var newTagDisplay: BoxLibrary_TagDisplay = new BoxLibrary_TagDisplay(tempElement);
					addChild(newTagDisplay);
					newTagDisplay.y = (numChildren - 1) * 75;
				}

			}
		}

	}

}