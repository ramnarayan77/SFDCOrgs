public class accwitoppsextn {
Public Integer Oppcount {get;set;}
public Id RetAccid {get;set;}
private ApexPages.StandardController controller;

public accwitoppsextn(ApexPages.StandardController controller)
{
this.controller=controller;
}

public void retOpptotals()
{
Oppcount = [Select count() from Opportunity where Accountid = :RetAccid];
}

}