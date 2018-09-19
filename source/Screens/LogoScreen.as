package  {
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.text.TextField;
	
	
	public class LogoScreen extends MovieClip {
		
		//public var nativeCamera : NativeCamera;
		
		public var appDisplay:AppDisplay;
		
		public function LogoScreen(_appDisplay : AppDisplay) {
			// constructor code
			appDisplay = _appDisplay;
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage, false, 0, true);
		}
		
		public function onAddedToStage(e:Event) : void {
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
			
			//appDisplay.logoScreenToHomeScreen();
			
			//nativeCamera = new NativeCamera();
			//nativeCamera.requestAuthorization();
		}
		
		public function onRemovedFromStage(e:Event) : void {
			removeEventListener(MouseEvent.CLICK, onClick);
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage, false, 0, true);
		}
		
		public function onClick(mE:MouseEvent) {
			trace("\nCLICK FROM LOGO SCREEN");
			trace(mE.target);
			trace(mE);
			
			if (mE.target is LS_BeginButton) {
				appDisplay.logoScreenToHomeScreen();
			}
			
			mE.stopImmediatePropagation();
			 
		}
	}
	
}
