/*
* @author: Ayoub GHAMMAZ
* @date: 08/09/2021
* @ Description schedulable planifier chaque jour à 18h pour lancer le batch : Batch010_RequeteProcessusRestitution45j
* @TestClass: SCHD010_RequProcessusRestit_test
* @Coverage: 100%
* History
* <Date of modification>   <Author>    <Description of modification>
*/
global class SCHD010_RequeteProcessusRestit implements Schedulable {
    global void execute(SchedulableContext SC) {
        String jobID = database.executebatch(new Batch010_RequeteProcessusRestitution45j());
        
    }
}