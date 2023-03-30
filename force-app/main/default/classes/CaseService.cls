public with sharing class CaseService {
    
    public static List<Account> createAccount(Map<Id,String> accountIdToCaseNumberMap) {
        List<Account> accounts = new List<Account>();
        for(Id accountId : accountIdToCaseNumberMap.keyset()){
            Account account = new Account();
            account.Id = accountId;
            account.Latest_Case_Number__c = accountIdToCaseNumberMap.get(accountId);
            accounts.add(account);
        }

        return !accounts.isEmpty() ? accounts : NULL;
    }

    public static List<Account> getAccount(Set<Id> accountIds) {
        // Map<Id,Account> accountIdToAccountMap = new Map<Id,Account>();
        List<Account> accounts = [SELECT Id,CustomerCase__c,PartnerCase__c FROM Account WHERE Id IN : accountIds];

        // for(Account acc : accounts){
        //     accountIdToAccountMap.put(acc.Id,acc);
        // }
        // return !accountIdToAccountMap.isEmpty() ? accountIdToAccountMap : NULL;
        return !accounts.isEmpty() ? accounts : NULL;
    }
}