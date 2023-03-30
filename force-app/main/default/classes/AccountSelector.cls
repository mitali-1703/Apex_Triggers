public with sharing class AccountSelector {
    public static List<Account> fetchContactRelatedToAccount(Set<Id> accountIds) {
        List<Account> accounts = [SELECT Id,Phone,(SELECT HomePhone FROM Contacts) FROM Account WHERE Id IN : accountIds];
        
        return !accounts.isEmpty() ? accounts : NULL;
    }

    public static List<Account> findContactRelatedToAccount(Set<Id> accountIds) {
        List<Account> accounts = [SELECT Id,BillingCity,BillingState,BillingCountry,BillingStreet,BillingPostalCode,(SELECT Id FROM Contacts) FROM Account WHERE Id IN : accountIds];
        
        return !accounts.isEmpty() ? accounts : NULL;
    }

    public static List<Account> findAccountRelatedToOpportunity(Set<Id> accountIds) {
        List<Account> accounts = [SELECT Id,(SELECT AccountId FROM Opportunities) FROM Account WHERE Id IN : accountIds];
        
        return !accounts.isEmpty() ? accounts : NULL;
    }

    public static List<Account> findAccountRelatedToCase(Set<Id> accountIds) {
        List<Account> accounts = [SELECT Id,(SELECT AccountId FROM Cases) FROM Account WHERE Id IN : accountIds];
        
        return !accounts.isEmpty() ? accounts : NULL;
    }
}