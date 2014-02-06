/**
 * Interface containing methods Trigger Handlers must implement to enforce best practice
 * and bulkification of triggers.
 */
public interface ITrigger
{
	/**
	 * hasRun
	 *
	 * This method is provided to be able to implement a so-called trigger-stopper: prevent the trigger from running if already ran because of an earlier update in the same context. 
	 */
	boolean hasRun();

	/**
	 * bulkBefore
	 *
	 * This method is called prior to execution of a BEFORE trigger. Use this to cache
	 * any data required into maps prior execution of the trigger.
	 */
	void bulkBefore();

	/**
	 * bulkBeforeInsert
	 *
	 * This method is called prior to execution of a BEFORE INSERT trigger. Use this to cache
	 * any data required into maps prior execution of the trigger.
	 */
	void bulkBeforeInsert();

	/**
	 * bulkBefore
	 *
	 * This method is called prior to execution of a BEFORE DELETE trigger. Use this to cache
	 * any data required into maps prior execution of the trigger.
	 */
	void bulkBeforeDelete();

	/**
	 * bulkBefore
	 *
	 * This method is called prior to execution of a BEFORE UPDATE trigger. Use this to cache
	 * any data required into maps prior execution of the trigger.
	 */
	void bulkBeforeUpdate();
	
	/**
	 * bulkAfter
	 *
	 * This method is called prior to execution of an AFTER trigger. Use this to cache
	 * any data required into maps prior execution of the trigger.
	 */
	void bulkAfter();

	/**
	 * bulkAfter
	 *
	 * This method is called prior to execution of an AFTER DELETE trigger. Use this to cache
	 * any data required into maps prior execution of the trigger.
	 */
	void bulkAfterDelete();

	/**
	 * bulkAfter
	 *
	 * This method is called prior to execution of an AFTER UNDELETE trigger. Use this to cache
	 * any data required into maps prior execution of the trigger.
	 */
	void bulkAfterUndelete();

	/**
	 * bulkAfter
	 *
	 * This method is called prior to execution of an AFTER UPDATE trigger. Use this to cache
	 * any data required into maps prior execution of the trigger.
	 */
	void bulkAfterUpdate();

	/**
	 * bulkAfter
	 *
	 * This method is called prior to execution of an AFTER INSERT trigger. Use this to cache
	 * any data required into maps prior execution of the trigger.
	 */
	void bulkAfterInsert();

	/**
	 * beforeInsert
	 *
	 * This method is called iteratively for each record to be inserted during a BEFORE
	 * trigger. Never execute any SOQL/SOSL etc in this and other iterative methods.
	 */
	void beforeInsert(SObject so);
	
	/**
	 * beforeUpdate
	 *
	 * This method is called iteratively for each record to be updated during a BEFORE
	 * trigger.
	 */
	void beforeUpdate(SObject oldSo, SObject so);

	/**
	 * beforeDelete
	 *
	 * This method is called iteratively for each record to be deleted during a BEFORE
	 * trigger.
	 */
	void beforeDelete(SObject so);

	/**
	 * afterInsert
	 *
	 * This method is called iteratively for each record inserted during an AFTER
	 * trigger. Always put field validation in the 'After' methods in case another trigger
	 * has modified any values. The record is 'read only' by this point.
	 */
	void afterInsert(SObject so);

	/**
	 * afterUpdate
	 *
	 * This method is called iteratively for each record updated during an AFTER
	 * trigger.
	 */
	void afterUpdate(SObject oldSo, SObject so);

	/**
	 * afterDelete
	 *
	 * This method is called iteratively for each record deleted during an AFTER
	 * trigger.
	 */
	void afterDelete(SObject so);

	/**
	 * afterUndelete
	 *
	 * This method is called iteratively for each record undeleted during an AFTER
	 * trigger.
	 */
	void afterUndelete(SObject so);

	/**
	 * andFinally
	 *
	 * This method is called once all records have been processed by the trigger. Use this 
	 * method to accomplish any final operations such as creation or updates of other records.
	 */
	void andFinally();
}
