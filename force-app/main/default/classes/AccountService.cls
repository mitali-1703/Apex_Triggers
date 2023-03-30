public with sharing class AccountService {
    
    public static List<Contact> createContact(List<Account> accounts) {
        List<Contact> contacts = new List<Contact>();
        for(Account account : accounts) {
            Contact contact = new Contact();
            contact.LastName = account.Name;
            contact.AccountId = account.Id;
            contacts.add(contact);
        }

        return !contacts.isEmpty() ? contacts : NULL;
    }

    public static List<Opportunity> createOpportunity(List<Account> accounts) {
        List<Opportunity> opportunities = new List<Opportunity>();
        for(Account account : accounts) {
            Opportunity newOpportunity = new Opportunity();
            newOpportunity.Name = account.Name;
            newOpportunity.StageName = 'Qualification';
            newOpportunity.CloseDate = System.today();
            newOpportunity.AccountId = account.Id;
            opportunities.add(newOpportunity);
        }

        return !opportunities.isEmpty() ? opportunities : NULL;
    }

    public static List<Contact> updateContactsPhone(Map<Id, String> accountIdToPhoneMap) {
        List<Contact> contacts = ContactSelector.fetchContactRelatedToAccount(accountIdToPhoneMap.keySet());
        for(Contact contact : contacts){
            contact.HomePhone = accountIdToPhoneMap.get(contact.AccountId);
        }

        return !contacts.isEmpty() ? contacts : NULL;
    }

    public static List<Contact> updateContactsPhoneSoql(Set<Id> accountIds) {
        List<Contact> contacts = new List<Contact>();
        List<Account> accounts = AccountSelector.fetchContactRelatedToAccount(accountIds);
        for(Account account : accounts){
            if(account.Contacts != NULL){
                for(Contact contact : account.Contacts){
                    contact.HomePhone = account.Phone;
                    contacts.add(contact);
                }
            }
        }

        return !contacts.isEmpty() ? contacts : NULL;
    }

    public static List<Contact> updateContactsMailingAddress(Map<Id, Account> accountIdToAccountMap) {
        List<Contact> contacts = ContactSelector.findContactRelatedToAccount(accountIdToAccountMap.keySet());
        for(Contact contact : contacts){
            contact.MailingCity = accountIdToAccountMap.get(contact.AccountId).BillingCity;
            contact.MailingCountry = accountIdToAccountMap.get(contact.AccountId).BillingCountry;
            contact.MailingState = accountIdToAccountMap.get(contact.AccountId).BillingState;
            contact.MailingStreet = accountIdToAccountMap.get(contact.AccountId).BillingStreet;
            contact.MailingPostalCode = accountIdToAccountMap.get(contact.AccountId).BillingPostalCode;
        }

        return !contacts.isEmpty() ? contacts : NULL;
    }

    public static List<Contact> updateContactsMailingAddressSoql(Set<Id> accountIds) {
        List<Contact> contacts = new List<Contact>();
        List<Account> accounts = AccountSelector.findContactRelatedToAccount(accountIds);
        for(Account account : accounts){
            if(account.Contacts != NULL){
                for(Contact contact : account.Contacts){
                    contact.MailingCity = account.BillingCity;
                    contact.MailingCountry = account.BillingCountry;
                    contact.MailingState = account.BillingState;
                    contact.MailingStreet = account.BillingStreet;
                    contact.MailingPostalCode = account.BillingPostalCode;
                    contacts.add(contact);
                }
            }
        }

        return !contacts.isEmpty() ? contacts : NULL;
    }

    public static List<Account> fetchRelatedOpportunity(Set<Id> accountIds) {
        List<Account> accounts = [SELECT Id, Active__c,(SELECT Id,StageName FROM Opportunities) FROM Account WHERE Id IN : accountIds];

        return !accounts.isEmpty() ? accounts : NULL;
    }

    public static List<Account> getOpportunity(Map<Id, Account> accountIdToAccountMap) {
        List<Account> accounts = AccountSelector.findAccountRelatedToOpportunity(accountIdToAccountMap.keySet());
        
        return !accounts.isEmpty() ? accounts : NULL;
    }

    public static List<Account> getCase(Map<Id, Account> accountIdToAccountMap) {
        List<Account> accounts = AccountSelector.findAccountRelatedToCase(accountIdToAccountMap.keySet());
        return !accounts.isEmpty() ? accounts : NULL;
    }
}