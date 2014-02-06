/**
 * To implement the trigger functionaltiet you need to the following files
 * BaseTrigger.cls, ITrigger.cls, TriggerFactory.cls
 *
 *
 */

public abstract class BaseTrigger implements ITrigger {

	public BaseTrigger() {}
	
	// Start ITrigger Implementation //////////////////////////////////////////

	public virtual Boolean hasRun() { return false; }

	public virtual void bulkBefore() {}

	public virtual void bulkBeforeInsert() {}

	public virtual void bulkBeforeDelete() {}

	public virtual void bulkBeforeUpdate() {}

	public virtual void bulkAfter() {}

	public virtual void bulkAfterDelete() {}

	public virtual void bulkAfterUndelete() {}

	public virtual void bulkAfterUpdate() {}

	public virtual void bulkAfterInsert() {}

	public virtual void beforeInsert(SObject so) {}

	public virtual void beforeUpdate(SObject oldSo, SObject so) {}

	public virtual void beforeDelete(SObject so) {}

	public virtual void afterInsert(SObject so) {}

	public virtual void afterUpdate(SObject oldSo, SObject so) {}

	public virtual void afterDelete(SObject so) {}

	public virtual void afterUndelete(SObject so) {}

	public virtual void andFinally() {}
	
	// End ITrigger Implementation ////////////////////////////////////////////
}
