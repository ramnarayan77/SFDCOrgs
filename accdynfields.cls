public class accdynfields {
public ApexPages.StandardSetController controller;
public Account AccDetails { get; private set; }
Public String strngflds ='';
private PageReference savePage;
public transient List<String> selected {get; set;}
public transient List<String> Unselected {get; set;}
private set<String> selectedOptionvalues = new Set<String>();
private set<String> UnselectedOptionvalues = new Set<String>();
public Map<String,Schema.Sobjectfield> accallfields;
//public List<Selectoption> Popselectedlist;
public List<String> fieldnames;
public String selectedValues {get;set;}

public accdynfields (ApexPages.StandardSetcontroller controller)
{
this.controller = controller;
loadfields();
}

Public PageReference customize()
{
savepage = ApexPages.CurrentPage();
return Page.MultiselAccount;
}

public PageReference show()
{
controller.reset();
controller.addfields(getdisplayfields());
return savepage;
}

public List<String> getdisplayfields()
{
List<String> displayfields= new List<String>(selectedOptionvalues);
displayfields.sort();
system.debug('Dispfields are : '+displayfields);
return displayfields;
}


private void loadfields()
{
accallfields = Schema.SObjectType.Account.fields.getMap();
for (String s : accallfields.keyset())
{
if(s != 'Name')
{
if(accallfields.get(s).getDescribe().isAccessible())
{
UnselectedOptionvalues.add(s);}
}
}
}

public List<Selectoption> getlistselectedpopulated ()
{
return populatesetselected(selectedOptionvalues);
}

public List<Selectoption> getlistUnselectedpopulated ()
{
return  populatesetselected (UnselectedOptionvalues);
}

public List<Selectoption> populatesetselected (set<String> selvals)
{
List<String> setselectedvalues = new List<String>(selvals);  
//setselectedvalues.sort();
List<Selectoption> Popselectedlist = new List<Selectoption>();
for(String s: setselectedvalues)
{
Popselectedlist.add(new selectoption(s,s));
}
return Popselectedlist;
}

/*
public List<Selectoption> populatesetUnselected (set<String> selvals1)
{
Set<String> setUnselectedvalues = new Set<String>(selvals1);  
//setunSelectedvalues.sort();
List<Selectoption> PopUnselectedlist = new List<Selectoption>();
for(String s: setunSelectedvalues)
{
PopUnselectedlist.add(new selectoption(s,s));
}
return PopUnselectedlist;
}
*/

public void addfields()
{
realignfields(Selected, selectedOptionvalues,UnselectedOptionvalues);
}

public void removefields()
{
realignfields(UnSelected, UnselectedOptionvalues,selectedOptionvalues);
}

private void realignfields(List<String> SelectedUI, Set<String> removefld,Set<String> addfld)
{
for (String s : selectedUI)
{
addfld.add(s);
removefld.remove(s);
}
}

}