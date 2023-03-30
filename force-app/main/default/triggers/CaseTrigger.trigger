trigger CaseTrigger on Case (before insert, after insert, before update, after update, before delete, after delete) {
    switch on Trigger.operationType {
        when BEFORE_INSERT {
            CaseTriggerHelper.beforeInsert(Trigger.new);
        }
        when AFTER_INSERT {
            CaseTriggerHelper.afterInsert(Trigger.new);
        }
        when BEFORE_UPDATE {
            CaseTriggerHelper.beforeUpdate(Trigger.new,Trigger.oldMap);
        }
        when AFTER_UPDATE {
            CaseTriggerHelper.afterUpdate(Trigger.new,Trigger.oldMap);
        }
        when BEFORE_DELETE {
            CaseTriggerHelper.beforeDelete(Trigger.old);
        }
        when AFTER_DELETE {
            CaseTriggerHelper.afterDelete(Trigger.old);
        }
    }
}