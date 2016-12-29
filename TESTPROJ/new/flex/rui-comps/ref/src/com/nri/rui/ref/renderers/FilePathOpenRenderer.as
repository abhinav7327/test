
package com.nri.rui.ref.renderers
{
    import com.nri.rui.core.Globals;
    
    import flash.events.MouseEvent;
    import flash.net.URLRequest;
    import flash.net.navigateToURL;
    
    import mx.controls.Text;
    import mx.utils.StringUtil;

        
    public class FilePathOpenRenderer extends Text
    {
        public function FilePathOpenRenderer()
        {
            super();
            //addEventListener(MouseEvent.CLICK, handleMouseClick);
        }

        override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
             super.updateDisplayList(unscaledWidth, unscaledHeight);
                /* if(listData){
                    var dg : DataGrid = DataGrid(listData.owner);
                    var column : DataGridColumn = dg.columns[listData.columnIndex];
                    text = data[column.dataField];
                }
             visible = (StringUtil.trim(text) == Globals.EMPTY_STRING ) ? false :true;
             //To show the underline with hand cursor
             buttonMode = true;
             useHandCursor = true;
             mouseChildren = false;
             
             setStyle("color", 0x007ac8);
             setStyle("textDecoration", "underline"); */
        }
        
        override public function set data(value:Object):void{
            super.data = value;
            //visible = (StringUtil.trim(text) == Globals.EMPTY_STRING ) ? false :true;
            setVisibleProp();
        }
        
        private function setVisibleProp():void{
            
            var visibleFlag : Boolean = (StringUtil.trim(text) == Globals.EMPTY_STRING ) ? false :true;
            buttonMode = visibleFlag;
            useHandCursor = visibleFlag;
            mouseChildren = !visibleFlag;
            if(visibleFlag){
                setStyle("color",0x007ac8);
                setStyle("textDecoration","underline");
                addEventListener(MouseEvent.CLICK, handleMouseClick);
            }
            else{
                if(hasEventListener(MouseEvent.CLICK))
                    removeEventListener(MouseEvent.CLICK,handleMouseClick);
                setStyle("color",0x000000);
                setStyle("textDecoration","normal");
                //removeEventListener(MouseEvent.CLICK,handleMouseClick);
            }
            
        }
        
        public function handleMouseClick(event:MouseEvent):void {
            var dispFileName : String = ""; // The file name to be displayed
            if(text != null){
                var startIndx:int = text.lastIndexOf("/");
                if(startIndx >= 0){
                    dispFileName = text.substr(startIndx+1);
                }else{
                    dispFileName = text;
                }
            }            
            var str:String="download/"+dispFileName+"?path=" + text + "&type=download";            
            var jscommand:String = "window.open('"+str+"','win','toolbar=no,scrollbars=no,resizable=1');";
            //trace(jscommand);
            var url:URLRequest = new URLRequest("javascript:" + jscommand + " void(0);");
            url.method = "POST";
            navigateToURL(url, "_self");

            /*var url : String = "download/?path="+text+"&type=download";
            var request:URLRequest = new URLRequest(url);
            request.method = URLRequestMethod.POST;
             try {
                    navigateToURL(request,"_blank");
                }
                catch (e:Error) {
                    // handle error here
                    trace(e);
                }*/

        }
        

    }

}