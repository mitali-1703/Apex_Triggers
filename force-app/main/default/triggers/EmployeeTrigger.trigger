trigger EmployeeTrigger on Employee__c (before insert, after insert, before update, after update, before delete, after delete, after undelete) {
	switch on Trigger.operationType {
        when BEFORE_INSERT {
            EmployeeTriggerHelper.beforeInsert(Trigger.new);
        }
        when AFTER_INSERT {		
            EmployeeTriggerHelper.afterInsert(Trigger.new);
        }
        when BEFORE_UPDATE {		
            EmployeeTriggerHelper.beforeUpdate(Trigger.new,Trigger.oldMap);
        }
        when AFTER_UPDATE {		  
            EmployeeTriggerHelper.afterUpdate(Trigger.new,Trigger.oldMap);
        }
        when BEFORE_DELETE {		  
            EmployeeTriggerHelper.beforeDelete(Trigger.old);
        }
        when AFTER_DELETE {		  
            EmployeeTriggerHelper.afterDelete(Trigger.old);
        }
        when AFTER_UNDELETE {		  
            EmployeeTriggerHelper.afterUnDelete(Trigger.new);
        }
    }
}