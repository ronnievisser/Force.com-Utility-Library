/** Wrapper for system.debug(loglevel, msg) methods */
public class Logger {

	/** Logs a message at debug level */
	public static void debug( String msg ) {
		log( System.Logginglevel.DEBUG, msg );
	}
	/** Logs a message at info level */
	public static void info( String msg ) {
		log( System.Logginglevel.INFO, msg );
	}
	/** Logs a message at error level */
	public static void error( String msg ) {
		log( System.Logginglevel.ERROR, msg );
	}
	public static void log( System.LoggingLevel level, String msg ) {
		system.debug( level, msg );
	}
}
