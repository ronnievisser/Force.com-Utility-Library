public class URLTools {
		
	public static String getParam( String key ) {
		if( ApexPages.currentPage().getParameters().containsKey( key ) )
			return ApexPages.currentPage().getParameters().get( key ); 
		return null;
	}
	
	public static Boolean getParamContains( String key ) {
		return ApexPages.currentPage().getParameters().containsKey( key );	
	}
	
	public static void putParam( system.PageReference PageRef, String key, String value ) {
		 PageRef.getParameters().put( key, value );	
	}
}