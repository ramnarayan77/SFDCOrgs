public  with sharing Class CloneProjectTemplate {
Public static String ProjtempId{get;set;}
Public String CloneYN{get;set;}
     public static void InsertCloneProjTemp (List<Project_Template__c> Triggerlist) 
     {
      ProjtempId = ApexPages.currentPage().getParameters().get('retURL');
      //CloneYN = ApexPages.currentPage().getParameters().get('Clone');
      //System.debug ('Value of Clone is '+CloneYN +' '+'Value of Id is  '+ProjtempId);
   
      //{    
     // List<String> nameList = new List<String>();
     // }
      /*
      for( Milestone1_Project__c tm : triggerList ){ nameList.add( tm.Name ); }
      Integer projectCount = [SELECT count() FROM Milestone1_Project__c WHERE Name IN: nameList limit 1];
      */
      
      //TODO Flesh out to be more specific -- right now this flags every project as problematic even if only one has a duplicate name
     } 
      
}