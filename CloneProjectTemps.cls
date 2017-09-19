public class CloneProjectTemps{

Public Project_Template__c ProjTempId;

public CloneProjectTemps()
{
system.debug('INSIDE CLASS');
}

public void InsertProjTemps ()
{
system.debug('INSIDE CLASS');
//system.debug('Value of ProjId is '+ProjId);
//ProjTempId = [Select Id,Name from Project_Template__c where Id = :ProjId];
}

}