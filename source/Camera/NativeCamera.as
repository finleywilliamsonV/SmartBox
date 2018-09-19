package {

	import com.distriqt.extension.cameraui.AuthorisationStatus;
	import com.distriqt.extension.cameraui.CameraUI;
	import com.distriqt.extension.cameraui.CameraUIOptions;
	import com.distriqt.extension.cameraui.QualityType;
	import com.distriqt.extension.cameraui.events.CameraUIEvent;
	import com.distriqt.extension.cameraui.MediaType;
	import com.distriqt.extension.cameraui.events.AuthorisationEvent;
	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.events.IOErrorEvent;
	import flash.events.Event;


	public class NativeCamera {

		private static var _instance: NativeCamera;
		private static var _allowInstantiation: Boolean;

		public static const APP_KEY: String = "d63895081bf4c9ffef2fad886c6e27ec545dd417WXbq9Ee5S8iMWL0NYOzprZuiZKOm2De6dodZgkiR584w4SsOvsS2WfV8ENQESXbNsvNQB+c18KBtEAVAnKM+M0kbmCGGCTLpfVtWinVP1RS2Xxwd+W2EbBBu+RcWSN0dBm3tQirx2XQOaQodkWCFOgz0C7PVxZRUFdPIB1Pj5lpdTI4orSrfjSwzCD99gGYs4HTuwr2KDd3FztCmDczKfQn5tX885LfxHWpUJLkT7GjXboS+G0psd94XkzvpeL+dPEt0Dxq2DLVUWvqIbpgS6pq7P0WS1l2tdmx6/p3A3OhbCBz551wg9VBqI6jwqliLaE0VizaWsnfCgWOHAZgACg==";

		private var l: Loader;
		private var imageRequest: * ; // class requesting image
		private var filePath:String;

		public static function get instance(): NativeCamera {
			if (!_instance) {
				_allowInstantiation = true;
				_instance = new NativeCamera();
				_allowInstantiation = false;

				// Check Camera
				try {
					CameraUI.init(APP_KEY);
					trace("\nCameraUI Supported: " + CameraUI.isSupported);
					trace("CameraUI Version:   " + CameraUI.service.version);
					CameraUI.service.addEventListener(CameraUIEvent.COMPLETE, _instance.cameraUI_completeHandler);
					CameraUI.service.addEventListener(CameraUIEvent.CANCEL, _instance.cameraUI_cancelHandler);
				} catch (e: Error) {
					trace("CameraUI: ERROR::" + e.trace);
				}
			}

			return _instance;
		}

		public function requestAuthorization(): void {
			CameraUI.service.requestAuthorisation();
		}

		public function activate(_requestingClass: * ): void {

			imageRequest = _requestingClass;

			if (CameraUI.isSupported) {
				if (CameraUI.service.hasAuthorisation()) {
					trace("\nCameraUI: has authorisation already");
					launchCamera();
				} else {

					trace("\nCameraUI: check authorisation");
					CameraUI.service.addEventListener(AuthorisationEvent.CHANGED, authorisationStatus_changedHandler);

					trace(CameraUI.service.authorisationStatus());
					switch (CameraUI.service.authorisationStatus()) {
						case AuthorisationStatus.SHOULD_EXPLAIN:
						case AuthorisationStatus.NOT_DETERMINED:
							// REQUEST ACCESS: This will display the permission dialog
							CameraUI.service.requestAuthorisation();
							return;

						case AuthorisationStatus.DENIED:
						case AuthorisationStatus.UNKNOWN:
						case AuthorisationStatus.RESTRICTED:
							// ACCESS DENIED: You should inform your user appropriately
							return;

						case AuthorisationStatus.AUTHORISED:
							// AUTHORISED: Camera will be available
							break;
					}
				}
			}
		}

		public function NativeCamera() {
			if (!_allowInstantiation) {
				throw new Error("ERROR: STOP IT FOOL, DON'T INITIALIZE!!");
			}
		}

		private function authorisationStatus_changedHandler(event: AuthorisationEvent): void {

			trace("\nCameraUI: authorisation status changed: " + event.status);

			if (event.status == "authorised") {

				trace("\nCameraUI: AUTHORIZATION COMPLETE");
				CameraUI.service.removeEventListener(AuthorisationEvent.CHANGED, authorisationStatus_changedHandler);
				launchCamera();
			}
		}

		public function launchCamera(): void {

			trace("\nCameraUI: setting options");

			var options: CameraUIOptions = new CameraUIOptions();

			options.device = CameraUIOptions.DEVICE_BACK;

			options.videoQuality = QualityType.TYPE_LOW;
			options.saveFilesInCache = false;
			options.saveToCameraRoll = false;

			trace("\nCameraUI: launching camera");

			CameraUI.service.launch(MediaType.IMAGE, options);
		}


		private function cameraUI_completeHandler(event: CameraUIEvent): void {
			trace("\nCameraUI: UI complete - " + event.path);

			//
			// Here you can use the event.path to access the media file as you require

			// Display the captured image
			if (l) {
				l.unload();
			}
			l = new Loader();
			l.contentLoaderInfo.addEventListener(Event.COMPLETE, onImageLoaded, false, 0, true);
			l.addEventListener(IOErrorEvent.IO_ERROR, errorHandlerIOErrorEventHandler, false, 0, true);
			l.load(new URLRequest(event.path));
			
			filePath = event.path;
			
			//imageRequest.receiveImage(l as Sprite);
		}


		private function onImageLoaded(e: Event): void {
			trace("\nCameraUI: image loaded");

			//l.scaleX = 1334 / l.width;
			//l.scaleY = l.scaleX;
			//l.rotation = 90;
			//l.x = l.width;

			trace("\nCameraUI: image paramters -");
			trace("(" + l.x + "," + l.y + ")");
			trace("width: " + l.width);
			trace("height: " + l.height);
			
			imageRequest.receiveImage(new Photo(l, filePath));
		}

		private function errorHandlerIOErrorEventHandler(ioE: IOErrorEvent): void {

		}

		private function cameraUI_cancelHandler(event: CameraUIEvent): void {
			trace("\nCameraUI: UI cancelled");

			trace("\nCameraUI: Loader Info - ");
			trace("(" + l.x + "," + l.y + ")");
			trace("Width: " + l.width);
			trace("Height: " + l.height);
		}

	}

}