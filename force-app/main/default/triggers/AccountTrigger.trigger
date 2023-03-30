trigger AccountTrigger on Account (before insert, after insert, before update, after update, before delete, after delete) {
	switch on Trigger.operationType {
        when BEFORE_INSERT {
            AccountTriggerHelper.beforeInsert(Trigger.new);
        }
        when AFTER_INSERT {		
            AccountTriggerHelper.afterInsert(Trigger.new);
        }
        when BEFORE_UPDATE {		
            AccountTriggerHelper.beforeUpdate(Trigger.new,Trigger.oldMap);
        }
        when AFTER_UPDATE {		  
            AccountTriggerHelper.afterUpdate(Trigger.new,Trigger.oldMap);
        }
        when BEFORE_DELETE {		  
            AccountTriggerHelper.beforeDelete(Trigger.old);
        }
        when AFTER_DELETE {		  
            AccountTriggerHelper.beforeDelete(Trigger.old);
        }
    }
}