    
        import com.nri.rui.core.controls.XenosAlert;
        
        import mx.collections.ArrayCollection;
        import mx.events.ResourceEvent;
        import mx.resources.ResourceBundle;
        
        [Bindable]
        private var ownershipList:ArrayCollection= new ArrayCollection();
        [Bindable]
        private var locationList:ArrayCollection= new ArrayCollection();
        [Bindable]
        private var xmlObj:XML = new XML(); 
        [Bindable]
        public var ownerBalance:String=null;
        [Bindable]
        public var locationBalance:String=null;
       
       /**
        * This is called at creationComplete of the module
        */
         private function loadAll():void {
            initPage();
         }
         
        /**
         * Init method of the creation of the entitlement view detail  
         * 
         */
        private function initPage():void {
            
            var dataObj :Object = this.parentDocument.dataObj;          
            var i:int = 0;
            var rec1:XML = new XML();
            var rec2:XML = new XML();
            
            //fecthing the ownership list
            var initColl:ArrayCollection = new ArrayCollection();
            if(dataObj.camRightsDetailVO != null) { 
                initColl.removeAll();
                for each (rec1 in dataObj.camRightsDetailVO.camRightsDetailVOItem) {
                    initColl.addItem(rec1);
                }   
            }  
            ownershipList = new ArrayCollection();
            for(i = 0; i<initColl.length; i++) {
                ownershipList.addItem(initColl[i]);    
            }                    
            
            //fecthing the location list
            var tempColl:ArrayCollection = new ArrayCollection();
            if(dataObj.ncmRightsDetailVO != null) { 
                tempColl.removeAll();
                for each (rec2 in dataObj.ncmRightsDetailVO.ncmRightsDetailVOItem) {
                    tempColl.addItem(rec2);
                }   
            }           
            locationList = new ArrayCollection();
            for(i = 0; i<tempColl.length; i++) {
                locationList.addItem(tempColl[i]);    
            }   
            
            // setting fund account,security name,ownership total balance and location total balance 
            fundCode.text = "Fund Code :"+dataObj.fundCode;
            securityName.text = "Security Name :"+dataObj.securityName;         
            ownerBalance = dataObj.ownershipSecurityBalanceStr;
            locationBalance = dataObj.locationSecurityBalanceStr;
        }