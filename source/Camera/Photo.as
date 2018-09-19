package  {
	import flash.display.MovieClip;
	import flash.display.Loader;
	
	public class Photo extends MovieClip {

		public var photoData : Loader;
		public var filePath : String;
		
		public function Photo(_mediaLoader:Loader = null, _filePath:String = "") {
			// constructor code
			super();
			photoData = _mediaLoader;
			
			filePath = _filePath;
			
			trace("\n NEW PHOTO");
			trace(" 	+	+	+	+	+	File Path: " + filePath);
			trace(" 	+	+	+	+	+	photoData.height: " + photoData.height);
			trace(" 	+	+	+	+	+	photoData.width: " + photoData.width);
			trace(" 	+	+	+	+	+	photoData size(kB): " + photoData.contentLoaderInfo.bytesTotal/1024/1024);
			trace(" 	+	+	+	+	+	");
			
			var h1 : Number = photoData.height;
			var w1 : Number = photoData.width;
			
			if (photoData.width < photoData.height) {	// vertical
				photoData.width = width;
				
				photoData.height = (photoData.width*h1)/w1;
				
			} else {									// horizontal
		
				photoData.height = height;
				
				photoData.width = (photoData.height*w1)/h1;
				
			}
			addChild(photoData);
			
			trace(" 	+	+	+	+	+	photoData.height: " + photoData.height);
			trace(" 	+	+	+	+	+	photoData.width: " + photoData.width);

			photoData.rotation = 90;
			photoData.x = photoData.width;
			
			photoData.mask = photoMask;
		}
		
		public function destroy() : void {
			photoData.unload();
			photoData = null;
		}

	}
	
}
