public class accwitopps {

public List<Opportunity> Opp {get;set;}
public Map<String,Integer> OppMap {get;set;}
public Map<String,Integer> OppMap1 {get;set;}
Public List<SelectOption> items{get;set;}
public List<Account> Accssearch {get;set;}
String SelListRadio{get;set;}
Public String AccountName {get;set;}
Public String Searchtext {get;set;}
Public Integer Oppcount {get;set;}
public Id RetAccid {get;set;}
private ApexPages.StandardSetcontroller controller;

public accwitopps (ApexPages.StandardSetController controller)
{
this.controller = controller;
Accssearch = [SELECT id, Name from Account];
Oppmap1 = new Map<String,integer>();
Oppmap1 = getshowAllopps();
}

public String getSelListRadio()
{
return SelListRadio;
}

public void setSelListRadio(String s)
{
this.SelListRadio=s;
}

public List<SelectOption> getSelListOption()
{
items = new List<SelectOption>();
items.add(new SelectOption ('All','All'));
items.add(new SelectOption ('Filtered Records','Filtered Records'));
return items;
}

public List<Account> getAccssearch ()
{
return Accssearch;
}

public PageReference show()
{
Accssearch = new List<Account>();
Searchtext = '%'+AccountName+'%';
if (SelListRadio =='All')
{
AccountName = null;
Accssearch = [SELECT id, Name from Account];
}
else
{
Accssearch = [SELECT id, Name from Account where Name LIKE :Searchtext];
}
return null;
}

public Map<String,integer> getshowAllopps()
{
Oppmap = new Map<String,integer>();
//OppMap = [SELECT id, Name from Opportunity where Accountid in :Accssearch];
AggregateResult[] oppcounts = [SELECT Accountid, Count(id) noOfEmp from Opportunity where Accountid in :Accssearch group by Accountid];
for (AggregateResult oppcnt : oppcounts)
{
String id1 =  String.valueof(oppcnt.get('Accountid'));
Integer r = Integer.valueof(oppcnt.get('noOfEmp'));
Oppmap.put(id1,r);
system.debug('Map Key is 1116464641: '+id1 + ' Map value is '+r);
}
return Oppmap;
}

public PageReference showopps()
{
RetAccid = ApexPages.CurrentPage().getParameters().get('RetAccid');
Opp = [SELECT id, Name from Opportunity where Accountid = :RetAccid];
Oppcount=Opp.size();
return null;
}

public List<Opportunity> getfetchopps()
{
//Accsid = ApexPages.CurrentPage().getParameters().get('RectAccid');
//Opp = [SELECT id, Name from Opportunity where Accountid = :Accsid];

return Opp;
}

}