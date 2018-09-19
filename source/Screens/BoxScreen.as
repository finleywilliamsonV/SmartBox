package {

	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.display.MovieClip;
	import flash.text.TextField;

	//------------------------------------------------------------------------------ import Scroller
	import com.doitflash.consts.Orientation;
	import com.doitflash.consts.Easing;
	import com.doitflash.events.ScrollEvent;
	import com.doitflash.starling.utils.scroller.Scroller;
	import flash.geom.Point;
	import flash.display.Sprite;
	import flash.events.TouchEvent;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;


	public class BoxScreen extends MovieClip {


		// scroller variables
		private var _scroller: Scroller;
		private var _body: Sprite;
		private var _mask: Sprite;
		public static const MASK_WIDTH: Number = 750;
		public static const MASK_HEIGHT: Number = 934;
		private var _mouseOver: Boolean = false;
		private var _content: * ;

		// box screen variables
		public var appDisplay: AppDisplay;
		public var itemLibrary: ItemLibrary;
		public var box: Box;


		public function BoxScreen(_appDisplay: AppDisplay): void {
			// constructor code
			appDisplay = _appDisplay;

			itemLibrary = new ItemLibrary();
			//addChild(itemLibrary);
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}


		public function onAddedToStage(e: Event): void {
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			
			if (GlobalVariables.isMobile) {
				Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
				addEventListener(TouchEvent.TOUCH_TAP, onTap);
			} else {
				addEventListener(MouseEvent.CLICK, onClick);
			}
			
			if (!_body) _body = new Sprite();
			this.addChild(_body);

			setScroller();
			onResize();
		}

		public function onRemovedFromStage(e: Event): void {
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
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

		public function refresh(): void {
			setBox(box);
		}

		public function setBox(newBox: Box): void {
			reset();
			box = newBox;
			boxText.text = box.name.toUpperCase();
			itemLibrary.populateList(box);

			// resize box text
			if (boxText.text.length > 8) {

				boxText.text = boxText.text.substring(0, 8) + "...";
			}
		}

		public function reset(): void {
			box = null;
			if (itemLibrary) itemLibrary.reset();
		}


		private function setScroller(): void {
			// set the mask
			if (!_mask) _mask = new Sprite();
			_mask.y = 400;

			if (!_content) _content = itemLibrary;

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
			//_scroller.duration = .1;
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
			if (_mask) drawRect(_mask, 0x000000, 1, MASK_WIDTH, MASK_HEIGHT);

			if (_scroller) {
				_scroller.boundWidth = MASK_WIDTH;
				_scroller.boundHeight = MASK_HEIGHT;
			}

			if (_body && _scroller) {
				//_body.x = (stage.stageWidth / 2) - (_scroller.boundWidth / 2);
				//_body.y = (stage.stageHeight / 2) - (_scroller.boundHeight / 2);
			}
		}

		private function drawRect($target: * , $color: uint, $alpha: Number, $width: Number, $height: Number): void {
			$target.graphics.clear();
			//$target.graphics.lineStyle(5, 0x0000FF, .5, false);
			$target.graphics.beginFill($color, $alpha);
			$target.graphics.drawRect(0, 0, $width, $height);
			$target.graphics.endFill();
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
			
			trace("\nBoxScreen CLICK! - " + target);

			if (target is TextField && target != boxText) target = ItemLibrary_ItemDisplay(target.parent).item as Item;

			if (target is BackButton) {
				appDisplay.boxScreenToHomeScreen();
			} else if (target is BoxScreen_AddNewItem) {
				appDisplay.boxScreenToNewItemScreen(box);
			} else if (target is InfoButton) {
				appDisplay.boxScreenToBoxInfoScreen(box);
			} else if (target is Item) {
				appDisplay.boxScreenToItemInfoScreen(target);
			} else {
				trace(box.info);
			}
		}


	}

}