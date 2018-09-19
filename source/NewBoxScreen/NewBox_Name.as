package {

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.events.FocusEvent;


	public class NewBox_Name extends MovieClip {

		public var parentScreen: NewBoxScreen;
		public var savedPhoto: Photo;
		private var _inputFocus: Boolean = false;
		

		public function NewBox_Name(_parentScreen: NewBoxScreen) {
			// constructor code
			parentScreen = _parentScreen;
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}

		public function onAddedToStage(e: Event): void {
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			addEventListener(MouseEvent.CLICK, onClick);
			
			// TUTORIAL CHECK - INTRO BOX NAME AND PIC - AUTO REMOVE
			var tutorialChecks : Array = GlobalVariables.instance.appData.tutorialChecks;
			var tutIndex : int = TutorialOverlay.NBN_BOX_NAME_AND_PIC;
			trace("\nNewBox_Name - tutorialChecks: " + tutorialChecks[tutIndex]);
			if (tutorialChecks[tutIndex] > 0) {
				addChild(new TutorialOverlay(tutIndex));
			}
		}

		public function onRemovedFromStage(e: Event): void {
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			removeEventListener(MouseEvent.CLICK, onClick);
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}

		public function onClick(mE: MouseEvent) {
			trace("\nCLICK!");
			trace(mE.target);
			trace(mE);

			var target = mE.target;

			if (target is NextButton) {
				parentScreen.newBoxName = nameText.text;
				trace("NAME SET TO: " + nameText.text);
				parentScreen.switchScreens(this, parentScreen.locationScreen);

			} else if (target == nameText) {

				if (!_inputFocus) {

					// handle selection clicks
					target.setSelection(0, target.getLineLength(0));
					_inputFocus = true;

					nameText.addEventListener(FocusEvent.FOCUS_OUT, onFocusOut, false, 0, true);

					function onFocusOut(fE: FocusEvent): void {
						_inputFocus = false;
						nameText.removeEventListener(FocusEvent.FOCUS_OUT, onFocusOut);
					}
				}

			} else if (target is AddPhotoButton) {
				addPhotoButton.takePicture();
			} else if (target is ReturnButton || target is ExitButton) {
				parentScreen.appDisplay.newBoxScreenToHomeScreen();
			}
		}

		public function setup(): void {
			nameText.text = "Box " + (GlobalVariables.instance.appData.boxes.length + 1);

			savedPhoto = parentScreen.newBoxPhoto;
			if (savedPhoto) {
				addChild(savedPhoto);
				savedPhoto.x = addPhotoButton.x;
				savedPhoto.y = addPhotoButton.y;
			}
		}

		public function storePhotoData(_photo: Photo): void {
			parentScreen.newBoxPhoto = _photo;
			savedPhoto = _photo;
			addChild(savedPhoto);
			savedPhoto.x = addPhotoButton.x;
			savedPhoto.y = addPhotoButton.y;
		}

		public function reset(): void {
			nameText.text = "";

			if (savedPhoto && savedPhoto.parent == this) {
				removeChild(savedPhoto);
			}
			savedPhoto = null;
		}
	}

}