/*
* @author: Claire VEHRLE
* @date: 27/06/2022
* @ Description Class that tests the execution of AP02_IndividuPaneliste and IndividuPanelisteAfterInsert
* History
* <Date of modification>   <Author>    <Description of modification>		
*/
@isTest
public class AP01_Fidelisation_Test {

    @isTest
    static void testErreur() {
        String error = 'FIELD_CUSTOM_VALIDATION_EXCEPTION';
        List<String> errorList = new List<String>();
        errorList.add(error);
        AP01_Fidelisation.getfidelisationVRMessage(errorList);
    }
}