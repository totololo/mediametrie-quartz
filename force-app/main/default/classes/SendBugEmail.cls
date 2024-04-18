/**
* @description       : 
* @author            : Anes BOUZOUINA
* @group             : 
* @last modified on  : 10-26-2022
* @last modified by  : Anes BOUZOUINA
**/
public with sharing class SendBugEmail {
    public static void SendBugEmail(String body) {
        // First, reserve email capacity for the current Apex transaction to ensure
        // that we won't exceed our daily email limits when sending email after
        // the current transaction is committed.
        // Messaging.reserveSingleEmailCapacity(200);
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        
        // Strings to hold the email addresses to which you are sending the email.
        String[] toAddresses = new String[] {'anes.bouzouina@ei-technologies.com'}; 
            // String[] ccAddresses = new String[] {''};
            
            
            // Assign the addresses for the To and CC lists to the mail object.
            mail.setToAddresses(toAddresses);
        // mail.setCcAddresses(ccAddresses);
        
        // Specify the address used when the recipients reply to the email. 
        mail.setReplyTo('anes.bouzouina@cognizant.com');
        
        // Specify the name used as the display name.
        mail.setSenderDisplayName('Support Salesforce');
        
        // Specify the subject line for your email address.
        mail.setSubject('Erreur dans le CTI');
        
        // Set to True if you want to BCC yourself on the email.
        mail.setBccSender(false);
        
        // Optionally append the Salesforce email signature to the email.
        // The email address of the user executing the Apex Code will be used.
        mail.setUseSignature(false);
        
        // Specify the text content of the email.
        system.debug('body = '+body);
        
        mail.setPlainTextBody(body);
        
        
        // mail.setHtmlBody('Your case:<b> ' + case.Id +' </b>has been created.<p>'+
        //      'To view your case <a href=https://MyDomainName.my.salesforce.com/'+case.Id+'>click here.</a>');
        
        // Send the email you have created.
        // Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        if(!Test.isRunningTest()) {
            List<Messaging.SendEmailResult> results = Messaging.SendEmail(new Messaging.Email[] { mail });
            System.debug(results);
            /*if (!results.get(0).isSuccess()) {
                System.StatusCode statusCode = results.get(0).getErrors()[0].getStatusCode();
                String errorMessage = results.get(0).getErrors()[0].getMessage();
            }*/
        }
    }
}