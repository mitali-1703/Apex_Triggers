public with sharing class ContactSelector {
    public static List<Contact> fetchContactRelatedToAccount(Set<Id> accountIds) {
        List<Contact> contacts = [SELECT Id, AccountId FROM Contact WHERE AccountId IN : accountIds];
        
        return !contacts.isEmpty() ? contacts : NULL;
    }

    public static List<Contact> findContactRelatedToAccount(Set<Id> accountIds) {
        List<Contact> contacts = [SELECT Id, AccountId FROM Contact WHERE AccountId IN : accountIds];
        
        return !contacts.isEmpty() ? contacts : NULL;
    }
}