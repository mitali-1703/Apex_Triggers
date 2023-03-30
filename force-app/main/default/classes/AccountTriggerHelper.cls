public with sharing class AccountTriggerHelper {
	public static void beforeInsert(List<Account> newList) {
        updateRating(newList,null);
        copyBillingToShipping(newList,null);
    }

    public static void afterInsert(List<Account> newList){
        createRelatedContact(newList);
        createRelatedRecordBasedOnChoice(newList);
        createRelatedOpportunity(newList);
    }

    public static void beforeUpdate(List<Account> newList,Map<Id,Account> oldMap){//NOPMD
        populateDescription(newList,oldMap);
        copyBillingToShipping(newList,oldMap);
        updateRating(newList,oldMap);
        // preventUpdate(newList,oldMap);
    }

    public static void afterUpdate(List<Account> newList,Map<Id,Account> oldMap){//NOPMD
        updateRelatedContactPhone(newList,oldMap);
        updateRelatedContactPhoneSoql(newList,oldMap);
        updateRelatedContactMailingAddress(newList,oldMap);
        updateRelatedContactMailingAddressSoql(newList,oldMap);
        // changeOpportunityStage(newList,oldMap);
    }

    public static void beforeDelete(List<Account> oldList){//NOPMD
        accountCannotBeDeleted(oldList);
        preventAccountDeletion(oldList);
        // preventRelatedAccountDeletion(oldList);
        preventRelatedAccountCaseDeletion(oldList);
    }
    
    public static void afterDelete(List<Account> oldList){//NOPMD
        
    }
    
    
    private static void updateRating(List<Account> accounts, Map<Id,Account> accountMap) {
        for(Account account : accounts) {
            if(account.Industry != NULL) {
                if(accountMap != NULL){
                    if(account.Industry != accountMap.get(account.Id).Industry && account.Industry == 'Media'){
                        account.Rating = 'Hot';
                    }
                }
                else{
                    if(account.Industry == 'Media'){
                        account.Rating = 'Hot';
                    }
                }
            }
        }
    }

    private static void copyBillingToShipping(List<Account> accounts, Map<Id,Account> accountMap) {
        for(Account account : accounts) {
            if(account.CopyBillingToShipping__c){
                if(accountMap != NULL){
                    if(account.BillingCity != accountMap.get(account.Id).BillingCity){
                    	account.ShippingCity = account.BillingCity;
                	}
                	if(account.BillingStreet != accountMap.get(account.Id).BillingStreet){
                    	account.ShippingStreet = account.BillingStreet;
                	}
                	if(account.BillingCountry != accountMap.get(account.Id).BillingCountry){
                    	account.ShippingCountry = account.BillingCountry;
                	}
                	if(account.BillingState != accountMap.get(account.Id).BillingState){
                    	account.ShippingState = account.BillingState;
                	}
                	if(account.BillingPostalCode != accountMap.get(account.Id).BillingPostalCode){
                    	account.ShippingPostalCode = account.BillingPostalCode;
                	}
                }
                else{
                    if(account.BillingCity != NULL){
                    	account.ShippingCity = account.BillingCity;
                	}
                	if(account.BillingCountry != NULL){
                    	account.ShippingCountry = account.BillingCountry;
                	}
                	if(account.BillingStreet != NULL){
                    	account.ShippingStreet = account.BillingStreet;
                	}
                	if(account.BillingPostalCode != NULL){
                    	account.ShippingPostalCode = account.BillingPostalCode;
                	}
                	if(account.BillingState != NULL){
                    	account.ShippingState = account.BillingState;
                	}
                }
            }
        }
    }
    
    private static void createRelatedContact(List<Account> accounts) {
        List<Contact> contacts = AccountService.createContact(accounts);
            if(!contacts.isEmpty()) {
                insert contacts;
            }
    }

    private static void createRelatedRecordBasedOnChoice(List<Account> accounts) {
        for(Account account : accounts) {
            if(account.Contact__c){
                List<Contact> contacts = AccountService.createContact(accounts);
                if(!contacts.isEmpty()) {
                    insert contacts;
                }
            }
            if(account.Opportunity__c && account.Active__c == 'Yes'){
                List<Opportunity> opportunities = AccountService.createOpportunity(accounts);
                if(!opportunities.isEmpty()) {
                    insert opportunities;
                }
            }
        }
    }

    private static void createRelatedOpportunity(List<Account> accounts) {
        for(Account account : accounts) {
            List<Opportunity> opportunities = AccountService.createOpportunity(accounts);
            if(!opportunities.isEmpty()) {
                insert opportunities;
            }
        }
    }

    private static void populateDescription(List<Account> accounts, Map<Id,Account> accountMap) {
        for(Account account : accounts) {
            if(account.Phone != accountMap.get(account.Id).Phone) {
                account.Description = 'Phone is Updated! Old Value : ' + accountMap.get(account.Id).Phone + ' & New Value : ' + account.Phone;
            }
        }
    }

    private static void updateRelatedContactPhone(List<Account> accounts, Map<Id,Account> accountMap) {
        Map<Id, String> accountIdToPhoneMap = new Map<Id, String>();
        for(Account account: accounts) {
            if(account.Phone != accountMap.get(account.Id).Phone) {
                accountIdToPhoneMap.put(account.Id, account.Phone);
            }
        }

        if(!accountIdToPhoneMap.isEmpty()) {
            List<Contact> contacts = AccountService.updateContactsPhone(accountIdToPhoneMap);
            if(!contacts.isEmpty()) {
                update contacts;
            }
        }
    }

    private static void updateRelatedContactPhoneSoql(List<Account> accounts, Map<Id,Account> accountMap) {
        Set<Id> accountIds = new Set<Id>();
        for(Account account: accounts) {
            if(account.Phone != accountMap.get(account.Id).Phone) {
                accountIds.add(account.Id);
            }
        }

        if(!accountIds.isEmpty()) {
            List<Contact> contacts = AccountService.updateContactsPhoneSoql(accountIds);
            if(!contacts.isEmpty()) {
                update contacts;
            }
        }
    }

    private static void updateRelatedContactMailingAddress(List<Account> accounts, Map<Id,Account> accountMap) {
        Map<Id, Account> accountIdToAccountMap = new Map<Id, Account>();
        for(Account account: accounts) {
            if(account.BillingCity != accountMap.get(account.Id).BillingCity || account.BillingCountry != accountMap.get(account.Id).BillingCountry ||
               account.BillingState != accountMap.get(account.Id).BillingState || account.BillingPostalCode != accountMap.get(account.Id).BillingPostalCode || 
               account.BillingStreet != accountMap.get(account.Id).BillingStreet) {
                accountIdToAccountMap.put(account.Id, account);
            }
        }

        if(!accountIdToAccountMap.isEmpty()){
            List<Contact> contacts = AccountService.updateContactsMailingAddress(accountIdToAccountMap);
            if(!contacts.isEmpty()) {
                update contacts;
            }
        }
    }

    private static void updateRelatedContactMailingAddressSoql(List<Account> accounts, Map<Id,Account> accountMap) {
        Set<Id> accountIds = new Set<Id>();
        for(Account account: accounts) {
            if(account.BillingCity != accountMap.get(account.Id).BillingCity || account.BillingCountry != accountMap.get(account.Id).BillingCountry ||
               account.BillingState != accountMap.get(account.Id).BillingState || account.BillingPostalCode != accountMap.get(account.Id).BillingPostalCode || 
               account.BillingStreet != accountMap.get(account.Id).BillingStreet) {
                accountIds.add(account.Id);
            }
        }

        if(!accountIds.isEmpty()) {
            List<Contact> contacts = AccountService.updateContactsMailingAddressSoql(accountIds);
            if(!contacts.isEmpty()) {
                update contacts;
            }
        }
    }

    private static void changeOpportunityStage(List<Account> accounts, Map<Id,Account> accountMap) {
        Set<Id> accountIds = new Set<Id>();
        for(Account account : accounts){
            if(account.Active__c == 'No' && accountMap.get(account.Id).Active__c == 'Yes'){
                accountIds.add(account.Id);
            }
        }

        if(accountIds != NULL){
            List<Opportunity> opportunities = new List<Opportunity>();
            List<Account> accountList = AccountService.fetchRelatedOpportunity(accountIds);
            for(Account account : accountList){
                if(account.Opportunities != NULL){
                    for(Opportunity opp : account.Opportunities){
                        if(opp.StageName != 'Closed Won'){
                            opp.StageName = 'Closed Lost';
                            opportunities.add(opp);
                        }
                    }
                }
            } 

            if(!opportunities.isEmpty()){
                update opportunities;
            }
        }
    }

    private static void accountCannotBeDeleted(List<Account> accounts) {
        for(Account account : accounts){
            if(account.Active__c == 'Yes'){
                account.addError('Account Cannot be deleted');
            }
        }
    }

    private static void preventUpdate(List<Account> accounts, Map<Id,Account> accountMap) {
        for(Account account : accounts){
            if(account.CreatedDate < System.today() - 7){
                account.addError('You cannot update records created 7days back');
            }
        }
    }

    private static void preventAccountDeletion(List<Account> accounts) {
        Id profileId = Userinfo.getProfileId();  
        Profile profileName = [SELECT Name FROM Profile WHERE Id =: profileId];

        for(Account account : accounts){
            if(profileName.Name != 'System Administrator'){
                account.addError('No Access for Deletion');                                    
            }
                            
        }
    }

    private static void preventRelatedAccountDeletion(List<Account> accounts) {
        //Method-1
        /* Map<Id,Account> accountIdToAccountMap = new Map<Id,Account>();
        for(Account account : accounts){
            accountIdToAccountMap.put(account.Id,account);
        }

        if(!accountIdToAccountMap.isEmpty()){
            List<Account> accountList = AccountService.getOpportunity(accountIdToAccountMap);

            if(!accountList.isEmpty()){
                for(Account account : accountList){
                    if(account.Opportunities.size() > 0){
                        account.addError('Account cannot be deleted as it is related to Opportunity');
                    }
                }
            }
        } */

        //Method-2
        List<Opportunity> opportunities = [SELECT AccountId FROM Opportunity];
        Set<Id> accountIds = new Set<Id>();
        for(Opportunity opportunity : opportunities) {
            accountIds.add(opportunity.AccountId);
        }
        System.debug(opportunities);
        for(Account account : accounts) {
            if(accountIds.contains(account.Id)) {
                account.addError('Opportunity Exists');
            }
        }
    }

    private static void preventRelatedAccountCaseDeletion(List<Account> accounts) {
        Map<Id,Account> accountIdToAccountMap = new Map<Id,Account>();
        for(Account account : accounts){
            accountIdToAccountMap.put(account.Id,account);
        }

        if(!accountIdToAccountMap.isEmpty()){
            List<Account> accountList = AccountService.getCase(accountIdToAccountMap);

            if(!accountList.isEmpty()){
                for(Account account : accountList){
                    if(account.Cases.size() > 0){
                        account.addError('Account cannot be deleted as it is related to Case');
                    }
                }
            }
        }
    }
}

