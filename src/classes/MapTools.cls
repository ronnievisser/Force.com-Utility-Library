// -----------------------------------------------------------------
// Provides mutliple tools that makes you live as a APEX developer easier
//
// @Name	MapTools
// @Author	Ronnie Visser <ronvisser@deloitte.nl>
// @Created	2013-04-14
// -----------------------------------------------------------------
public class MapTools {
	 // -----------------------------------------------------------------
	// Utility used in the next scenario's
	// Assume you have list of sObjects and you need to retrieve a Map of it with a specific key.
	// Just pass the sObject[] and the key you want 
	//
	// @Name	retrievesObjectMap
	// @Param	sObject[] objectRecordList
	// @Param	String keyValue
	// @Type  	Map<Id,sObject>
	// @return 	Map<Id,sObject>
	// -----------------------------------------------------------------
    public static Map<Id,sObject> retrievesObjectMap( sObject[] objectRecordList, String keyValue ) {
    	if( !objectRecordList.IsEmpty() ) {
    		Map<Id,sObject> sObjectMap = new Map<Id,sObject>();	
    		for( sObject so : objectRecordList ) {
    			String useValue = (String)so.get( keyValue );
    			if( useValue != null ) {
    				sObjectMap.put( useValue, so );	
    			}	
    		}
    		
    		if( !sObjectMap.IsEmpty() ) {
    			return sObjectMap;
    		}
    	}	
    	
    	return null;
    }
    
    // -----------------------------------------------------------------
	// Utility used in the next scenario's
	// Assume you have list of sObjects and you need to retrieve a Map with a list of sObjects grouped by a specific key.
	// Just pass the sObject[] and the key you want 
	//
	// @Name	retrievesObjectListMap
	// @Param	sObject[] objectRecordList
	// @Param	String keyValue
	// @Type  	Map<Id,sObject[]>
	// @return 	Map<Id,sObject[]>
	// -----------------------------------------------------------------
    public static Map<String,sObject[]> retrievesObjectListMap( sObject[] objectRecordList, String keyValue ) {
    	if( !objectRecordList.IsEmpty() ) {
    		Map<String,sObject[]> sObjectListMap = new Map<String,sObject[]>();	
    		for( sObject so : objectRecordList ) {
    			String useValue = (String)so.get( keyValue );
    			if( useValue != null ) {
	    			sObject[] items;	
	    			if( sObjectListMap.containsKey( useValue ) ) {
	    				items = sObjectListMap.get( useValue );
			    		items.add( so );
			    		sObjectListMap.put( useValue, items );	
	    			} else {
	    				items = new sObject[]{};
			    		items.add( so );	
			    		sObjectListMap.put( useValue, items );
		    		}
    			}
    		}
    		
    		return sObjectListMap;
    	}
    	
    	return null;
    }
}