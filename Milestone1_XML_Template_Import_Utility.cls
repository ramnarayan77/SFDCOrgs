global with sharing class Milestone1_XML_Template_Import_Utility {
    
   global with sharing class XML_Metadata {
     String ExportVersion; 
     String ExportAuthor;
     String ExportPackage;
     String ExportOrganization;
     DateTime ExportCreateDate;
   }
    
    Project_Template__c project;
    List<Project_Template_Activity__c> milestones;
    List<Project_Template_Activity__c> subMilestones;
    /**
      *Bug # 44.
      *Modified Date:04-18-2012.
      *Owner: Persistent.
      *Comments:Importing the project with all the relationships intact.
    */
    List<Project_Template_Activity__c> successorsList;
    List<Project_Template_Activity__c> parentmiles;
    List<Project_Template_Activity__c> tasks;
    List<Milestone1_Task__c> subTasks;
    List<Milestone1_Time__c> times;
    XML_Metadata metadata = new XML_Metadata();

    global Milestone1_XML_Template_Import_Utility()
    {
        project = new Project_Template__c();
        milestones = new List<Project_Template_Activity__c>();
        subMilestones = new List<Project_Template_Activity__c>();
        /**
         *Bug # 44.
         *Modified Date:04-18-2012.
         *Owner: Persistent.
         *Comments:Importing the project with all the relationships intact.
        */
        successorsList=new List<Project_Template_Activity__c>();
        tasks = new List<Project_Template_Activity__c>();
        subTasks = new List<Milestone1_Task__c>();
        times = new List<Milestone1_Time__c>();
    }
    
    global Project_Template__c importProject(String xml) {

Savepoint sp = Database.setSavepoint();
try{
Xmlstreamreader reader = new Xmlstreamreader(xml);
while (reader.hasNext()) {
if (reader.getEventType() == XmlTag.START_ELEMENT && reader.getLocalName() == Milestone1_Constants.XML_META) {
//System.debug(LoggingLevel.warn, 'Parse XML Metadata');
parseMeta(reader);
}
if (reader.getEventType() == XmlTag.START_ELEMENT && reader.getLocalName() == Milestone1_Template_Constants.OBJ_NAME_PROJECT_TEMPLATE ) {
//System.debug(LoggingLevel.warn, 'Parse XML Project');
parseProject(reader);
}
reader.next();
}
insertSalesforceObjects();
}catch(Exception ex){
Database.rollback(sp);
throw ex;
//throw new Milestone1_Import_Exception(Milestone1_Import_Exception.ERROR_INVALID_XML);
}
        return project;
    }

    private void insertSalesforceObjects()
    {
        //System.debug('Number of Milestones: ' + this.milestones.size());
        //System.debug('Number of Tasks: ' + this.tasks.size());
        if(project == null || project.Name == null || project.Legacy_System_ImportId__c == null || project.Legacy_System_ImportId__c.length() < 15)
        {
            throw new Milestone1_Import_Exception(system.label.Milestone1_ProjectCannotBeNull);
        }
        
        //attempt to validate 10 variations of the name
        String targetName = '%' + project.Name + '%';
        Integer existingLikeName = [Select Count() from Milestone1_Project__c where Name LIKE :targetName];
        if(existingLikeName!=null && existingLikeName > 0)
        {
            project.Name = project.Name + ' Copy ' + (existingLikeName +1);
        }
        
        insert project;
        
            for(Project_Template_Activity__c currentMilestone : milestones)
            {
                currentMilestone.Related_Project_Template__c = project.Id;
                if(currentMilestone.Legacy_Parent_Milestone_Id__c !=null)
                    {
                        successorsList.add(currentMilestone);
                        //currentMilestone.Predecessor_Milestone_Import_Id__c=currentMilestone.Predecessor_Milestone__c;
                        currentMilestone.Predecessor_Milestone__c=null;
                        //Because If the Milestone is already there and modified
                    }
              }
        
        insert milestones;
        
        for(Project_Template_Activity__c currentMilestone : milestones)
        {
            //currentMilestone.Project__c = project.Id;
            matchMilestonesToMilestones(subMilestones,currentMilestone);
        }
        
        for(Project_Template_Activity__c currentMilestone : subMilestones)
        {
        currentMilestone.Related_Project_Template__c = project.Id;
        if(currentMilestone.Milestone_OR_Task__c !='Task' && (currentMilestone.Legacy_Parent_Milestone_Id__c != null || currentMilestone.Legacy_Parent_Milestone_Id__c != 'null'))
                    {
                        successorsList.add(currentMilestone);
                        //currentMilestone.Predecessor_Milestone_Import_Id__c=currentMilestone.Predecessor_Milestone__c;
                        //currentMilestone.Predecessor_Milestone__c=null;
                    }
        }            
        insert subMilestones;
        //updateParentMilestones(subMilestones);

      for(Project_Template_Activity__c currentMilestone : milestones){
          updatePredecessorMilestones(currentMilestone);
        }
        for(Project_Template_Activity__c currentMilestone: subMilestones){
          updatePredecessorMilestones(currentMilestone);
        }
    
    
Map<String,Id> ListMiles = new Map<String,Id>();
 
For( Project_Template_Activity__c Miles : [ SELECT Legacy_Project_Template_Activity_Id__c, id FROM Project_Template_Activity__c where Milestone_OR_Task__c ='MileStone'] )
{
                ListMiles.put(Miles.Legacy_Project_Template_Activity_Id__c,Miles.Id);
}
        
        /*
        for(Project_Template_Activity__c currentMilestone : milestones)
        {
            currentMilestone.Related_Project_Template__c = project.Id;
            matchMilestonesToMilestones(subMilestones,currentMilestone);
        }
        */
        
        

        
        
        /*
        for(Project_Template_Activity__c currentMilestone : milestones){
            updatePredecessorMilestones(currentMilestone);
        }
        for(Milestone1_Milestone__c currentMilestone: subMilestones){
            updatePredecessorMilestones(currentMilestone);
        }
        */
        
        update successorsList;
        //System.debug('NUMBER OF TASKS == ' + tasks.size());
  
        
        
        for(Project_Template_Activity__c currentTask : tasks)
            {
                /*
                currentTask.Predecessor_Task_Import_Id__c=currentTask.Predecessor_Task__c;
                currentTask.Predecessor_Task__c=null;
                */
                currentTask.Related_Project_Template__c = project.Id; 
                currentTask.Parent_Milestone__c= ListMiles.get(currentTask.Legacy_Project_Template_Milestone_Id__c); 
                
            }
        
         
        insert tasks;
        system.debug('tasks'+tasks);
        
        /*
        for(Milestone1_Task__c currentTask : tasks){
                matchTaskToTask(currentTask);
        }
        */
        
        //update subtasks;
        system.debug('subtasks'+subtasks);
        
    }
    
   
    global void updatePredecessorMilestones(Project_Template_Activity__c currentMilestone){
        
        for(Project_Template_Activity__c milestone:successorsList){
            
            if(milestone.Legacy_Parent_Milestone_Id__c==currentMilestone.Legacy_Project_Template_Activity_Id__c)
                {
                    milestone.Predecessor_Milestone__c=currentMilestone.Id;
                    //milestone.Project__c = currentMilestone.Project__c;
                }
        }
    }
   
    
    global void matchMilestonesToMilestones(List<Project_Template_Activity__c > milestones, Project_Template_Activity__c  currentMilestone){
        for(Project_Template_Activity__c currentSubMilestone : milestones)
        {
            if(currentSubMilestone.Legacy_Parent_Milestone_Id__c == currentMilestone.Legacy_Project_Template_Activity_Id__c)
            {
                currentSubMilestone.Parent_Milestone__c = currentMilestone.Id;
                //currentSubMilestone.Project__c = currentMilestone.Project__c;
            }
        }
    }
    
    global Boolean matchTaskToMilestone(List<Milestone1_Milestone__c> milestones, Milestone1_Task__c currentTask){
        for(Milestone1_Milestone__c currentMilestone : milestones){
            if(currentTask.Project_Milestone__c == currentMilestone.ImportID__c){
                currentTask.Project_Milestone__c = currentMilestone.Id;
                return true;
            }
        }
        return false;
    }
    global void matchTaskToTask(Milestone1_Task__c currentTask){
        for(Milestone1_Task__c task:subTasks){
             if(task.Predecessor_Task_Import_Id__c==currentTask.ImportID__c){
                 task.Predecessor_Task__c=currentTask.id;
             }
        }
    }
    global Boolean matchTimeToTask(List<Milestone1_Task__c> tasks, Milestone1_Time__c currentTime){
    for(Milestone1_Task__c currentTask : tasks){
    if(currentTime.Project_Task__c == currentTask.ImportID__c){
    currentTime.Project_Task__c = currentTask.Id;
    return true;
    }
    }
    return false;
    }

    global void parseProject(Xmlstreamreader reader) {
        //name goes to name
        //id goes to importid
        //System.debug(LoggingLevel.warn, 'in Project');
        while (reader.hasNext()) {
            //handle name field
            //system.debug(reader.getLocalName());
            if (reader.getEventType() == XMLTag.START_ELEMENT && reader.getLocalName() == 'Name') {
                //system.debug('Processing Project Name');
                reader.next();
                project.Name = getDecodedString(reader);
                if (project.Name.length() == 0) {
                    throw new Milestone1_Import_Exception(system.label.Milestone1_InvalidName);
                }
            }
            
            if (reader.getEventType() == XMLTag.START_ELEMENT && reader.getLocalName() == 'ProjDescription') {
                //system.debug('Processing Project Desc');
                reader.next();
                project.Template_Description__c = getDecodedString(reader);
            }
            if (reader.getEventType() == XMLTag.START_ELEMENT && reader.getLocalName() == 'ProjTempStatus') {
                //system.debug('Processing Project Stat');
                reader.next();
                project.Status__c = getDecodedString(reader);
            }
            if (reader.getEventType() == XMLTag.START_ELEMENT && reader.getLocalName() == Milestone1_Template_Constants.OBJ_NAME_MILESTONE ) {
                //system.debug('Processing Project Milestone');
                reader.next();
                parseMilestone(reader,null);
            }
            
            
            if (reader.getEventType() == XMLTag.START_ELEMENT && reader.getLocalName() == 'LegacySystemId') {
                //System.debug(LoggingLevel.warn, 'in id');
                reader.next();
                project.Legacy_System_ImportId__c = getDecodedString(reader);
                //system.debug('Import ID == ' + project.ImportID__c);
                if (project.Legacy_System_ImportId__c.length() > 15) {
                    project.Legacy_System_ImportId__c = project.Legacy_System_ImportId__c.substring(0,15);
                }
                if (project.Legacy_System_ImportId__c.length() != 15) {
                    throw new Milestone1_Import_Exception('Invalid Legacy_System_ImportId__c (length must be 15)');
                }
            }
            //validate that we're done
            if(reader.getEventType() == XMLTag.END_ELEMENT && reader.getLocalName() == Milestone1_Template_Constants.OBJ_NAME_PROJECT_TEMPLATE){
                //system.debug('Break out of TASK');
                break;
            }
            reader.next();
        }
    }
    
    global void parseMilestone(Xmlstreamreader reader, Project_Template_Activity__c parentMilestone)
    {
        
        Project_Template_Activity__c currentMilestone = new Project_Template_Activity__c();
        if(parentMilestone != null)
        {
            //System.debug(LoggingLevel.warn, 'in SUB Milestone');
            currentMilestone.Legacy_Parent_Milestone_Id__c = parentMilestone.Legacy_Project_Template_Activity_Id__c;
        }else
        {
        }
        currentMilestone.Legacy_Project_Template_Id__c = project.Legacy_System_ImportId__c;
        
        while (reader.hasNext()){
            if (reader.getEventType() == XMLTag.START_ELEMENT && reader.getLocalName() == 'Id') {
                reader.next();
                currentMilestone.Legacy_Project_Template_Activity_Id__c = getDecodedString(reader);
            }
            if (reader.getEventType() == XMLTag.START_ELEMENT && reader.getLocalName() == 'Name') {
                reader.next();
                currentMilestone.Name = getDecodedString(reader);
            }
            /*
            if (reader.getEventType() == XMLTag.START_ELEMENT && reader.getLocalName() == 'Legacy_Parent_Milestone_Id__c'){
                reader.next();
                currentMilestone.Legacy_Parent_Milestone_Id__c =getDecodedString(reader);
               
             }
             */
         if (reader.getEventType() == XMLTag.START_ELEMENT && reader.getLocalName() == 'MilestoneORTask') {
                reader.next();
                String val = getDecodedString(reader);
                if(val == 'M')
        {
        currentMilestone.Milestone_OR_Task__c = 'Milestone';
        }
        else
        {
                currentMilestone.Milestone_OR_Task__c = 'Task';
        }   
            }

            if (reader.getEventType() == XMLTag.START_ELEMENT && reader.getLocalName() == Milestone1_Template_Constants.OBJ_NAME_MILESTONE ) {
                //system.debug('Processing Sub Milestone');
                reader.next();
                parseMilestone(reader,currentMilestone);
            }
 
            if (reader.getEventType() == XMLTag.START_ELEMENT && reader.getLocalName() ==  Milestone1_Template_Constants.OBJ_NAME_TASK) {
                //system.debug('Processing Sub Tasks');
                reader.next();
                parseTask(reader,currentMilestone);
            }
            //system.debug('Current Milestone ---- Name == ' + currentMilestone.Name + ' ImportID__c ' + currentMilestone.ImportID__c + ' Expense Budget ' + currentMilestone.Expense_Budget__c + ' Nag ' + currentMilestone.Nag__c + ' Description ' + currentMilestone.Description__c + ' Hours Budget ' + currentMilestone.Hours_Budget__c);
            if(reader.getEventType() == XMLTag.END_ELEMENT && reader.getLocalName() == Milestone1_Template_Constants.OBJ_NAME_MILESTONE )
            {
                //system.debug('Break out of TASK');
                //parseTask(reader,parentMilestone);
                break;
            }
            reader.next();
        }
      
        if(parentMilestone != null)
        {
            subMilestones.add(currentMilestone);
        }
    
        if(parentMilestone == null)
        {
            milestones.add(currentMilestone);
        }
    }

   
    
    global void parseTask(XMLStreamreader reader, Project_Template_Activity__c currentMilestone){
system.debug('INSIDE PARSE TASK');
        Project_Template_Activity__c currentTask = new Project_Template_Activity__c();
        //currentTask.Parent_Milestone__c = currentMilestone.id ;
        //currentTask.Legacy_Project_Template_Milestone_Id__c = currentMilestone.Legacy_Project_Template_Activity_Id__c;
        while(reader.hasNext())
        {
            if (reader.getEventType() == XMLTag.START_ELEMENT && reader.getLocalName() == 'Id') {
                reader.next();
                currentTask.Legacy_Project_Template_Activity_Id__c = getDecodedString(reader);
                currentTask.Legacy_Project_Template_Milestone_Id__c =currentMilestone.Legacy_Project_Template_Activity_Id__c ;
            }
       
            if (reader.getEventType() == XMLTag.START_ELEMENT && reader.getLocalName() == 'Name') {
                reader.next();
                currentTask.Name = getDecodedString(reader);
                //if(currentTask.Name == null){system.debug('Name is NULL '); 
                //currentTask.Name = 'Name Blank';}
            }
            if (reader.getEventType() == XMLTag.START_ELEMENT && reader.getLocalName() == 'Duration') {
                reader.next();
                String val = getDecodedString(reader);
                currentTask.Duration__c = Decimal.valueOf(val);
            }
           if (reader.getEventType() == XMLTag.START_ELEMENT && reader.getLocalName() == 'Resource'){
                reader.next();
                currentTask.Resource_Applicable__c =getDecodedString(reader);
               
             }
        if (reader.getEventType() == XMLTag.START_ELEMENT && reader.getLocalName() == 'MilestoneORTask') {
                reader.next();
                String val = getDecodedString(reader);
                currentTask.Milestone_OR_Task__c = 'Task';
        }
            /*
            if (reader.getEventType() == XMLTag.START_ELEMENT && reader.getLocalName() == 'Project_Milestone__c') {
                reader.next();
                //currentMilestone.Parent_Milestone__c = currentMilestone.ImportID__c
                currentTask.Parent_Milestone__c =getDecodedString(reader);
            }
            */
            if(reader.getEventType() == XMLTag.END_ELEMENT && reader.getLocalName() == Milestone1_Template_Constants.OBJ_NAME_TASK)
            {
                //system.debug('Break out of TASK');
                break;
            }
            reader.next();
        }
        
        /*
        if( currentTask.Predecessor_Task__c != null)
        {
             subTasks.add(currentTask);
        }
        */
        tasks.add(currentTask);
    }
    
    global void parseTime(XMLStreamreader reader, Milestone1_Task__c currentTask){
        Milestone1_Time__c currentTime = new Milestone1_Time__c();
        currentTime.Project_Task__c = currentTask.ImportID__c;
        while(reader.hasNext())
        {
            if (reader.getEventType() == XMLTag.START_ELEMENT && reader.getLocalName() == 'Id') {
                reader.next();
                currentTime.ImportID__c = getDecodedString(reader);
            }
            if (reader.getEventType() == XMLTag.START_ELEMENT && reader.getLocalName() == 'Description__c') {
                reader.next();
                currentTime.Description__c = getDecodedString(reader);
            }
            if (reader.getEventType() == XMLTag.START_ELEMENT && reader.getLocalName() == 'Hours__c') {
                reader.next();
                String val = getDecodedString(reader);
                if(val != null || val != 'null'){
                    currentTime.Hours__c = Decimal.valueOf(val);
                }
            }
            if(reader.getEventType() == XMLTag.END_ELEMENT && reader.getLocalName() == Milestone1_Constants.OBJ_NAME_TIME)
            {
                //system.debug('Break out of TASK');
                break;
            }
            reader.next();
        }
        times.add(currentTime);
    }
    
    global void parseMeta(Xmlstreamreader reader) {
        //system.debug('Process Metadata');
        while (reader.hasNext()) {
            //handle name field
            if (reader.getEventType() == XMLTag.START_ELEMENT && reader.getLocalName() == Milestone1_Constants.XML_EXPORT_VERSION) {
                reader.next();
                metadata.ExportVersion = getDecodedString(reader);
                //system.debug('Version == ' + metadata.ExportVersion);
                //system.debug('Org Version == ' + Milestone1_Constants.XML_EXPORT_VERSION_VAL);
                if(metadata.ExportVersion != Milestone1_Constants.XML_EXPORT_VERSION_VAL)
                {
                    //system.debug('Throw the Exception');
                    throw new Milestone1_Import_Exception(system.label.Milestone1_InvalidVersion + metadata.ExportVersion + system.label.Milestone1_OrganizationsVersion + Milestone1_Constants.XML_EXPORT_VERSION_VAL + system.label.Milestone1_ProjectsMustBeExported);
                }
            }
            if (reader.getEventType() == XMLTag.START_ELEMENT && reader.getLocalName() == Milestone1_Constants.XML_EXPORT_PACKAGE) {
                reader.next();
                metadata.ExportPackage = getDecodedString(reader);
            }
            if (reader.getEventType() == XMLTag.START_ELEMENT && reader.getLocalName() == Milestone1_Constants.XML_EXPORT_AUTHOR) {
                reader.next();
                metadata.ExportAuthor = getDecodedString(reader);
            }
            if (reader.getEventType() == XMLTag.START_ELEMENT && reader.getLocalName() == Milestone1_Constants.XML_EXPORT_ORG) {
                reader.next();
                metadata.ExportOrganization = getDecodedString(reader);
            }
            if (reader.getEventType() == XMLTag.START_ELEMENT && reader.getLocalName() == Milestone1_Constants.XML_EXPORT_DATE) {
                reader.next();
                metadata.ExportCreateDate = DateTime.valueOf(getDecodedString(reader));
            }
            if(reader.getEventType() == XMLTag.END_ELEMENT && reader.getLocalName() == Milestone1_Constants.XML_META)
            {
                //system.debug('Break out of TASK');
                break;
            }
            reader.next();
        }
    }
    
    global String getDecodedString(Xmlstreamreader reader) {
        return EncodingUtil.urlDecode(reader.getText(), 'UTF-8').trim();
    }

}