public class ListUtil {
	
	
	public static Id[] retrieveIdList( sObject[] objectRecordList, String fieldName ) {
        if( !objectRecordList.IsEmpty() ) {
        	Id[] idList = new Id[]{};
        	for( sObject so : objectRecordList ) {
        		if( (Id)so.get( fieldName ) != null ) {
        			idList.add( (Id)so.get( fieldName ) );
        		}			
        	}
        	
        	return idList;
        }
        
        return null;
       
    }
}