/*
* @author: Maribelle ZARAZIR EI
* @date: 08/2021
* @ Description Batch quotidien qui crée des lignes de débits pour mettre à 0 les soldes des Foyers chutés il y plus de 70 jours
* @TestClass: Batch009_Debit_RemiseSoldeAZero_Test
* @Coverage: 88%
* History
* <Date of modification>   <Author>    <Description of modification>
*/
global class Batch009_Debit_RemiseSoldeAZero implements Database.Batchable<sObject>, Database.Stateful {
    
    //Added for email notification - START
    global String errorTxt = '';
    global Boolean containsErrors = false;
    //Added for email notification - END
    global Boolean userByPass;
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        
        User currentUser = [SELECT Id, Bypass_validation_rules__c FROM User WHERE Id = :UserInfo.getUserId()];
        userByPass = currentUser.Bypass_validation_rules__c; //saved for later
        currentUser.Bypass_validation_rules__c = True;
        update currentUser;
        
        //Passer sur les Foyers qui ont été chutés il y a plus de 70 jours et dont le solde n'a pas encore été remise à 0
        String query = 'SELECT Id, Solde_de_points__c, ACC_EXTId_SIPanel__c,(select id,Date_de_chute__c,ACC_EXTId_SIPanel__c,Foyer__c,Foyer__r.Solde_de_points__c,TECH_TypePanel__c ,foyer__r.Contact_principal__r.id from Panelistes__r ) '+
            + 'FROM Account  '
            + 'WHERE   Solde_de_points__c > 0 and id in (select Foyer__c from Foyer_paneliste__c where Statut_Foyer_paneliste__c =\'5\')  ';
          // String query = 'select id, (select id,Date_de_chute__c,ACC_EXTId_SIPanel__c,Foyer__c,Foyer__r.Solde_de_points__c,TECH_TypePanel__c ,foyer__r.Contact_principal__r.id from Panelistes__r )  from account where id=\'0013X00003QhBtvQAF\'';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext bc, List<Account> scope){
        system.debug('$$$ scope ' + scope);
        
        List<Fidelisation__c> listeLignesDebits = new List<Fidelisation__c>();
        Fidelisation__c ligneDeDebit;
        
        Id debitRecordTypeId = Schema.SObjectType.Fidelisation__c.getRecordTypeInfosByDeveloperName().get('Debit').getRecordTypeId();
        map<account,id> accountFoyerpan = new map<account,id>();
       
       List<account> NotAllchute =new list<account>();
       List<account> Allchute = new list<account>();
        Foyer_paneliste__c  fp;
       map<account,list<Foyer_paneliste__c>> AccFoyerpan = new map<account,list<Foyer_paneliste__c>>();
        for(Account acc : scope)
              
        {
            system.debug('aa'+acc);
            for (Foyer_paneliste__c f: acc.Panelistes__r ){
                if (f.Date_de_chute__c!=null && f.Date_de_chute__c > system.today().adddays(-70)){
                    system.debug('ttt'+f.Date_de_chute__c );
                     NotAllchute.add(acc);
                }
            }
        }
        for(Account acc : scope){
            if(!NotAllchute.contains(acc)){
                Allchute.add(acc);
            }    
        }
        
        for (account acc: Allchute){
                    AccFoyerpan.put(acc,acc.panelistes__r);
        }
        system.debug(' aa'+Allchute.size());
        for (account acc:Allchute )  {
           fp=dernierChute(AccFoyerpan.get(acc));
           listeLignesDebits.add(NewFID(fp.id,fp.Foyer__c,debitRecordTypeId, '5',fp.Foyer__r.Solde_de_points__c,fp.Foyer__r.Solde_de_points__c));
        }

            //listeLignesDebits.add(ligneDeDebit);
        
        if(listeLignesDebits != null && listeLignesDebits.size() > 0)
        {
            try
            { 
               insert listeLignesDebits;
            }
            Catch(exception ex)
            {
                system.debug('Insert FID Exception Error: ' + ex.getmessage());
                //added for notification
                errorTxt += 'Erreur durant la création des lignes de débit : ' + ex.getMessage() + '\n';
                containsErrors = true;
            }  
        }
        }
    
    
    
        
    global void finish(Database.BatchableContext bc){
        
        //Added for notifications - START
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        List<String> toMailAddress = System.Label.BatchNotif_B009_ToAddress.split(';');
        
        mail.setToAddresses(toMailAddress);
        mail.setSenderDisplayName(System.Label.BatchNotif_B009_SenderName);
        mail.setSubject(System.Label.BatchNotif_B009_Subject+'-'+date.today().format());
        
        String emailBody = 'L\'exécution du batch Batch009_Debit_RemiseSoldeAZero s\'est terminée.\n';
        if(containsErrors) {
            emailBody += 'Les erreurs suivantes ont été rencontrées :\n\n';
            emailBody += errorTxt;
        } else {
            emailBody += 'Aucune erreur n\'a été relevée.';
        }
        mail.setPlainTextBody(emailBody);
        
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        //Added for notifications - END
    }


public static Fidelisation__c NewFID(ID foyerPanId,ID AccounId,Id recordTypeIdFIDcredit,String TypeMouvement,Decimal Pointsdebites,Decimal Soldecreation) {
        Fidelisation__c FID = new Fidelisation__c();
            Id debitRecordTypeId = Schema.SObjectType.Fidelisation__c.getRecordTypeInfosByDeveloperName().get('Debit').getRecordTypeId();

        List <Individu_Paneliste__c> ind = new List <Individu_Paneliste__c>();
        if(TypeMouvement!=null  && Pointsdebites!=null)
        {
                ind = [select id,Composition_du_foyer__c from Individu_Paneliste__c where Foyer_paneliste__c =:foyerPanId ];
     
            system.debug(ind); 
            // system.debug(ind[0].Id);
            FID.Foyer_paneliste__c=foyerPanId;
            FID.Type_de_mouvement__c=TypeMouvement;
            FID.RecordTypeId = debitRecordTypeId;
            FID.Foyer__c=AccounId;
            FID.Points_debites__c=Pointsdebites;
            FID.Solde_de_points_a_creation__c=Pointsdebites;
            if(ind.size()> 0) {
                FID.Composition_du_foyer__c	=ind[0].Composition_du_foyer__c ;
            }
            if( (ind.size() > 0) ){
                FID.Individu_paneliste__c = ind[0].Id;
            }
            
        }

        return FID;
    }
    
    Public static Foyer_paneliste__c dernierChute(list<Foyer_paneliste__c> FoyerPan){
        Foyer_paneliste__c dernier=FoyerPan[0];
        for (Foyer_paneliste__c pan:FoyerPan ){
            if (pan.Date_de_chute__c > dernier.Date_de_chute__c){
                dernier= pan;
            }
        }
        return dernier;
    }
}