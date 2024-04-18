/**
 * @description       : 
 * @author            : Anes BOUZOUINA
 * @group             : 
 * @last modified on  : 10-21-2022
 * @last modified by  : Anes BOUZOUINA
**/
global class ScheduleBatch022_CreateAppel implements Schedulable {


    public static String sched = label.ScheduleBatch022;  

    global static String scheduleMe() {
        ScheduleBatch022_CreateAppel SC = new ScheduleBatch022_CreateAppel(); 
        return System.schedule('Création des appels', sched, SC);
    }

    global void execute(SchedulableContext sc) {

        Batch022_CreateAppel b1 = new Batch022_CreateAppel();
        ID batchprocessid = Database.executeBatch(b1,100);           
    }
}