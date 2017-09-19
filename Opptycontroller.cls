public class Opptycontroller {

Account Accret;
Opportunity Oppret;
Account Accnt;
Contact Contct;
Opportunity Oppty;
OpportunityContactRole Role;

public Account getAcct() 
{
Accret = [select id,name,site from Account where id = :ApexPages.currentPage().getParameters().get('id')];
return Accret;
}

public Opportunity getOppret() 
{
Oppret = [select id,name,stagename,closedate,amount from Opportunity where accountid = :ApexPages.currentPage().getParameters().get('id')];
return Oppret;
}

public Account getAccount() 
{
if (Accnt== null) Accnt = new Account();
return Accnt;
}

public Contact getContact() {
if (Contct== null) Contct = new Contact();
return Contct;
}

public Opportunity getOpportunity() {
if (Oppty== null) Oppty = new Opportunity();
return Oppty;
}

public OpportunityContactRole getOpportunityContactRole() {
if (Role== null) Role = new OpportunityContactRole();
return Role;
}


public PageReference Page1()
{
return Page.Oppty_Step_1;
}

public PageReference Page2()
{
return Page.Oppty_Step_2;
}

public PageReference Page3()
{
return Page.Oppty_Step_3;
}

public PageReference cancel() {
PageReference opportunityPage = new ApexPages.StandardController(Oppty).view();
opportunityPage.setRedirect(true);
return opportunityPage;
}

public PageReference save() {

accnt.phone = contct.phone;
insert accnt;

contct.accountId = accnt.id;
insert contct;

oppty.accountId = accnt.id;
insert oppty;

role.opportunityId = oppty.id;
role.contactId = contct.id;
insert role;

PageReference opptyPage = Page.Oppty_Step_5;
opptyPage.setRedirect(true);
opptyPage.getParameters().put('id',Accnt.id);
return opptyPage;
}

}