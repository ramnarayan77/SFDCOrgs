public class RetrieveContacts {

public List<Contact> AllContacts{get;set;}
public boolean display{get;set;}
public boolean Alldisp{get;set;}
public boolean alwaystrue{get;set;}
public Account ContactAccnt{get;set;}
public List<Contact> AllConts{get;set;}
public Id AccountId {get;set;}
public List<Contact> AddSelectedCampaigns = new List<Contact>();
public Contact NewContact{get;set;}
public Id AccntId;
public String PACode{get;set;}
public Boolean Enrolled{get;set;}
public List<Wrapper_Contacts> ContactsList {get; set;}
public Campaign ParentCampaignEnrolled =  new Campaign();
public Campaign ParentCampaignNotEnrolled =  new Campaign();
public List<Campaign> ChildCampaignEnrolled =  new List<Campaign>();
public List<Campaign> ChildCampaignNotEnrolled =  new List<Campaign>();
public Campaign NewEnrollSMRMChildCampaign = new Campaign();
public Campaign NewNotEnrolledSMRMChildCampaign =  new Campaign();
public CampaignMember NewCampaignMember;
public Boolean NoChildCampaignfound;
Public Id result;
Public Campaign result1;
Map<Id,String> usernames = new Map<Id,String>();

public RetrieveContacts()
{
NewContact = new Contact();
//dummyAcc = new CustomAccounts__c();
ContactAccnt = new Account();
AllConts = new List<Contact>();
AllConts = [Select Id,Name from Contact];
}

public void setdisplay(Boolean disp) {
        display = disp;
    }


public boolean getdisplay() 
{
        return display;
    }
public void show() 
{
        NewContact = new Contact();
        display = true;
        //return null;
    }


public void cancel2() 
{
        //NewContact = null;
        display = false;
    }

public class Wrapper_Contacts {
        public Contact wrapcontact {get; set;}
        public Boolean selected {get; set;}
        public Boolean AttendedCampaign {get; set;}
        public Wrapper_Contacts (Contact c) {
            wrapcontact = c;
            selected = false;
            AttendedCampaign = false;
        }
    
    }
    


public void ShowAllContacts()
{
       ShowConts();
}

public PageReference SubmitContact()
{
system.debug('NewContact : '+NewContact);
NewContact.AccountId = ContactAccnt.Id;
try
{
Insert NewContact;
}
catch(Exception e)
{
ApexPages.addmessages(e);
return null;
}
NewContact = null;
cancel2();
ShowConts();
return null;
}

public void ShowConts()
{
       //system.debug('dummyAcc '+dummyAcc);
       ContactsList = new  List<Wrapper_Contacts>();
       for (Contact cc : [Select Id, Name,Email,AccountId,Account.Name,Phone,Ownerid,Owner.Name,Account.ownerid from Contact where Account.PA_Code__c = :PACode])
       {
       ContactAccnt = cc.Account;
       ContactsList.add(new Wrapper_Contacts(cc));
       }
}

public void AddtoCampaig()
{
        for(Wrapper_Contacts cCon: ContactsList) {
            if(cCon.selected == true) {
                AddSelectedCampaigns.add(cCon.wrapcontact);
                usernames.put(cCon.wrapcontact.ownerid,cCon.wrapcontact.Owner.Name);
            }
        }
}

public PageReference AddContacttoSMRMInterestedampaign()
{
AddtoCampaig();
try
{
ParentCampaignEnrolled = [Select Id,Name,StartDate,EndDate,Description,Status,Type from campaign where Id = '70190000001VcP1'];
}
catch(Exception e)

{
  ApexPages.addmessages(e);
  ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Parent SMRM Campaign(s) do not exist');
  ApexPages.addmessage(myMsg);
  return null;
}

system.debug('ParentCampaignNotEnrolled : '+ParentCampaignNotEnrolled);

ChildCampaignEnrolled = [Select Id from campaign where Ownerid = :AddSelectedCampaigns[0].Account.Ownerid and Parent.id = :ParentCampaignEnrolled.id LIMIT 1];

NewCampaignMember = new CampaignMember();

                   
          if(ChildCampaignEnrolled.size() > 0)
          {    
          NewCampaignMember.Campaignid = ChildCampaignEnrolled[0].id;
          NewCampaignMember.Contactid = AddSelectedCampaigns[0].id;
          NewCampaignMember.Status = 'Planned';
          

          try{
          Insert NewCampaignMember;
          }
          catch(Exception e)
          {
          ApexPages.addmessages(e);
          return null;
          }
          }
          
          else
          {
          NewEnrollSMRMChildCampaign = new Campaign();
          NewEnrollSMRMChildCampaign = ParentCampaignEnrolled.clone(false, false, false, false);
          NewEnrollSMRMChildCampaign.Name = ParentCampaignEnrolled.Name+' - '+usernames.get(AddSelectedCampaigns[0].Account.Ownerid);
          NewEnrollSMRMChildCampaign.ownerid  = AddSelectedCampaigns[0].Account.Ownerid;
          NewEnrollSMRMChildCampaign.Parentid = ParentCampaignEnrolled.Id;
          try
          {
          Insert NewEnrollSMRMChildCampaign;
          }
          catch(Exception e)
          {
          ApexPages.addmessages(e);
          return null;
          }
          result1 = new Campaign();
          result1 = NewEnrollSMRMChildCampaign;

          NewCampaignMember.Campaignid = result1.id;
          NewCampaignMember.Contactid = AddSelectedCampaigns[0].Id;
          NewCampaignMember.Status = 'Sent';
          
          try{
          Insert NewCampaignMember;
          }
          catch(Exception e){
          ApexPages.addmessages(e);
          return null;
          }
     
        
         }

 PageReference tempPage = ApexPages.currentPage();            
            tempPage.setRedirect(true);
        return tempPage;


}

public PageReference AddContacttoSMRMNotInterestedampaign()
{
AddtoCampaig();
try
{
ParentCampaignNotEnrolled = [Select Id,Name,StartDate,EndDate,Description,Status,Type from campaign where Id = '70190000001VcP6'];
}
catch(Exception e)

{
  ApexPages.addmessages(e);
  ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Parent SMRM Campaign(s) do not exist');
  ApexPages.addmessage(myMsg);
  return null;
}

system.debug('ParentCampaignNotEnrolled : '+ParentCampaignNotEnrolled);

ChildCampaignNotEnrolled = [Select Id from campaign where Ownerid = :AddSelectedCampaigns[0].Account.Ownerid and Parent.id = :ParentCampaignNotEnrolled.id LIMIT 1];

NewCampaignMember = new CampaignMember();

                   
         if(ChildCampaignNotEnrolled.size() >0)
          {    
          NewCampaignMember.Campaignid = ChildCampaignNotEnrolled[0].id;
          NewCampaignMember.Contactid = AddSelectedCampaigns[0].Id;
          NewCampaignMember.Status = 'Planned';
          
          try
          {
          Insert NewCampaignMember;
          }
          catch(Exception e){
          ApexPages.addmessages(e);
          return null;
          }
          }
          
          else
          {
          NewNotEnrolledSMRMChildCampaign = new Campaign();
          NewNotEnrolledSMRMChildCampaign = ParentCampaignNotEnrolled .clone(false, false, false, false);
          NewNotEnrolledSMRMChildCampaign.Name = ParentCampaignNotEnrolled .Name+' - '+usernames.get(AddSelectedCampaigns[0].Account.Ownerid);
          NewNotEnrolledSMRMChildCampaign.ownerid  = AddSelectedCampaigns[0].Account.Ownerid;
          NewNotEnrolledSMRMChildCampaign.Parentid = ParentCampaignNotEnrolled.Id;
          
          
          try
          {
          Insert NewNotEnrolledSMRMChildCampaign;
          }
          catch(Exception e){
          ApexPages.addmessages(e);
          return null;
          }
          result1 = new Campaign();
          result1 = NewNotEnrolledSMRMChildCampaign;

          NewCampaignMember.Campaignid = result1.id;
          NewCampaignMember.Contactid = AddSelectedCampaigns[0].Id;
          NewCampaignMember.Status = 'Sent';
          
           
          try
          {
          Insert NewCampaignMember;
          }
          catch(Exception e){
          ApexPages.addmessages(e);
          return null;
          }
           
         
          }

 PageReference tempPage = ApexPages.currentPage();            
            tempPage.setRedirect(true);
        return tempPage ;


}

public PageReference cancel() {
        return null;
    }


}