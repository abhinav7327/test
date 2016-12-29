// ActionScript file containg all the sort functions of the columns oof the Advanced DataGrid

/**
 * Comparator method for sorting Numeric fields.
 */
public  function sortNumeric(obj1:String,obj2:String):int {                
    var dataFormatter:NumberBase = new NumberBase(".",",",".",",");
           
      var text1:String= obj1;  
    var text2:String= obj2; 
    
      if(text1==null && text2==null)
          return 0;
      else if(text1==null && text2!=null)
          return -1;
      else if(text1!=null && text2==null)
          return 1;
      else
      {                      
        var valueA:Number = Number(dataFormatter.parseNumberString(text1));
        var valueB:Number = Number(dataFormatter.parseNumberString(text2));                
        return ObjectUtil.numericCompare(valueA, valueB);   
    }            
}

/**
 * Comparator method for sorting String fields.
 */    
public function sortString(obj1:String, obj2:String):int {
    //sorting should be based on labelFunction if any 
    var text1:String=obj1;  
    var text2:String=obj2; 
//    trace(text1+"  : "+text2); 
    if(text1==null && text2==null)
          return 0;
      else if(text1==null && text2!=null)
          return -1;
      else if(text1!=null && text2==null)
          return 1;
      else                              
        return ObjectUtil.stringCompare(text1,text2);
}

/**
 * Comparator method for sorting messageType column.
 */    
public function sortMessageType(obj1:Object, obj2:Object):int {
    var text1:String=obj1.messageType;  
    var text2:String=obj2.messageType; 
    //trace(" "+text1+"  : "+text2); 
    return sortString(text1,text2);
}
/**
 * Comparator method for sorting messageType column.
 */    
public function sortGroupId(obj1:Object, obj2:Object):int {
    var text1:String=obj1.groupId;  
    var text2:String=obj2.groupId; 
    //trace(" "+text1+"  : "+text2); 
    return sortString(text1,text2);
}
/**
 * Comparator method for sorting errorMessage column.
 */    
public function sortErrorMessage(obj1:Object, obj2:Object):int {
    var text1:String=obj1.errorMessage;  
    var text2:String=obj2.errorMessage; 
    //trace(text1+"  : "+text2); 
    return sortString(text1,text2);
}
/**
 * Comparator method for sorting remarks column.
 */    
public function sortRemarks(obj1:Object, obj2:Object):int {
    var text1:String=obj1.remarks;  
    var text2:String=obj2.remarks; 
    //trace(" "+text1+"  : "+text2); 
    return sortString(text1,text2);
}
/**
 * Comparator method for sorting errorCode column.
 */    
public function sortErrorCode(obj1:Object, obj2:Object):int {
    var text1:String=obj1.errorCode;  
    var text2:String=obj2.errorCode;            
    return sortString(text1,text2);                         
}
/**
 * Comparator method for sorting referenceNumber column.
 */
public function sortReferenceNumber(obj1:Object, obj2:Object):int {
    var text1:String=obj1.referenceNumber;  
    var text2:String=obj2.referenceNumber;            
    return sortString(text1,text2);                         
}
/**
 * Comparator method for sorting fundCode column.
 */
public function sortFundCode(obj1:Object, obj2:Object):int {
    var text1:String=obj1.fundCode;  
    var text2:String=obj2.fundCode;            
    return sortString(text1,text2);                         
}
/**
 * Comparator method for sorting accountNo column.
 */
public function sortAccountNo(obj1:Object, obj2:Object):int {
    var text1:String=obj1.accountNo;  
    var text2:String=obj2.accountNo;            
    return sortString(text1,text2);                         
}
/**
 * Comparator method for sorting securityCode column.
 */
public function sortSecurityCode(obj1:Object, obj2:Object):int {
    var text1:String=obj1.securityCode;  
    var text2:String=obj2.securityCode;            
    return sortString(text1,text2);                         
}
/**
 * Comparator method for sorting sourceComponent column.
 */
public function sortSourceComponent(obj1:Object, obj2:Object):int {
    var text1:String=obj1.sourceComponent;  
    var text2:String=obj2.sourceComponent;            
    return sortString(text1,text2);                         
}
/**
 * Comparator method for sorting recipientComponent column.
 */
public function sortRecipientComponent(obj1:Object, obj2:Object):int {
    var text1:String=obj1.recipientComponent;  
    var text2:String=obj2.recipientComponent;            
    return sortString(text1,text2);                         
}
/**
 * Comparator method for sorting dataSource column.
 */
public function sortDataSource(obj1:Object, obj2:Object):int {
    var text1:String=obj1.dataSource;  
    var text2:String=obj2.dataSource;            
    return sortString(text1,text2);                         
}
/**
 * Comparator method for sorting creationTime column.
 */
public function sortCreationTime(obj1:Object, obj2:Object):int {
    var text1:String=obj1.creationTime;  
    var text2:String=obj2.creationTime;            
    return sortString(text1,text2);                         
}
/**
 * Comparator method for sorting userComment column.
 */
public function sortUserComment(obj1:Object, obj2:Object):int {
    var text1:String=obj1.userComment;  
    var text2:String=obj2.userComment;            
    return sortString(text1,text2);                         
}
/**
 * Comparator method for sorting remarksEnterBy column.
 */
public function sortRemarksEnterBy(obj1:Object, obj2:Object):int {
    var text1:String=obj1.remarksEnterBy;  
    var text2:String=obj2.remarksEnterBy;            
    return sortString(text1,text2);                         
}
/**
 * Comparator method for sorting assignOffice column.
 */
public function sortAssignOffice(obj1:Object, obj2:Object):int {
    var text1:String=obj1.assignOffice;  
    var text2:String=obj2.assignOffice;            
    return sortString(text1,text2);                         
}
/**
 * Comparator method for sorting assignTo column.
 */
public function sortAssignTo(obj1:Object, obj2:Object):int {
    var text1:String=obj1.assignTo;  
    var text2:String=obj2.assignTo;            
    return sortString(text1,text2);                         
}
/**
 * Comparator method for sorting errorNumber column.
 */
public function sortErrorNumber(obj1:Object, obj2:Object):int {
    var text1:String=obj1.errorNumber;  
    var text2:String=obj2.errorNumber;            
    return sortNumeric(text1,text2);                         
}
/**
 * Comparator method for sorting age column.
 */
public function sortAge(obj1:Object, obj2:Object):int {
    var text1:String=obj1.age;  
    var text2:String=obj2.age;            
    return sortNumeric(text1,text2);                         
}
/**
 * Comparator method for sorting creationDate column.
 */    
public function sortCreationDate(obj1:Object, obj2:Object):int {
    var text1:String=obj1.creationDate;  
    var text2:String=obj2.creationDate; 
    //trace(" "+text1+"  : "+text2); 
    return sortString(text1,text2);
}