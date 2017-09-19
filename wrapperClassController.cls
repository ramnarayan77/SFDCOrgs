public class wrapperClassController {

Public List<String> ideas{get;set;}
public Map<String,Map<String,String>> Compregnprodcompname{get;set;}
public List<cTechMCompetitors> DealerpricesToShow{get;set;}
public Map<String,Map<String,Decimal>> Mapofdealerprices{get;set;}
public List<Competitors_Prices__c> Listofrecordstoaddprice {get;set;}
public Map<String,Map<String,Competitors_Prices__c>> MapofpriceSobjectids {get;set;}
public Map<String,Map<Id,Competitors_Prices__c>> RecordtoEdit{get;set;}
//public List<Competitors_Prices__c> Dealerprices{get;set;}
public Map<String, Decimal> channelsandprice{get;set;}
public List<String> channelonly{get;set;}
public List<String> coluNames {get;set;}
public List<String> IntermediatecoluNames {get;set;}

public void opennewpage()
{
Listofrecordstoaddprice = new List<Competitors_Prices__c>();
for (cTechMCompetitors priceadd : DealerpricesToShow)
{
for (Map<String,Competitors_Prices__c> priceadd2 : priceadd.Dlrpricesmap.values())
{
for(Competitors_Prices__c s : priceadd2.values())
{
Listofrecordstoaddprice.add(s);
}
}
}
}

public Competitors_Prices__c   addnewrow() {
Competitors_Prices__c newrowCompetitorsPricesc = new Competitors_Prices__c ();
return newrowCompetitorsPricesc;
    }


public List<Competitors_Prices__c> returnlist()
{
return Listofrecordstoaddprice;
}


public void getonlyChannels()
{
         channelonly = new List<String>();
         Schema.DescribeFieldResult fieldResult = Competitors_Prices__c.Channel__c.getDescribe();
         List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();

   for( Schema.PicklistEntry f : ple)
   {
      channelonly.add(f.getValue());
   } 
   channelonly.sort();
  //return channelonly;
}


public Map<String,Decimal> returnChannels()
{
         channelsandprice = new Map<String, Decimal>();
         Schema.DescribeFieldResult fieldResult = Competitors_Prices__c.Channel__c.getDescribe();
         List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();

   for( Schema.PicklistEntry f : ple)
   {
      channelsandprice.put(f.getValue(),0.00);
   } 
   return channelsandprice;
}

public wrapperClassController() {
getonlyChannels();
DealerpricesToShow = new List<cTechMCompetitors>();
List<Competitors_Prices__c> Listcompprices = new List<Competitors_Prices__c>();
Mapofdealerprices = new Map<String,Map<String,Decimal>>();
MapofpriceSobjectids = new Map<String,Map<String,Competitors_Prices__c>>();
Compregnprodcompname = new Map<String,Map<String,String>>();

String ids;

ideas = new List<string>();
for (Competitors_Prices__c compprice: [Select Business_Unit__c, Channel__c, Competitor_Product__r.Name, Competitors__r.Name,  Price__c, Region__c from Competitors_Prices__c order by Channel__c])
{
//ids = compprice.Region__c+'-'+compprice.Competitor_Product__r.Name+'-'+compprice.Competitors__r.Name;
ids = compprice.Competitor_Product__r.Name+'-'+compprice.Competitors__r.Name+'-'+compprice.Region__c;
if (Mapofdealerprices.get(ids) == null)
{
Mapofdealerprices.put(ids,new Map<String,Decimal>{compprice.channel__c => compprice.Price__c});
Compregnprodcompname.put(ids,new Map<String,String>
{
'Region' => compprice.Region__c,
'Product' => compprice.Competitor_Product__r.Name,
'Competitor Name' => compprice.Competitors__r.Name
}
);
ideas.add(ids);
system.debug('IDEAS : '+ideas);
}
if (Mapofdealerprices.containskey(ids))
{
Mapofdealerprices.get(ids).put(compprice.channel__c, compprice.Price__c);
}

if (MapofpriceSobjectids.get(ids) == null)
{
MapofpriceSobjectids.put(ids,new Map<String,Competitors_Prices__c>{compprice.channel__c => compprice});
}

if (MapofpriceSobjectids.containskey(ids))
{
MapofpriceSobjectids.get(ids).put(compprice.channel__c, compprice);
}

}
//DealerpricesToShow.add(new cTechMCompetitors (Mapofdealerprices,returnChannels(),ideas));
//DealerpricesToShow.add(new cTechMCompetitors (MapofpriceSobjectids,returnChannels(),ideas));
DealerpricesToShow.add(new cTechMCompetitors (MapofpriceSobjectids,returnChannels(),ideas,Mapofdealerprices));
system.debug(' DealerpricesToShow : '+DealerpricesToShow);
system.debug(' MapofpriceSobjectids : '+MapofpriceSobjectids);
opennewpage();
}

public List<String> getideas()
{
return ideas;
}

public List<String> getColNames()
{

         coluNames= new List<String>();
         IntermediatecoluNames= new List<String>();
         coluNames.add('Region');
         coluNames.add('Product');
         coluNames.add('Competitor');
         coluNames.sort();
         Schema.DescribeFieldResult fieldResult = Competitors_Prices__c.Channel__c.getDescribe();
         List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();

         for( Schema.PicklistEntry f : ple)
         {
         IntermediatecoluNames.add(f.getValue());
         } 
         IntermediatecoluNames.sort();
         for (String s : IntermediatecoluNames)
         {
         coluNames.add(s);
         }
         return coluNames;
}

public integer getlistsize()
{
return coluNames.size();
}

public class cTechMCompetitors
{

        public Map<String,Map<String,Decimal>> DlrpricesChannelmap{get;set;}
        public Map<String,Map<String,Competitors_Prices__c>> Dlrpricesmap{get;set;}
        public Map<String,Decimal> retrieveallchannels {get;set;}
        public Map<String,String> DisplayColumnsOrnot{get;set;}
        
        
        //public cTechMCompetitors (Map<String,Map<String,Decimal>> mapofdlrprces, Map<String, Decimal> allchannels,List<String> ids)
public cTechMCompetitors (Map<String,Map<String,Competitors_Prices__c>> mapofdlrprces, Map<String, Decimal> allchannels,List<String> ids,Map<String,Map<String,Decimal>> mapofdlrprceschannel)
        {
        Dlrpricesmap =  new Map<String,Map<String,Competitors_Prices__c>>();
        DlrpricesChannelmap =  new Map<String,Map<String,Decimal>>();
        DisplayColumnsOrnot = new Map<String,String>();
        retrieveallchannels =  new Map<String,Decimal>();
                        
                        Dlrpricesmap = mapofdlrprces;
                        DlrpricesChannelmap = mapofdlrprceschannel;
                        retrieveallchannels  = allchannels;
                        System.debug('DlrpricesChannelmap :' +DlrpricesChannelmap);
                        System.debug('Dlrpricesmap :' +Dlrpricesmap);
                        System.debug('DlrpricesChannelmap.keyset() :' +DlrpricesChannelmap.keyset());
                        System.debug('retrieveallchannels.keyset() :' +retrieveallchannels.keyset());
                        for (String allkeys : DlrpricesChannelmap.keyset())
                        {
                        for (String actualchannels : DlrpricesChannelmap.get(allkeys).keyset())
                        {
                        for (String allpossiblechannels : retrieveallchannels.keyset())
                        {
                        if (DlrpricesChannelmap.get(allkeys).get(allpossiblechannels) == null)
                        {
                        Dlrpricesmap.get(allkeys).put(allpossiblechannels,null);
                        DisplayColumnsOrnot.put(allkeys+'-'+allpossiblechannels,'NORECORD');
                        System.debug('Dlrpricesmap WRAPPER :' +Dlrpricesmap);
                        System.debug('ALL KEYS :' +allkeys);
                        }
                        if (DlrpricesChannelmap.get(allkeys).get(allpossiblechannels) != null)
                        {
                        DisplayColumnsOrnot.put(allkeys+'-'+allpossiblechannels,'RECORDFOUND');
                        }                       
                        }
                       System.debug('DisplayColumnsOrnot WRAPPER :' +DisplayColumnsOrnot);
                       System.debug('DlrpricesmapWRAPPER :' +Dlrpricesmap);
                        }
                       
      }
}

}
}