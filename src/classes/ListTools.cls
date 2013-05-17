// -----------------------------------------------------------------
// Provides mutliple tools that makes you live as a APEX developer easier
//
// @Name	ListTools
// @Author	Ronnie Visser <ronvisser@deloitte.nl>
// @Created	2013-05-15
// -----------------------------------------------------------------
public class ListTools {
	
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
        if( !objectRecordList.IsEmpty() ) {
        	String[] idList = new String[]{};
        	for( sObject so : objectRecordList ) {
        		if( so.get( fieldName ) != null ) {
        			idList.add( (String)so.get( fieldName ) );
        		}			
        	}
        	
        	if( !idList.IsEmpty() ) {
        		return idList;
        	}
        }
        
        return null;
    }
    
    public static String[] retrieveFilteredIdList( sObject[] objectRecordList, String fieldNameFilter, String returnValue ) {
        if( !objectRecordList.IsEmpty() ) {
        	String[] idList = new String[]{};
        	for( sObject so : objectRecordList ) {
        		if( so.get( fieldNameFilter ) != null ) {
        			idList.add( (String)so.get( returnValue ) );
        		}			
        	}
        	
        	if( !idList.IsEmpty() ) {
        		return idList;
        	}
        }
        
        return null;
    }
}