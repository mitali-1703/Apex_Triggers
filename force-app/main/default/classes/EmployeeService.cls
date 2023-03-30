public with sharing class EmployeeService {
    public static Employee__c setActiveToEmployee(Employee__c employee) {
        Employee__c newEmployee = new Employee__c();
        newEmployee.Id = employee.Id;
        newEmployee.Active__c = true;
        return newEmployee;
    }

    public static List<Account> getAccount(Set<Id> accountIds){
        List<Account> accounts = [SELECT Id,NumberOfEmployees,(SELECT AccountId__c FROM Employees1__r) FROM Account WHERE Id IN : accountIds];
        return !accounts.isEmpty() ? accounts : NULL;
    }
}