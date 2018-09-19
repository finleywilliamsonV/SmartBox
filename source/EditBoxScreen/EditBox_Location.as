package  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	
	public class EditBox_Location extends MovieClip {
		
		public var parentScreen : EditBoxScreen;
		public var locationLibrary : LocationLibrary;
		
		public function EditBox_Location(_parentScreen:EditBoxScreen) {
			// constructor code
			parentScreen = _parentScreen;
			
			locationLibrary = new LocationLibrary(parentScreen.appData);
			addChild(locationLibrary);
			locationLibrary.x = 25;
			locationLibrary.y = 700;
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		public function onAddedToStage(e:Event) : void {
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			addEventListener(MouseEvent.CLICK, onClick);
		}
		
		public function onRemovedFromStage(e:Event) : void {
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			removeEventListener(MouseEvent.CLICK, onClick);
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		public function onClick(mE:MouseEvent) {
			trace("\nCLICK!");
			trace(mE.target);
			trace(mE);
			
			var target = mE.target;
			
			if (target is NextButton) {
				locationLibrary.locationSelected = locationLibrary.inputField.text;
				parentScreen.editedBoxLocation = locationLibrary.locationSelected;
				trace("LOCATION SET TO: " + locationLibrary.locationSelected);
				parentScreen.switchScreens(this, parentScreen.reviewScreen);
			} else if (target is ReturnButton) {
				parentScreen.switchScreens(this, parentScreen.nameScreen);
			} else if (target is ExitButton) {
				parentScreen.appDisplay.editBoxScreenToBoxScreen();
			}
		}
		
		public function setup(existingBox:Box) : void {
			locationLibrary.setup(existingBox);
			//locationLibrary.setSelected(existingBox.location);
		}
		
		public function reset():void {
			locationLibrary.reset();
		}
	}
	
}
