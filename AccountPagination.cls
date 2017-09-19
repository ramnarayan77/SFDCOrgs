public with sharing class AccountPagination {

private final Account acct;
public AccountPagination(ApexPages.StandardSetController controller) {
this.acct = (Account)controller.getRecord();
}


public ApexPages.StandardSetController accountRecords {
get 
{
if(accountRecords == null)
{
accountRecords = new ApexPages.StandardSetController (Database.getQueryLocator ([Select Id,Name from Account]));
system.debug('TEST1222');
}
return accountRecords;
}
set;
}


public List<Account> getAccountLot() {
return (List<Account>) accountRecords.getRecords();
}

}