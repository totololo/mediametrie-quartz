/*
* @date: 29/10/2021
* @ Description : Envoie de SMS dans le cas de requête Contrôle AIP non répondant
* @Auteur : Claire VEHRLE
* @TestClass: AP01_SendEmail_Test
* @Coverage: 81 %
History
* <Date of modification> 		<Author> 			<Description of modification>
*/
public class AP01_SendEmail {

    public static void sendEmail(List<String> toMailAddress, String senderName, String subject, String emailBody, Id emailTemplateId) {
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        
        mail.setToAddresses(toMailAddress);
        if (senderName != null) {
            mail.setSenderDisplayName(senderName);
        }
        
        mail.setSubject(subject);
        
        if (emailBody !=null ) {
            mail.setPlainTextBody(emailBody);
        }
        else if (emailTemplateId != null) {
            mail.setTemplateID(emailTemplateId); 
        }
        
        
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
}