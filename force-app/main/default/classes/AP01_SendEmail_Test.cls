/*
* @Auteur Claire VEHRLE
* @date: 25/11/2021
* @Classe: AP01_SendEmail
* * History
* <Date of modification>   		<Author>    		<Description of modification>
*/
@isTest
public class AP01_SendEmail_Test {

    @isTest
    static void sendEmailTest () {
        List<String> toMailAddress = new List<String>();
        toMailAddress.add('testAP01SendEmailMadiametrie@gmail.com');
        String senderName = 'AP01_Test';
        String subject = 'Test de AP01_SendEmail';
        String emailBody = 'Ceci est un test';
        AP01_SendEmail.sendEmail(toMailAddress, senderName, subject, emailBody, null);
    }
}