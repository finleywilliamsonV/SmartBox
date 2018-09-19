package  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	
	public class NewBox_Location extends MovieClip {
		
		public var parentScreen : NewBoxScreen;
		public var locationLibrary : LocationLibrary;
		
		public function NewBox_Location(_parentScreen:NewBoxScreen) {
			// constructor code
			parentScreen = _parentScreen;
			
			locationLibrary = new LocationLibrary(parentScreen.appData);
			addChild(locationLibrary);
			locationLibrary.x = 25;
			locationLibrary.y = 400;
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		public function onAddedToStage(e:Event) : void {
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			addEventListener(MouseEvent.CLICK, onClick);
			

			// TUTORIAL CHECK - Intro Location Library
			var tutorialChecks : Array = GlobalVariables.instance.appData.tutorialChecks;
			var tutIndex : int = TutorialOverlay.NBL_INTRO_LOC_LIBRARY;
			trace("\nNewBox_Location - tutorialChecks: " + tutorialChecks[tutIndex]);
			if (tutorialChecks[tutIndex] > 0) {
				addChild(new TutorialOverlay(tutIndex));
			}
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
				parentScreen.newBoxLocation = locationLibrary.locationSelected;
				trace("LOCATION SET TO: " + locationLibrary.locationSelected);
				parentScreen.switchScreens(this, parentScreen.reviewScreen);
					
			} else if (target is ReturnButton) {
				parentScreen.switchScreens(this, parentScreen.nameScreen);
			} else if (target is ExitButton) {
				parentScreen.appDisplay.newBoxScreenToHomeScreen();
			}
		}
		
		public function setup() : void {
			
			locationLibrary.setup();
		}
		
		public function reset():void {
			locationLibrary.reset();
		}
	}
	
}
