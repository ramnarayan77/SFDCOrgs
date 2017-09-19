public class dynamicfldsdisp {

public final Case casedetails {get; private set;}

public dynamicfldsdisp (ApexPages.StandardController controller) {
String qid = ApexPages.currentPage().getParameters().get('id');
String thequery = 'SELECT id, ' + joincasefields (caseFieldList,',') + ' FROM Case WHERE id = :qid';
this.casedetails =  Database.query(thequery);
}

public List<String> caseFieldList {
get {
if (caseFieldList == null) {
caseFieldList = new List<String>();
caseFieldList.add('CaseNumber');
caseFieldList.add('Origin');
caseFieldList.add('Status');
caseFieldList.add('Contact.Name'); // related field
caseFieldList.add('Contact.Email'); // related field
caseFieldList.add('Contact.Phone'); // related field
}
return caseFieldList;
}
private set;
}

private static String joincasefields(List<String> theList, String separator) {
if (theList == null) {
return null;
}
if (separator == null) {
separator = '';
}
String joined = '';
Boolean firstItem = true;
for (String item : theList) {
if(null != item) {
if(firstItem){
firstItem = false;
}
else {
joined += separator;
}
joined += item;
}
}
return joined;
}

}