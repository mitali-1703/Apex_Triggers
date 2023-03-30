public with sharing class OpportunityTriggerHelper {
    
	public static void beforeInsert(List<Opportunity> newList) {//NOPMD
        populateDescription(newList);
        populateDescriptionOnStageInput(newList,null);
    }

    public static void afterInsert(List<Opportunity> newList){
        populateLatestOpportunityAmount(newList);
    }

    public static void beforeUpdate(List<Opportunity> newList,Map<Id,Opportunity> oldMap){//NOPMD
        populateDescriptionOnStageInput(newList,oldMap);
        populateClosedLostReason(newList,oldMap);
    }

    public static void afterUpdate(List<Opportunity> newList,Map<Id,Opportunity> oldMap){//NOPMD
        createTaskOnStageChange(newList,oldMap);
    }

    public static void beforeDelete(List<Opportunity> oldList){//NOPMD
        preventOpportunityDeletion(oldList);
    }

    public static void afterDelete(List<Opportunity> oldList){//NOPMD
        
    }
    

    private static void populateDescription(List<Opportunity> opportunities){
        for(Opportunity opportunityItem : opportunities){
            if(opportunityItem.Amount != NULL && opportunityItem.Amount > 100000){
                opportunityItem.Description = 'Hot Opportunity';
            }
        }
    }

    private static void populateLatestOpportunityAmount(List<Opportunity> opportunities) {
        Map<Id,Decimal> accountIdToAmountMap = new Map<Id,Decimal>();
        for(Opportunity opportunityItem : opportunities){
            if(opportunityItem.AccountId != NULL){
                accountIdToAmountMap.put(opportunityItem.accountId,opportunityItem.Amount);
            }
        }

        if(!accountIdToAmountMap.isEmpty()){
            List<Account> accounts = OpportunityService.createAccount(accountIdToAmountMap);
            if(!accounts.isEmpty()){
                update accounts;
            }
        }
    }

    private static void populateDescriptionOnStageInput(List<Opportunity> opportunities, Map<Id,Opportunity> oppMap) {
        for(Opportunity opportunityItem : opportunities){
            if(opportunityItem.StageName != NULL){
                if(oppMap != NULL){
                    if(opportunityItem.StageName != oppMap.get(opportunityItem.Id).StageName){
                        if(opportunityItem.StageName == 'Closed Won'){
                            opportunityItem.Description = 'Opp is Closed Won';
                        }
                        else if(opportunityItem.StageName == 'Closed Lost'){
                            opportunityItem.Description = 'Opp is Closed Lost';
                        }
                        else{
                            opportunityItem.Description = 'Opp is Open';
                        }
                    }
                }
                else{
                    if(opportunityItem.StageName == 'Closed Won'){
                            opportunityItem.Description = 'Opp is Closed Won';
                        }
                        else if(opportunityItem.StageName == 'Closed Lost'){
                            opportunityItem.Description = 'Opp is Closed Lost';
                        }
                        else{
                            opportunityItem.Description = 'Opp is Open';
                        }
                }
            }
        }
    }

    private static void createTaskOnStageChange(List<Opportunity> opportunities, Map<Id,Opportunity> oppMap) {
        List<Task> tasks = OpportunityService.createTask(opportunities,oppMap);

        if(!tasks.isEmpty()){
            insert tasks;
        }
    }

    private static void populateClosedLostReason(List<Opportunity> opportunities, Map<Id,Opportunity> oppMap) {
        for(Opportunity opportunityItem : opportunities){
            if(opportunityItem.StageName != oppMap.get(opportunityItem.Id).StageName && opportunityItem.StageName == 'Closed Lost' && String.isBlank(opportunityItem.ClosedLostReason__c)){
                opportunityItem.addError('Please populate Closed Lost Reason');
            }
        }
    }

    private static void preventOpportunityDeletion(List<Opportunity> opportunities) {
        Id profileId = Userinfo.getProfileId();  
        Profile profileName = [SELECT Name FROM Profile WHERE Id =: profileId];

        for(Opportunity opportunityItem : opportunities){
            if(profileName.Name != 'System Administrator' && (opportunityItem.StageName == 'Closed Lost' || opportunityItem.StageName == 'Closed Won')){
                opportunityItem.addError('No Access for Deletion');
            }
        }
    }
}