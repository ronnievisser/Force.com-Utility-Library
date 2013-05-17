public class TriggerTools {
	/** 
	 * TRIGGER STOPPER
	**/
	private static boolean alreadyRun = false;
	
	public static boolean hasAlreadyRun() {
		return alreadyRun;
	}

	public static void setAlreadyRun() {
		alreadyRun = true;
	}
}