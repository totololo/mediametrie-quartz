public with sharing class SCHD020_AnonymisationConfirmee implements Schedulable {
    public SCHD020_AnonymisationConfirmee() {

    } 
    public void execute(SchedulableContext sc){
        database.executeBatch(new Batch020_Eligibilite_Anonymisation());
    }
}