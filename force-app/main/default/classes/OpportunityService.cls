public with sharing class OpportunityService {
    
    public static List<Account> createAccount(Map<Id,Decimal> accountIdToAmountMap) {
        List<Account> accounts = new List<Account>();
        for(Id accountId : accountIdToAmountMap.keyset()){
            Account account = new Account();
            account.Id = accountId;
            account.Recent_Opportunity_Amount__c = accountIdToAmountMap.get(accountId);
            accounts.add(account);
        }

        return !accounts.isEmpty() ? accounts : NULL;
    }

    public static List<Task> createTask(List<Opportunity> opportunities, Map<Id,Opportunity> oppMap) {
        List<Task> tasks = new List<Task>();
        for(Opportunity currentOpp : opportunities){
            if(currentOpp.StageName != oppMap.get(currentOpp.Id).StageName){
                Task task = new Task();
                task.WhatId = currentOpp.Id;
                task.Status = 'Not Started';
                task.Priority = 'Normal';
                task.Subject = 'Other';
                task.OwnerId = currentOpp.OwnerId;
                tasks.add(task);
            }
        }

        return !tasks.isEmpty() ? tasks : NULL;
    }
}