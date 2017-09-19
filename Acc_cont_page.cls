public class Acc_cont_page {

public Account account {get;private set;}

public Acc_cont_page() {
Id id = ApexPages.currentPage().getparameters().get('id');
account = (id == null) ? new Account():
[select Id, Name, Industry, Phone from Account where Id = :id];
}

public PageReference save() 
{
try
{
upsert(account);
}
catch(System.DMLException e)
{
ApexPages.addMessages(e);
system.debug('TES353535T24242242424424');
return null;
}

PageReference redirectsuccess =  new ApexPages.StandardController(account).view();

return (redirectsuccess);
}

}