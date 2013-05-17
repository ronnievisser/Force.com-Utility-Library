public class SObjectTools {
	
	/**
	 * Retrieves the sobject-type for the passed string which represents an id of a salesforce object.
	 * Ids uniquely identify the sobject via the first 3 characters of the id, the socalled key prefix.
	 *
	 * Note: when no sobjecttype for the id can be found or the id has less than 3 characters, 
	 * the value null is returned.
	 */
	public static Schema.SObjectType getSObjectType( String id ) {
		try {
			return ( (Id)id ).getSObjectType();
		} catch ( Exception e ) {
			return null;
		}
	}
}