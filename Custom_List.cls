public class Custom_List  {

public ApexPages.StandardSetController Stdcon {
get 
{
if (Stdcon == null) 
{
Stdcon = new ApexPages.StandardSetController (Database.getQueryLocator ([select Name, CloseDate from Opportunity where CloseDate < TODAY ]));
}
return Stdcon;
}
set;
}

public List<Opportunity> getOpportunities() 
{
return (List<Opportunity>) Stdcon.getRecords();
}

}