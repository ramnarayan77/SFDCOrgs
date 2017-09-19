public class eventinline {

private final Event evnt;
public List<Survey__c> Survys{get;set;}
Public Boolean listsize{get;set;}

public eventinline(ApexPages.StandardController stdController)
{
this.evnt = (Event)stdController.getRecord();
callSurveys();
}

public void callSurveys()
{
listsize = False;
system.debug('Survys before: '+Survys);
Survys = new List<Survey__c> ([Select Id,Name,Event_Id__c  from Survey__c where Event_Id__c = :evnt.id]);
system.debug('Survys after: '+Survys);
if(Survys.size() > 0)
{
listsize = True;
}
}

}