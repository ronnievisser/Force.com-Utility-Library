// -----------------------------------------------------------------
// Provides mutliple tools that makes you live as a APEX developer easier
//
// @Name	ListUtil
// @Author	Ronnie Visser <r.visser@vivens.com>
// @Created	2013-03-15
// -----------------------------------------------------------------
global class ListUtil {
	
	// -----------------------------------------------------------------
	// Utility used in the next scenario's
	// Assume you have list of sObjects and you need to retrieve a list of related sObjects.
	// This happens a lot and you always have to add the value of the required field
	// in a seperate list which costs you a least 4 lines of extra code.
	//
	// This Utility does the same thing based on the list of sObjects and the required field name you pass 
	// 
	//
	// @Name	retrieveIdList
	// @Param	sObject[] objectRecordList
	// @Param	String fieldName
	// @Type  	Id[]
	// @return 	Id[]
	// -----------------------------------------------------------------
	public static String[] retrieveIdList( sObject[] objectRecordList, String fieldName ) {
		String[] idList = new String[]{};
		if( !objectRecordList.IsEmpty() ) {
			for( sObject so : objectRecordList ) {
				if( so.get( fieldName ) instanceof String ) {
					idList.add( (String)so.get( fieldName ) );
				}			
			}
		}
		return idList;
	}
	
	public static String[] retrieveFilteredIdList( sObject[] objectRecordList, String fieldNameFilter, String returnValue ) {
		String[] idList = new String[]{};
		if( !objectRecordList.IsEmpty() ) {
			for( sObject so : objectRecordList ) {
				if( so.get( fieldNameFilter ) != null && so.get( returnValue ) instanceof String ) {
					idList.add( (String)so.get( returnValue ) );
				}			
			}
		}
		return idList;
	}
	
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
		Map<Id,sObject> sObjectMap = new Map<Id,sObject>();
		if( !objectRecordList.IsEmpty() ) {
			for( sObject so : objectRecordList ) {
				Object useValue = so.get( keyValue );
				if( useValue instanceof String ) {
					sObjectMap.put( (String) useValue, so );	
				}	
			}
		}	
		return sObjectMap;
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
		Map<String,sObject[]> sObjectListMap = new Map<String,sObject[]>();
		if( !objectRecordList.IsEmpty() ) {
			for( sObject so : objectRecordList ) {
				Object oValue = so.get( keyValue );
				if( oValue instanceof String ) {
					String useValue = (String)oValue;
					sObject[] items = sObjectListMap.get( useValue );
					if( items == null ) {
						items = new sObject[]{};						
						sObjectListMap.put( useValue, items );
					}
					items.add( so );
				}
			}
			
		}
		return sObjectListMap;
	}
}
