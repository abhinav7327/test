/*

$LastChangedDate$
$Author: sanjoys $
*/


 
package com.nri.rui.core.controls {
    import flash.events.*;
    import flash.net.FileReference;
    import flash.net.URLRequest;
    
    import mx.controls.Button;
    import mx.controls.ProgressBar;
    import mx.core.UIComponent;
    import mx.utils.StringUtil;

    [Event(name="onIOError", type="flash.events.IOErrorEvent")]
    /**
     * This class provides the necessary functionalities for downloading a file 
     * from server side by the specified URL.
     * 
     */
    public class FileDownload extends UIComponent {
        //The FileReference Object
        private var fr:FileReference;
        // Define reference to the download ProgressBar component.
        private var pb:ProgressBar;
        // Define reference to the "Cancel" button which will immediately stop the download in progress.
        private var btn:Button;
        //The url from where the file will be downloaded
        private var _downloadUrl:String;
        //The fileame will be displayed at the time of downloading the file.
        private var _downloadFileName:String = new String("FileName");		

        public function FileDownload() {
            
        }
        public function get downloadUrl():String
		{
			return _downloadUrl;
		}
        public function set downloadUrl(downloadUrl:String):void
		{
			_downloadUrl = downloadUrl;
		}
        public function get downloadFileName():String
		{
			return _downloadFileName;
		}
        public function set downloadFileName(downloadFileName:String):void
		{
			_downloadFileName = downloadFileName;
		}
        /**
         * Set references to the components, and add listeners for the OPEN, 
         * PROGRESS, and COMPLETE events.
         */
        public function init(pb:ProgressBar, btn:Button):void {
            // Set up the references to the progress bar and cancel button, which are passed from the calling script.
            this.pb = pb;
            this.btn = btn;

            fr = new FileReference();
        }

        /**
         * Immediately cancel the download in progress and disable the cancel button.
         */
        public function cancelDownload():void {
            fr.cancel();
            pb.label = "DOWNLOAD CANCELLED";
            btn.enabled = false;
        }

        /**
         * Begin downloading the file specified in the DOWNLOAD_URL constant.
         */
        public function startDownload():void {
            var request:URLRequest = new URLRequest();
            request.method = "POST";
            if(_downloadUrl != null && !StringUtil.isWhitespace(_downloadUrl)){
                request.url = StringUtil.trim(_downloadUrl) + "&rnd=" + Math.random();
                //Add the event listeners
                fr.addEventListener(Event.OPEN, openHandler);
                fr.addEventListener(ProgressEvent.PROGRESS, progressHandler);
                fr.addEventListener(Event.COMPLETE, completeHandler);
                fr.addEventListener(IOErrorEvent.IO_ERROR, onDownloadIoError);
    		    fr.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onDownloadSecurityError);
            } else {
                XenosAlert.error("Request URL couldn't found");
                return;
            }
            fr.download(request,_downloadFileName);
        }

        /**
         * When the OPEN event has dispatched, change the progress bar's label 
         * and enable the "Cancel" button, which allows the user to abort the 
         * download operation.
         */
        private function openHandler(event:Event):void {
            pb.label = "DOWNLOADING %3%%";
            btn.enabled = true;
        }
        
        /**
         * While the file is downloading, update the progress bar's status and label.
         */
        private function progressHandler(event:ProgressEvent):void {
            pb.setProgress(event.bytesLoaded, event.bytesTotal);
        }

        /**
         * Once the download has completed, change the progress bar's label and 
         * disable the "Cancel" button since the download is already completed.
         */
        private function completeHandler(event:Event):void {
            pb.label = "DOWNLOAD COMPLETE";
            pb.setProgress(0, 100);
            btn.enabled = false;
            clearListener();
        }
        // Called on upload io error
		private function onDownloadIoError(event:IOErrorEvent):void {
			//check I/O Error due to session expiry
			var httpreq:XenosHTTPService=new XenosHTTPService();
			httpreq.url=_downloadUrl;
			httpreq.send();	
			
			var evt:IOErrorEvent = new IOErrorEvent("onIOError", false, false, event.text);
			dispatchEvent(evt);
			
			btn.enabled = false;
			clearListener();
		}
		// Called on upload security error
		private function onDownloadSecurityError(event:SecurityErrorEvent):void {
			XenosAlert.error("Error Occurred: " + event.text);
			btn.enabled = false;
			clearListener();
		}
		/**
		 * Remove the registered event Listeners
		 */
		private function clearListener():void{
		    fr.removeEventListener(Event.OPEN, openHandler);
            fr.removeEventListener(ProgressEvent.PROGRESS, progressHandler);
            fr.removeEventListener(Event.COMPLETE, completeHandler);
            fr.removeEventListener(IOErrorEvent.IO_ERROR, onDownloadIoError);
		    fr.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onDownloadSecurityError);
		    fr.cancel();
		}
    }
}