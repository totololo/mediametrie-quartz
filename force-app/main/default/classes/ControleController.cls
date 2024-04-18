/*
* @author: Astou NDIAYE
* @date: 18/10/2020
* @ Description display controle List of today
* @TestClass: ControleControlle_Test
* @Coverage: 100 %
* History
* <Date of modification>   <Author>    <Description of modification>
*/
public with sharing class ControleController {
 	@AuraEnabled
       
   //the below method is to get all controles
     public static list<Controle__c> getRelatedList(Id recordId)
    {        
        Case c =[ SELECT Id, CreatedDate, Foyer_paneliste__c FROM Case where id=:recordId limit 1 ];
        //system.debug('result case' +c);
       
       Date d =  Date.ValueOf(c.CreatedDate.Format('YYYY-MM-dd'));
     
      	system.debug('date d'+d);
        
      List<Controle__c> controleList = [Select Id, Name, Numero__c,Date_de_controle__c, Type_de_controle__c, Sous_type_de_controle__c  from Controle__c 
                                          where Foyer_paneliste__c =:c.Foyer_paneliste__c ORDER BY Numero__c ASC ];
        
        List<Controle__c> controlesdujour = new List<Controle__c>();
        
        for(Controle__c ct : controleList){
 			system.debug('ttt'+controleList);
            if (ct.Date_de_controle__c!=null){
            	if(Date.ValueOf(ct.Date_de_controle__c.Format('yyyy-MM-dd'))==d)
            		{               
               system.debug('ctrl j date'+ ct.Date_de_controle__c.Format('yyyy-MM-dd')+ct.id);
                system.debug('ctl id'+ct.id);
               controlesdujour.add(ct);
            		}
            }           
        }
       return controlesdujour;
    }
    
    
    //This method is used to handle the Edit/Delete Operation from Related List
    @AuraEnabled
    public static string deleteControle(string controleId){
 
    Controle__c clist=  [Select id from  Controle__c where id=:controleId];
    	
            Delete clist;
            return 'DONE';
    }  
}