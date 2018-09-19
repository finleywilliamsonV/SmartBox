package {

	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldType;
	import flash.text.TextFormatAlign;
	//------------------------------------------------------------------------------ import Scroller
	import com.doitflash.consts.Orientation;
	import com.doitflash.consts.Easing;
	import com.doitflash.events.ScrollEvent;
	import com.doitflash.starling.utils.scroller.Scroller;
	import flash.geom.Point;
	import flash.events.TransformGestureEvent;
	import flash.events.TouchEvent;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import flash.events.FocusEvent;


	public class LocationLibrary extends MovieClip {

		public var appData: AppData;

		public static const LIBRARY_WIDTH = GlobalVariables.LOC_LIB_WIDTH;
		public static const LIBRARY_HEIGHT = GlobalVariables.LOC_LIB_HEIGHT;
		public static const BUFFER = GlobalVariables.LOC_LIB_BUFFER;

		// scroller variables
		private var _scroller: Scroller;
		private var _body: Sprite;
		private var _mask: Sprite;
		public var MASK_WIDTH: Number; // changed
		public var MASK_HEIGHT: Number; // changed
		private var _mouseOver: Boolean = false;
		private var _content: * ;


		public var locationArray: Array;
		public var locationObjectArray: Array;
		public var locationContainer: Sprite;
		public var locationPanel: Sprite;

		public var inputField: TextField;
		public var inputFormat: TextFormat;

		public var locationSelected: String;
		private var _inputFocus: Boolean = false;

		public function LocationLibrary(_appData: AppData = null) {

			// store app data reference
			appData = _appData;

			// text field & format
			inputFormat = new TextFormat();
			inputField = new TextField();

			inputFormat.font = "Raleway ExtraLight";
			inputFormat.size = GlobalVariables.LOC_LIB_TXT_L;
			inputFormat.leftMargin = 5;
			inputFormat.rightMargin = 5;
			inputFormat.align = TextFormatAlign.CENTER;

			inputField.defaultTextFormat = inputFormat;
			inputField.width = LIBRARY_WIDTH;
			inputField.height = inputFormat.size + BUFFER;
			inputField.type = TextFieldType.INPUT;
			inputField.background = true;
			inputField.border = true;
			inputField.multiline = false;
			inputField.wordWrap = false;

			addChild(inputField);

			// container
			locationContainer = new Sprite();
			locationContainer.graphics.beginFill(0xFFFFFF);
			locationContainer.graphics.drawRect(0, 0, LIBRARY_WIDTH, LIBRARY_HEIGHT);
			locationContainer.graphics.endFill();

			locationContainer.graphics.lineStyle(1, 0x000000);
			locationContainer.graphics.beginFill(0x000000, 0);
			locationContainer.graphics.drawRect(0, 0, LIBRARY_WIDTH, LIBRARY_HEIGHT);
			locationContainer.graphics.endFill();

			addChild(locationContainer);
			locationContainer.y += inputField.height + BUFFER;

			// location panel
			locationPanel = new Sprite();
			//addChild(locationPanel);
			//locationPanel.y += inputField.height + BUFFER;

			MASK_WIDTH = LIBRARY_WIDTH - 2;
			MASK_HEIGHT = LIBRARY_HEIGHT - 2;

			// constructor code
			locationArray = [];
			locationObjectArray = [];
			locationSelected = "";

			/*addTag("BAGELS");
			addTag("GOO");
			addTag("EGG SALAMI");
			addTag("CHAIR LUNCH DINNER");
			addTag("WORMS");
			addTag("REGULAR PEOPLE");
			addTag("GRAPES");
			addTag("LIGHTBULB CONTRACTS");*/

			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}

		public function onAddedToStage(e: Event): void {
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(MouseEvent.CLICK, onClick);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);

			if (GlobalVariables.isMobile) {
				Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
				addEventListener(TouchEvent.TOUCH_TAP, onTap);
			} else {
				addEventListener(MouseEvent.CLICK, onClick);
			}

			//populate(appData.locations);

			if (!_body) _body = new Sprite();
			this.addChild(_body);
			_body.x = 1;
			_body.y = inputField.height + BUFFER + 1;

			setScroller();
			onResize();
		}

		public function onRemovedFromStage(e: Event): void {
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			removeEventListener(MouseEvent.CLICK, onClick);
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);

			if (GlobalVariables.isMobile) {
				removeEventListener(TouchEvent.TOUCH_TAP, onTap);
			} else {
				removeEventListener(MouseEvent.CLICK, onClick);
			}

			_content.removeEventListener(MouseEvent.MOUSE_DOWN, onTouchDown);
			_content.removeEventListener(MouseEvent.MOUSE_MOVE, onTouchMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP, onTouchUp);

		}

		private function setScroller(): void {
			// set the mask
			if (!_mask) _mask = new Sprite();
			//_mask.y = tagContainer.y;

			if (!_content) _content = locationPanel;
			//trace(_content.x,_content.y,_content.width, _content.height);
			//_content.y = tagContainer.y + inputField.height;

			_content.mask = _mask;
			//_content.txt.autoSize = TextFieldAutoSize.LEFT;
			//_content.txt.addEventListener(Event.CHANGE, onTextChange);
			_content.addEventListener(MouseEvent.MOUSE_DOWN, onTouchDown);
			_content.addEventListener(MouseEvent.MOUSE_MOVE, onTouchMove);
			stage.addEventListener(MouseEvent.MOUSE_UP, onTouchUp);

			_body.addChild(_mask);
			_body.addChild(_content);

			//------------------------------------------------------------------------------ set Scroller
			if (!_scroller) _scroller = new Scroller();
			_scroller.content = _content; // you MUST set scroller content before doing anything else
			_scroller.orientation = Orientation.VERTICAL; // accepted values: Orientation.AUTO, Orientation.VERTICAL, Orientation.HORIZONTAL
			_scroller.easeType = Easing.Expo_easeOut;
			_scroller.duration = .1;
			_scroller.holdArea = 0;
			_scroller.isStickTouch = false;

			_scroller.yPerc = 0;
		}

		private function onTouchDown(e: MouseEvent): void {
			if (!_mouseOver) {
				var pos: Point = new Point(e.stageX, e.stageY);
				_scroller.startScroll(pos); // on touch begin and move
				_mouseOver = true;
			}
		}

		private function onTouchMove(e: MouseEvent): void {
			if (_mouseOver) {
				var pos: Point = new Point(e.stageX, e.stageY);
				_scroller.startScroll(pos); // on touch begin and move
			}

		}

		private function onTouchUp(e: MouseEvent): void {
			_scroller.fling(); // on touch ended
			_mouseOver = false;
		}

		private function onResize(e: *= null): void {

			trace("!!! ON RESIZE ");
			if (_mask) drawRect(_mask, 0x000000, 1, MASK_WIDTH, MASK_HEIGHT);

			if (_scroller) {
				_scroller.boundWidth = MASK_WIDTH;
				_scroller.boundHeight = MASK_HEIGHT - BUFFER - BUFFER;
			}

			if (_body && _scroller) {
				//_body.x = (stage.stageWidth / 2) - (_scroller.boundWidth / 2);
				//_body.y = (stage.stageHeight / 2) - (_scroller.boundHeight / 2);
				//_body.y = 100;
			}
		}

		private function drawRect($target: * , $color: uint, $alpha: Number, $width: Number, $height: Number): void {
			$target.graphics.clear();
			//$target.graphics.lineStyle(5, 0x0000FF, .5, false);
			$target.graphics.beginFill($color, $alpha);
			$target.graphics.drawRect(0, 0, $width, $height);
			$target.graphics.endFill();
		}

		public function reset(): void {
			locationPanel.removeChildren();
			//locationContainer.graphics.clear();
			locationArray = [];
			locationObjectArray = [];
			locationSelected = "";
		}

		public function setup(existingItem: * = null): void {

			if (existingItem) {
				inputField.text = existingItem.location;
				locationSelected = existingItem.location;
			} else {
				inputField.text = "New Location";
			}

			populate(appData.locations.concat(GlobalVariables.DEFAULT_LOCATIONS));
			
		}

		public function setSelected(thisLocation: String): void {

			if (locationArray.indexOf(thisLocation) > -1) {
				var locationIndex: int = locationArray.indexOf(thisLocation);
				var locationToSelect: LocationLibrary_Location = locationArray[locationIndex];
				locationToSelect.setSelected(true);
				inputField.text = thisLocation;
			}
		}

		public function destroy(): void {
			locationPanel.removeChildren();
			locationContainer.graphics.clear();
			locationArray = [];
			locationObjectArray = [];
			locationSelected = "";

			locationContainer = null;
			locationPanel = null;
			inputField = null;
			inputFormat = null;
		}

		public function populate(newLocations: Array = null): void {


			trace("\nLocationLibrary: populating");

			trace("newLocations: " + newLocations);

			if (newLocations) {
				locationArray = GlobalVariables.clone(newLocations) as Array;
			}

			locationPanel.removeChildren();
			locationObjectArray = [];

			var tempLocation: String;
			var tempLocationObject;

			// existing locations
			for (var i: int = 0; i < locationArray.length; i++) {
				tempLocation = locationArray[i];
				tempLocationObject = new LocationLibrary_Location(tempLocation);
				locationObjectArray.push(tempLocationObject);
				if (locationSelected == tempLocation) {
					trace("locationSelected: " + locationSelected);
					trace("tempLocation: " + tempLocation);
					tempLocationObject.setSelected(true);
				}
			}

			trace("Number of Locations: " + locationObjectArray.length);

			//locationObjectArray.push(newTagButton);
			trace(locationObjectArray.join(", "));

			var leadingEdgeWidth: int = 0;
			var leadingEdgeHeight: int = 0;

			var currentRow: int = 1;

			for (var j: int = 0; j < locationObjectArray.length; j++) {

				tempLocationObject = locationObjectArray[j];
				locationPanel.addChild(tempLocationObject);

				tempLocationObject.x = leadingEdgeWidth + BUFFER;
				tempLocationObject.y = leadingEdgeHeight + BUFFER;

				if (leadingEdgeWidth + tempLocationObject.width + BUFFER < locationContainer.width) { // if location fits
					leadingEdgeWidth += tempLocationObject.width + BUFFER;
				} else {
					leadingEdgeHeight += tempLocationObject.height + BUFFER;
					leadingEdgeWidth = 0;

					tempLocationObject.x = leadingEdgeWidth + BUFFER;
					tempLocationObject.y = leadingEdgeHeight + BUFFER;

					leadingEdgeWidth += tempLocationObject.width + BUFFER;
				}
				//leadingEdgeHeight += tempLocationObject.height;

			}
		}



		public function onTap(tE: TouchEvent) {
			tE.stopPropagation();
			onClick(null, tE.target);
		}
		
		public function onClick(mE: MouseEvent = null, tapTarget:* = null) {
			
			var target;
			if (tapTarget) {
				target = tapTarget;
			} else {
				target = mE.target;
				mE.stopPropagation();
			}
			
			trace("\nLocationLibrary CLICK! - " + target);

			// location library TEMPORARY
			if (target is TextField) {

				if (target == inputField) {

					if (!_inputFocus) {

						// handle selection clicks
						target.setSelection(0, target.getLineLength(0));
						_inputFocus = true;

						inputField.addEventListener(FocusEvent.FOCUS_OUT, onFocusOut, false, 0, true);
						trace("ADDED LISTENER");

						function onFocusOut(fE: FocusEvent): void {
							_inputFocus = false;
							inputField.removeEventListener(FocusEvent.FOCUS_OUT, onFocusOut);
							trace("REMOVED LISTENER");
						}
					}
						if (locationSelected != "") { // deselect location already selected
							var tempLocationObject: LocationLibrary_Location;
							for (var k: int = 0; k < locationObjectArray.length; k++) {
								tempLocationObject = locationObjectArray[k];
								if (tempLocationObject.locationText == locationSelected) {
									tempLocationObject.setSelected(false);
								}
							}
						}
						return;
				}

				if (target.parent is LocationLibrary_Location) {

					var currentLocation: LocationLibrary_Location = target.parent as LocationLibrary_Location;

					trace("\ncurrentLocation: " + currentLocation);

					if (currentLocation.toggleSelected()) {
						inputField.text = currentLocation.locationText;
						locationSelected = currentLocation.locationText;
						populate();
					} else {
						inputField.text = "";
						locationSelected = "";
						populate();
					}

				}
			}
		}


	} //end
}