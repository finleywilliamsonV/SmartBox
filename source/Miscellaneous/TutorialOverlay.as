package  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.display.Sprite;
	import flash.geom.ColorTransform;
	import flash.geom.Transform;
	
	
	/*
	
	
	- interaction with target triggers completion
	-> action taken
	-> 
	-> 
	-> 
	-> 
	-> 
	
	
	
	
	- tap through tutorial screens 
	-> action not taken
	-> 
	-> 
	-> 
	-> 
	-> 
	
	
	
	*/
	
	public class TutorialOverlay extends MovieClip {
		
		public var tutorialIndex : int;
		public var startFrame : int;
		public var clicksRemaining:int;
		
		public static const HS_ADD_FIRST_BOX : int = 0;
		public static const NBN_BOX_NAME_AND_PIC: int = 1;
		public static const NBL_INTRO_LOC_LIBRARY: int = 2;
		public static const NBR_REVIEW_BOX: int = 3;
		
		public function TutorialOverlay(_tutorialIndex:int) {
			// constructor code
			tutorialIndex = _tutorialIndex;
			startFrame = 0;
			clicksRemaining = 0;
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage, false, 0 , true);
		}
		
		public function onAddedToStage(e: Event): void {
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			setup();
			
			var invisibleMask : Sprite = new Sprite();
			invisibleMask.graphics.beginFill(0xFFFFFF,0);
			invisibleMask.graphics.drawRect(0,0,750,1334);
			addChild(invisibleMask);
		}
		
		
		public function setup() : void {

			if (!stage) throw new Error("ADD TUTORIAL_OVERLAY TO STAGE BEFORE CALLING SETUP()");
			
			// tutorial parameters
			
			if (tutorialIndex == 0) {	// HS_ADD_FIRST_BOX
				startFrame = 1;
				clicksRemaining = 1;
				
			} else if (tutorialIndex == 1) { // NBN_BOX_NAME_AND_PIC
				startFrame = 2;
				clicksRemaining = 2;
				
			} else if (tutorialIndex == 2) { // NBL_INTRO_LOC_LIBRARY
				startFrame = 4;
				clicksRemaining = 2;
				
			} else if (tutorialIndex == 3) { // NBR_REVIEW_BOX
				startFrame = 6;
				clicksRemaining = 4;
				
			} 
			
			gotoAndStop(startFrame);
			
			if (clicksRemaining > 0) {
				addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
				trace("TutorialOverlay: ADDED EVENT LISTENER, clicksRemaining @ " + clicksRemaining);
			}
		}
		
		public function onClick(mE:MouseEvent) : void {
			
			trace("CLICK FROM TUTORIAL OVERLAY");
			clicksRemaining--;
			
			if (clicksRemaining == 0) {
				removeEventListener(MouseEvent.CLICK, onClick);				
				var tutorialChecks : Array = GlobalVariables.instance.appData.tutorialChecks;
				tutorialChecks[tutorialIndex] = int(tutorialChecks[tutorialIndex] - 1);	// relies on this var being in all parent classes
				parent.removeChild(this);
				GlobalVariables.instance.appData.saveData();
			}
			
			gotoAndStop(currentFrame+1);
			
			mE.stopPropagation();
		}
	}
	
}
