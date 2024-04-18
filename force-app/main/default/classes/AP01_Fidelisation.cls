/*
* @author: Jérôme HE
* @date: 25/0t4/2022
* @ Description : Simplification du message d'erreur pour les fidélisation
* @TestClass: AP02_IndividuPaneliste_Test
* @Coverage: --%

* History
* <Date of modification>   <Author>    <Description of modification>
*/
public class AP01_Fidelisation {
    @InvocableMethod
    public static List<String> getfidelisationVRMessage(List<String> s){       
        
        if(s[0].contains('FIELD_CUSTOM_VALIDATION_EXCEPTION')){
            //system.debug(s.substringBetween('FIELD_CUSTOM_VALIDATION_EXCEPTION:','Vous pouvez consulter les valeurs ExceptionCode'));
            s[0] = s[0].substringBetween('FIELD_CUSTOM_VALIDATION_EXCEPTION:','Vous pouvez consulter les valeurs ExceptionCode');

        }
        return s;
    }
}