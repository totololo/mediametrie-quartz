/*
* @author: YH
* @date: 30/09/2021
* @ Description arrondir la date de début planifié
* @TestClass: AP08_ServiceAppointment_Test
* @Coverage:94%
* History
* <Date of modification>   <Author>    <Description of modification>
*/ 

public class AP08_ServiceAppointment {
    public static void RoundSchedStart(list<ServiceAppointment> ListeSaUpdated){
        String minute;
        integer minutes;
        integer minutes_arrondies;
        
        
        for (ServiceAppointment sa: ListeSaUpdated){
            IF (sa.SchedStartTime !=null){
            minute= string.valueOf(sa.SchedStartTime.minute()); 
            
            
               
                system.debug(sa.SchedStartTime);
                minutes=integer.valueof(minute);            
                integer year = integer.valueof(string.valueOf(sa.SchedStartTime.year()));
                integer month= integer.valueof(string.valueOf(sa.SchedStartTime.month()));
                integer day= integer.valueof(string.valueOf(sa.SchedStartTime.day()));
                integer hours= integer.valueof(string.valueOf(sa.SchedStartTime.hour()));
                if (math.mod(minutes,10)<5){
                    minutes_arrondies=minutes - math.mod(minutes,10);
                }
                else {
                    minutes_arrondies=minutes + ( 10 - math.mod(minutes,10));
                }
         
                sa.SchedStartTime= DateTime.newInstance(year,month,day,hours ,minutes_arrondies,0);}
            IF (sa.SchedStartTime !=null){
               sa.SchedEndTime= sa.SchedStartTime.addMinutes(Integer.valueof(sa.Duration));
            }
            
        }
    }
}