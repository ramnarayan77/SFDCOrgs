public class AcctOppt {

Public List<Opportunity> Oppty;
public Account act;
public Account conVariable;

public ApexPages.StandardSetController setcon {

get {

if (setcon == null)
{
setcon = new ApexPages.StandardSetController (Database.getQueryLocator([select Id,Name from Account]));
}
return setcon;
}
set;
}

public List<Account> getAccnt ()

{
return (List<Account>) setcon.getRecords();
}

public void Oppties ()
{
Id accntid = ApexPages.CurrentPage().getParameters().get('Accntid');
Oppty = [Select id,Name from Opportunity where Accountid = :accntid];
}

public List<Opportunity> getretoppty () {
return (List<Opportunity>) Oppty;
} 

}