trigger PositionTrigger on Position__c (before insert, after insert, before update, after update, before delete, after delete) {
	switch on Trigger.operationType {
        when BEFORE_INSERT {
            PositionTriggerHelper.beforeInsert(Trigger.new);
        }
        when AFTER_INSERT {		
            PositionTriggerHelper.afterInsert(Trigger.new);
        }
        when BEFORE_UPDATE {		
            PositionTriggerHelper.beforeUpdate(Trigger.new,Trigger.oldMap);
        }
        when AFTER_UPDATE {		  
            PositionTriggerHelper.afterUpdate(Trigger.new,Trigger.oldMap);
        }
        when BEFORE_DELETE {		  
            PositionTriggerHelper.beforeDelete(Trigger.old);
        }
        when AFTER_DELETE {		  
            PositionTriggerHelper.beforeDelete(Trigger.old);
        }
    }
}