Public with sharing class Accountretrieve {

Public Account Accnt;
Public String Disp_accvals;
Public String Dispvals;

public Accountretrieve() {
Accnt =  [select id, name, phone from Account where id = :ApexPages.currentPage().getParameters().get('id')];
Dispvals = getDisplayalllvals();
}

public String getDisplayalllvals()
{
Disp_accvals = Accnt.Name+':'+Accnt.Id+':'+Accnt.Phone;
return Disp_accvals;
}

public Account getAccvals()
{
return Accnt;
}

public void saveacc()
{
update Accnt;
}

}