@isTest
public with sharing class TestDataFactory{
    
     public static List<Controle__c> createControles( Integer numCon){
                    
     List<Controle__c> controles= new List<Controle__c>();
     List<Account> foyers= creerFoyers(numCon);
        for(Account a : foyers){
   
           controles.add(new Controle__c(
                                    Name = 'Test Controle',
             						Statut__c='Actif',
                                    Foyer__c =a.Id,
                                    Date_de_controle__c = Date.today()));
                                    
            } 
            	insert controles;
                      
           return controles;
     }
    

         public static List<Account> creerFoyers(Integer nbfoyers){

        List<Account> foyers = new List<Account>();

        for (Integer nbfoyercrees= 0; nbfoyercrees < nbfoyers; nbfoyercrees++) {
            foyers.add(new Account(Name = 'Foyer ' + nbfoyercrees, 	Type_de_foyer__c='Test type'+ nbfoyercrees, Statut_du_foyer__c='test '+ nbfoyercrees,
                                   Statut_audimetrique__c= 'Test statut'+ nbfoyercrees));
        }

        insert foyers;

        return [SELECT Name FROM Account WHERE Name LIKE 'Foyer _'];
          
            
    }
    
    
     }