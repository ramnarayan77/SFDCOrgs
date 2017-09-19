global class batchAccountUpdateSchedulable implements Schedulable{
    global void execute(SchedulableContext ctx){
        batchAccountUpdate marketingCloudBatch = new batchAccountUpdate();
        Database.executeBatch(marketingCloudBatch, 1);
    }   
}