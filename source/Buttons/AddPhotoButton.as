package {

	import flash.display.MovieClip;
	import flash.media.Camera;
	import flash.media.CameraRoll;
	import flash.media.CameraUI;
	import flash.media.Video;
	import flash.events.MediaEvent;
	import flash.events.Event;
	import flash.events.ErrorEvent;
	import flash.media.MediaType;
	import flash.events.PermissionEvent;
	import flash.permissions.PermissionStatus;
	import flash.media.MediaPromise;
	import flash.events.IEventDispatcher;
	import flash.display.Loader;
	import flash.utils.IDataInput;
	import flash.utils.ByteArray;
	import flash.events.HTTPStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.filesystem.File;
	import flash.filesystem.FileStream;
	import flash.filesystem.FileMode;
	import flash.display.JPEGEncoderOptions;
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.display.Bitmap;


	public class AddPhotoButton extends MovieClip {

		public var photo: Photo;

		private var _parent: * ;

		public function AddPhotoButton() {
			// constructor code
			_parent = parent;
		}
				
		public function takePicture(): void {
			NativeCamera.instance.activate(this);
		}
		
		public function receiveImage(image:Photo):void {
			photo = image;
			storePhotoData();
		}

		private function storePhotoData(): void {
			trace("store Photo data");
			_parent.storePhotoData(photo);
		}

	}
}