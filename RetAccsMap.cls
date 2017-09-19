public with sharing class RetAccsMap {
Map<id,Account> Accvals = new Map<id,Account>();
Map<id,Opportunity> Oppvals = new Map<id,Opportunity>();

Integer i =0;

public RetAccsMap() {
for (Account a : [SELECT Id, Name FROM Account]) {
Accvals.put(a.id,a);
getPopoppty(a);
}
}

public Map<Id, Account> getMapToAccount() 
{
return Accvals;

}

public Map<Id, Opportunity> getAccOpportunity() 
{
return oppvals;
}

public void getPopoppty(Account a) 
{
for (Opportunity o :[SELECT Id, Accountid, Name FROM Opportunity where Accountid = :a.id])
{
Oppvals.put(o.accountid,o);
}
}

}