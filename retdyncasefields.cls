public class retdyncasefields {

public final case CaseDetails {get;set;}

public retdyncasefields (ApexPages.StandardController controller)
{
String qid = ApexPages.currentpage().getParameters().get('id');
String dynquery = 'SELECT ID, ' + joinList(CasefieldList,',') + ' FROM Case where Id=: qid';
this.CaseDetails = Database.query(dynquery);
}

public List<String> CasefieldList {

get{
if (CasefieldList == null)
{
caseFieldList = new List<String>();
caseFieldList.add('CaseNumber');
caseFieldList.add('Origin');
caseFieldList.add('Status');
caseFieldList.add('Contact.Name');
caseFieldList.add('Contact.Email');
caseFieldList.add('Contact.Phone');
}
return caseFieldList; 
}
set;
}


private Static String joinList (List<String> Casefields, String Separator)
{

Boolean Firstitem = false;
String strcasefields = '';

for (String str1 : Casefields)
{
if (Firstitem == false)
{
Firstitem = True;
}
else
{    
strcasefields += Separator;
}
strcasefields += str1;
}
return strcasefields; 
}

}