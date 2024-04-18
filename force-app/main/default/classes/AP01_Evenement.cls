/*
* @author: Khaled Hammoudeh
* @date: 05/10/2020
* @ Description Class that updates the status of Étiquettes when an event TV ON is created for the poste
* @TestClass: AP01_Evenement_Test
* @Coverage: 100 %
* History
* <Date of modification>   <Author>    <Description of modification>
*/
public class AP01_Evenement {
    
    public static void updateEtiquettesStatus(list<Evenement__c> listEvenements)
    {
        list<string> listEquipementsIds = new list<string>();
        for(Evenement__c evenement : listEvenements)
        {
            listEquipementsIds.add(evenement.Meter__c);
        }
        
        list<Etiquette__c> listEtiquettes = [Select id, Date_de_debut__c, Date_de_fin__c, Nom_de_l_etiquette__c, Poste__c, Foyer__c, Statut__c
                                                     FROM Etiquette__c
                                                     Where Date_de_fin__c >=: date.today()
                                                     AND Statut__c =: Label.ETI_Statut_Actif
                                                     AND Poste__c IN: listEquipementsIds];
        
        list<Etiquette__c> listEtiquettesToUpdate = new list<Etiquette__c>();
        for(Etiquette__c etiquette : listEtiquettes)
        {
            etiquette.Statut__c = Label.ETI_Statut_Inactif;
            listEtiquettesToUpdate.add(etiquette);
        }
        
        if(listEtiquettesToUpdate.size() > 0)
        {
            update listEtiquettesToUpdate;
        }
    }
}