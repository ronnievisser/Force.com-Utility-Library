/**
 * Class TriggerFactory
 *
 * Used to instantiate and execute Trigger Handlers associated with sObjects.
 */
public class TriggerFactory
{
	
	/**
	 * public static method to control the execution of the handler
	 *
	 * Arguments:   ITrigger handler - A Trigger Handler to execute
	 */ 
	public static void execute( ITrigger handler )
	{
		try {
			// prevent running if already ran
			if( handler.hasRun() ) {
				String triggerType = Trigger.isInsert ? 'insert' : Trigger.isUpdate ? 'update' : Trigger.isDelete ? 'delete' : Trigger.isUndelete ? 'undelete' : '';
				Logger.info( '##### stopping trigger invocation: isBefore = ' + Trigger.isBefore + ', type = ' + triggerType + ', handler = ' + handler );
				return;
			}
	
			// Before Trigger
			if (Trigger.isBefore)
			{
				// Call the bulk before to handle any caching of data and enable bulkification
				Logger.info( '### executing bulkBefore() for handler ' + handler );
				handler.bulkBefore();
				
				if (Trigger.isDelete)
				{
					// Do some specific bulk before delete logic
					Logger.info( '### executing bulkBeforeDelete() for handler ' + handler );
					handler.bulkBeforeDelete();
					// Iterate through the records to be deleted passing them to the handler.
					for (SObject so : Trigger.old)
					{
						handler.beforeDelete(so);
					}
				}
				else if (Trigger.isInsert)
				{
					// Do some specific bulk before insert logic
					Logger.info( '### executing bulkBeforeInsert() for handler ' + handler );
					handler.bulkBeforeInsert();
					// Iterate through the records to be inserted passing them to the handler.
					for (SObject so : Trigger.new)
					{
						handler.beforeInsert(so);
					}
				}
				else if (Trigger.isUpdate)
				{
					// Do some specific bulk before update logic
					Logger.info( '### executing bulkBeforeUpdate() for handler ' + handler );
					handler.bulkBeforeUpdate();
					// Iterate through the records to be updated passing them to the handler.
					for (SObject so : Trigger.old)
					{
						handler.beforeUpdate(so, Trigger.newMap.get(so.Id));
					}
				}
			}
			else
			{
				// Call the bulk after to handle any caching of data and enable bulkification
				Logger.info( '### executing bulkAfter() for handler ' + handler );
				handler.bulkAfter();
				
				if (Trigger.isDelete)
				{
					// Do some specific bulk after delete logic
					Logger.info( '### executing bulkAfterDelete() for handler ' + handler );
					handler.bulkAfterDelete();
					// Iterate through the records deleted passing them to the handler.
					for (SObject so : Trigger.old)
					{
						handler.afterDelete(so);
					}
				}
				else if (Trigger.isInsert)
				{
					// Do some specific bulk after insert logic
					Logger.info( '### executing bulkAfterInsert() for handler ' + handler );
					handler.bulkAfterInsert();
					// Iterate through the records inserted passing them to the handler.
					for (SObject so : Trigger.new)
					{
						handler.afterInsert(so);
					}
				}
				else if (Trigger.isUpdate)
				{
					// Do some specific bulk after update logic
					Logger.info( '### executing bulkAfterUpdate() for handler ' + handler );
					handler.bulkAfterUpdate();
					// Iterate through the records updated passing them to the handler.
					for (SObject so : Trigger.old)
					{
						handler.afterUpdate(so, Trigger.newMap.get(so.Id));
					}
				}
				else if (Trigger.isUndelete)
				{
					// Do some specific bulk after undelete logic
					Logger.info( '### executing bulkAfterUndelete() for handler ' + handler );
					handler.bulkAfterUndelete();
					// Iterate through the records undeleted passing them to the handler.
					for (SObject so : Trigger.new)
					{
						handler.afterUndelete(so);
					}
				}
			}
			
			// Perform any post processing
			Logger.info( '### executing andFinally() for handler ' + handler );
			handler.andFinally();
			
		} catch( Exception e ) {
			system.debug( '### error running triggerhandler ' + handler );
			Error_Log__c el = Errors.log( e );
			insert el;
			throw e;
		}
	}

}
