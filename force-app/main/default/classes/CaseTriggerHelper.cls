public with sharing class CaseTriggerHelper {

	public static void beforeInsert(List<Case> newList) {//NOPMD
        populateTotalCases(newList,null);
    }

    public static void afterInsert(List<Case> newList){
        populateLatestCaseNumber(newList);
    }

    public static void beforeUpdate(List<Case> newList,Map<Id,Case> oldMap){//NOPMD
        populateTotalCases(newList,oldMap);
    }

    public static void afterUpdate(List<Case> newList,Map<Id,Case> oldMap){//NOPMD
        
    }

    public static void beforeDelete(List<Case> oldList){//NOPMD
        
    }

    public static void afterDelete(List<Case> oldList){//NOPMD
        
    }
    
    private static void populateLatestCaseNumber(List<Case> cases) {
        Map<Id,String> accountIdToCaseNumberMap = new Map<Id,String>();
        for(Case newCase : cases){
            if(newCase.AccountId != NULL){
                accountIdToCaseNumberMap.put(newCase.accountId,newCase.CaseNumber);
            }
        }

        if(!accountIdToCaseNumberMap.isEmpty()){
            List<Account> accounts = CaseService.createAccount(accountIdToCaseNumberMap);
            if(!accounts.isEmpty()){
                update accounts;
            }
        }
    }

    private static void populateTotalCases(List<Case> cases, Map<Id,Case> caseMap) {
        Set<Id> accountIds = new Set<Id>();
        Map<Id,Account> accountIdToAccountMap = new Map<Id,Account>();
        
        for(Case caseItem : cases){
            accountIds.add(caseItem.AccountId);
        }

        if(!accountIds.isEmpty()){
            List<Account> accounts = CaseService.getAccount(accountIds);
            if(!accounts.isEmpty()){
                for(Account acc : accounts){
                    accountIdToAccountMap.put(acc.Id,acc);
                }
                
                for(Case caseItem : cases){
                    if(caseItem.RecordType.DeveloperName == 'Partner Case'){
                        accountIdToAccountMap.get(caseItem.AccountId).PartnerCase__c++;
                    }
                    else if(caseItem.RecordType.DeveloperName == 'Customer Case'){
                        accountIdToAccountMap.get(caseItem.AccountId).CustomerCase__c++;
                    }
                }

                update accountIdToAccountMap.values();
            }
        }
    }
}
