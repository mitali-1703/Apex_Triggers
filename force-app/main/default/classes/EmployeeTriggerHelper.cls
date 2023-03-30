public with sharing class EmployeeTriggerHelper {
    public static void beforeInsert(List<Employee__c> newList) {//NOPMD

    }

    public static void afterInsert(List<Employee__c> newList) {//NOPMD
        populateEmployeeCountOnAccount(newList);
    
    }
    
    public static void beforeUpdate(List<Employee__c> newList, Map<Id, Employee__c> oldMap) {//NOPMD
        
    }

    public static void afterUpdate(List<Employee__c> newList, Map<Id, Employee__c> oldMap) {//NOPMD

    }

    public static void beforeDelete(List<Employee__c> oldList) {//NOPMD
    }
    
    public static void afterDelete(List<Employee__c> oldList) {//NOPMD
        updateLeftEmployeeCountOnAccount(oldList);
    
    }
    public static void afterUndelete(List<Employee__c> newList) {//NOPMD
        undeletingEmployeeSetActive(newList);
        undeletingEmployeeSetLeftEmployee(newList);
        // updateLeftEmployeeCountOnAccount(newList, null);

    
    }
  
    //Scenario 17	When the Employee record is deleted then update 'Left Employee Count' on Account.
    private static void updateLeftEmployeeCountOnAccount(List<Employee__c> employeeList) {
        Set<Id> accountIds = new Set<Id>();
        for (Employee__c emp : employeeList) {
            if(emp.AccountId__c != NULL){
                accountIds.add(emp.AccountId__c);
            }
        }
        
        List<Account> accountsToUpdate = new List<Account>();
        for (AggregateResult resultArray : [SELECT AccountId__c accId, COUNT(Id) countEmployee FROM Employee__c
            WHERE AccountId__c IN :accountIds GROUP BY AccountId__c]) {
            accountsToUpdate.add(new Account(
                Id = (Id)resultArray.get('accId'),
                Left_Employee_Count__c = (Integer)resultArray.get('countEmployee')
            ));
        }

        update accountsToUpdate;
    }

    // Scenario 18	Undelete Employee record and set Active as true.
    private static void undeletingEmployeeSetActive(List<Employee__c> employeeList) {
        List<Employee__c> employeeToUpdated = new List<Employee__c>();
        for (Employee__c employee : employeeList) {
            employeeToUpdated.add(EmployeeService.setActiveToEmployee(employee));
            
        }
        if(!employeeToUpdated.isEmpty()){
            update employeeToUpdated;
        }
    }

    // Scenario 19	When the Employee record is undeleted then update 'Left Employee Count' on Account.
    private static void undeletingEmployeeSetLeftEmployee(List<Employee__c> employeeList) {
        Set<Id> accountIds = new Set<Id>();
        for (Employee__c emp : employeeList) {
            if(emp.AccountId__c != NULL){
                accountIds.add(emp.AccountId__c);
            }
        }
        
        List<Account> accountsToUpdate = new List<Account>();
        for (AggregateResult resultArray : [SELECT AccountId__c accId, COUNT(Id) countEmployee FROM Employee__c
            WHERE AccountId__c IN :accountIds GROUP BY AccountId__c]) {
            accountsToUpdate.add(new Account(
                Id = (Id)resultArray.get('accId'),
                Left_Employee_Count__c = (Integer)resultArray.get('countEmployee')
            ));
        }

        update accountsToUpdate;
    }

    //Scenario 20	When the Employee record is inserted, deleted and undeleted then update 
    //              'Present Employee Count' on related Account. [Parent-Child SOQL]
    private static void populateEmployeeCountOnAccount(List<Employee__c> employeeList) {
        Set<Id> accountIds = new Set<Id>();
        List<Account> updatedAccount = new List<Account>();
        for(Employee__c  employee : employeeList){
            if(employee.AccountId__c != NULL){
                accountIds.add(employee.AccountId__c);
            }
        }
        
        if(!accountIds.isEmpty()){
            List<Account> accounts = EmployeeService.getAccount(accountIds);
            if(!accounts.isEmpty()) {
                for(Account acc : accounts){
                    if(acc.Employees1__r != NULL){
                        Account a = new Account();
                        a.Id = acc.Id;
                        a.NumberOfEmployees = a.Employees1__r.size();
                        updatedAccount.add(a);
                    }
                }
            }
          
        }

        if(!updatedAccount.isEmpty()){
            update updatedAccount;
        }
    }
}