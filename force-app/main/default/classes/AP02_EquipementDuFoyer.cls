/*
* @Auteur : Bastien Pinard
* @date: 24/08/2022
* @ Description :  test class de la fonctionnalité : 
- A l'ajout d'un equipement lié à un poste Tv on calcule le nom de cette equipement en fonction du nom du poste tv

-à la suppression d'un poste tv on recalcule le nom de de tous les equipements liés aux postes tv encore existant pour le foyer donné

* @TestClass: AP02_EquipementDuFoyer_Test
* @Coverage: 92%
History
* <Date of modification> 		<Author> 			<Description of modification>
*  22/03/23						Marliat D.			 Nommage des accessoires
*/

public with sharing class AP02_EquipementDuFoyer {
    
    public static void EquipementName(List<Equipements_du_foyer__c> listEquipementFoyer){
        List<Equipements_du_foyer__c> eqpToUpdate = new List<Equipements_du_foyer__c>();
        Id peripheriqueRecordTypeId =Schema.SObjectType.Equipements_du_foyer__c.getRecordTypeInfosByName().get(Label.EQPF_RecordType_Peripheriques).getRecordTypeId();
        Id devicesRecordTypeId =Schema.SObjectType.Equipements_du_foyer__c.getRecordTypeInfosByName().get(Label.EQF_RecodType_Device).getRecordTypeId();        
        
        //get type picklist value
        Schema.DescribeFieldResult objFieldDescribe = Equipements_du_foyer__c.Type__c.getDescribe();
        List<Schema.PicklistEntry> lstPickListValues = objFieldDescribe.getPickListValues();
        Map<String,Schema.PicklistEntry> mapPickList = new Map<String,Schema.PicklistEntry>();
        for (Schema.PicklistEntry objPickList : lstPickListValues) {
            mapPickList.put(objPickList.getLabel(),objPickList);
        }
        System.debug('mapPickList'+mapPickList);
        
        //get marque magnetoscope picklist value
        Schema.DescribeFieldResult objFieldDescribeMagn = Equipements_du_foyer__c.Marque_du_magnetoscope__c.getDescribe();
        List<Schema.PicklistEntry> lstPickListValuesMagn = objFieldDescribeMagn.getPickListValues();
        Map<String,Schema.PicklistEntry> mapPickListMagn = new Map<String,Schema.PicklistEntry>();
        for (Schema.PicklistEntry objPickList : lstPickListValuesMagn) {
            mapPickListMagn.put(objPickList.getValue(),objPickList);
        }
        
        //get Fournisseur__c picklist value
        Schema.DescribeFieldResult objFieldDescribeFournisseur = Equipements_du_foyer__c.Fournisseur__c.getDescribe();
        List<Schema.PicklistEntry> lstPickListValuesFournisseur = objFieldDescribeFournisseur.getPickListValues();
        Map<String,Schema.PicklistEntry> mapPickListFournisseur = new Map<String,Schema.PicklistEntry>();
        for (Schema.PicklistEntry objPickList : lstPickListValuesFournisseur) {
            mapPickListFournisseur.put(objPickList.getValue(),objPickList);
        }
        
        //get Modele_de_console_de_jeux__c picklist value
        Schema.DescribeFieldResult objFieldDescribeModeleConsole = Equipements_du_foyer__c.Modele_de_console_de_jeux__c.getDescribe();
        List<Schema.PicklistEntry> lstPickListValuesModeleConsole = objFieldDescribeModeleConsole.getPickListValues();
        Map<String,Schema.PicklistEntry> mapPickListModeleConsole = new Map<String,Schema.PicklistEntry>();
        for (Schema.PicklistEntry objPickList : lstPickListValuesModeleConsole) {
            mapPickListModeleConsole.put(objPickList.getValue(),objPickList);
        }
        
        //get Marque_d_ordinateur__c picklist value
        Schema.DescribeFieldResult objFieldDescribeMarqOrdi = Equipements_du_foyer__c.Marque_d_ordinateur__c.getDescribe();
        List<Schema.PicklistEntry> lstPickListValuesMarqOrdi = objFieldDescribeMarqOrdi.getPickListValues();
        Map<String,Schema.PicklistEntry> mapPickListMarqOrdi = new Map<String,Schema.PicklistEntry>();
        for (Schema.PicklistEntry objPickList : lstPickListValuesMarqOrdi) {
            mapPickListMarqOrdi.put(objPickList.getValue(),objPickList);
        }
        
        //get Marque_Tablette__c picklist value
        Schema.DescribeFieldResult objFieldDescribeMarqTabl = Equipements_du_foyer__c.Marque_Tablette__c.getDescribe();
        List<Schema.PicklistEntry> lstPickListValuesMarqTabl = objFieldDescribeMarqTabl.getPickListValues();
        Map<String,Schema.PicklistEntry> mapPickListMarqTabl = new Map<String,Schema.PicklistEntry>();
        for (Schema.PicklistEntry objPickList : lstPickListValuesMarqTabl) {
            mapPickListMarqTabl.put(objPickList.getValue(),objPickList);
        }
        
        //get Marque_de_telephone__c picklist value
        Schema.DescribeFieldResult objFieldDescribeMarqTel = Equipements_du_foyer__c.Marque_de_telephone__c.getDescribe();
        List<Schema.PicklistEntry> lstPickListValuesMarqTel = objFieldDescribeMarqTel.getPickListValues();
        Map<String,Schema.PicklistEntry> mapPickListMarqTel = new Map<String,Schema.PicklistEntry>();
        for (Schema.PicklistEntry objPickList : lstPickListValuesMarqTel) {
            mapPickListMarqTel.put(objPickList.getValue(),objPickList);
        }
        
        
        Set<Id> listPosteId = new Set<Id>();
        
        
        for(Equipements_du_foyer__c eq : listEquipementFoyer){
            listPosteId.add(eq.Poste_TV__c);
        }
        Map<Id, Equipements_du_foyer__c> mapNumeroPost = new Map<Id, Equipements_du_foyer__c>([SELECT Id, Name FROM Equipements_du_foyer__c WHERE Id IN :listPosteId]);     
        
        for(Equipements_du_foyer__c eq : listEquipementFoyer){
            if(eq.RecordTypeId==peripheriqueRecordTypeId){
                eqpToUpdate.add(evaluatePeripheriqueName(eq, mapPickList, mapNumeroPost, mapPickListMagn, mapPickListFournisseur, mapPickListModeleConsole));
            } else if(eq.RecordTypeId==devicesRecordTypeId){
                eqpToUpdate.add(evaluateDeviceName(eq, mapPickList, mapPickListMarqOrdi, mapPickListMarqTabl, mapPickListMarqTel));
            }
        }        
    }
    
    private static Equipements_du_foyer__c evaluatePeripheriqueName(Equipements_du_foyer__c eq,
                                                                    Map<String,Schema.PicklistEntry> mapPickList, 
                                                                    Map<Id,Equipements_du_foyer__c> mapNumeroPost,
                                                                    Map<String,Schema.PicklistEntry> mapPickListMagn,
                                                                    Map<String,Schema.PicklistEntry> mapPickListFournisseur,
                                                                    Map<String,Schema.PicklistEntry> mapPickListModeleConsole
                                                                   ) 
    {
        if(eq.Type__c != null){
            if(eq.Type__c == mapPickList.get(Label.EQF_Type_Magnetoscope_Label).getValue()){
                eq.Name= 'Mag ' + mapNumeroPost.get(eq.Poste_TV__c).Name;
                eq.Name+= eq.Marque_du_magnetoscope__c!=null?' '+mapPickListMagn.get(eq.Marque_du_magnetoscope__c).getLabel():'';
            } else if(eq.Type__c == mapPickList.get(Label.EQF_Type_Decodeur_Label).getValue()){
                eq.Name= 'Décodeur ' + mapNumeroPost.get(eq.Poste_TV__c).Name;
                eq.Name+= eq.Fournisseur__c!=null?' '+mapPickListFournisseur.get(eq.Fournisseur__c).getLabel():'';
            } else if(eq.Type__c == mapPickList.get(Label.EQF_Type_Lecteur_DVD_Label).getValue()){
                eq.Name= 'DVD ' + mapNumeroPost.get(eq.Poste_TV__c).Name;
            } else if(eq.Type__c == mapPickList.get(Label.EQF_Type_Console_De_Jeux_Label).getValue()){
                eq.Name= 'Console ' + mapNumeroPost.get(eq.Poste_TV__c).Name;
                eq.Name+= eq.Modele_de_console_de_jeux__c!=null?' '+mapPickListModeleConsole.get(eq.Modele_de_console_de_jeux__c).getLabel():'';
            } else if(eq.Type__c == mapPickList.get(Label.EQF_Type_Divers_Label).getValue()){
                eq.Name= 'Divers - ' + mapNumeroPost.get(eq.Poste_TV__c).Name;
            } else if(eq.Type__c == mapPickList.get(Label.EQF_Type_Caster_Label).getValue()){
                eq.Name= 'Casteur ' + mapNumeroPost.get(eq.Poste_TV__c).Name;
                eq.Name+= eq.Marque_du_Cast__c!=null?' '+eq.Marque_du_Cast__c:'';
                eq.Name+= eq.Modele_du_Cast__c!=null?' '+eq.Modele_du_Cast__c:'';
            }  else if(eq.Type__c == mapPickList.get(Label.EQF_Type_Objet_Connecte_Label).getValue()){
                eq.Name= 'Objet Connecté ';
                eq.Name+= eq.Marque_Objet_Connecte__c!=null?' '+eq.Marque_Objet_Connecte__c:'';
                eq.Name+= eq.Modele_Objet_Connecte__c!=null?' '+eq.Modele_Objet_Connecte__c:'';
            } 
        }
        return eq;
    }
    
    private static Equipements_du_foyer__c evaluateDeviceName(Equipements_du_foyer__c eq,
                                                              Map<String,Schema.PicklistEntry> mapPickList,
                                                              Map<String,Schema.PicklistEntry> mapPickListMarqOrdi,
                                                              Map<String,Schema.PicklistEntry> mapPickListMarqTabl,
                                                              Map<String,Schema.PicklistEntry> mapPickListMarqTel
                                                             ){
                                                                 if(eq.Type__c != null){
                                                                     if(eq.Type__c == mapPickList.get(Label.EQF_Type_Ordinateur_Fixe_Label).getValue()){
                                                                         eq.Name= mapPickList.get(Label.EQF_Type_Ordinateur_Fixe_Label).getLabel();
                                                                         eq.Name+= eq.Marque_d_ordinateur__c!=null?' '+mapPickListMarqOrdi.get(eq.Marque_d_ordinateur__c).getLabel():'';
                                                                     }else if(eq.Type__c == mapPickList.get(Label.EQF_Type_Ordinateur_Portable_Label).getValue()){
                                                                         eq.Name= mapPickList.get(Label.EQF_Type_Ordinateur_Portable_Label).getLabel();
                                                                         eq.Name+= eq.Marque_d_ordinateur__c!=null?' '+mapPickListMarqOrdi.get(eq.Marque_d_ordinateur__c).getLabel():'';
                                                                     }else if(eq.Type__c == mapPickList.get(Label.EQF_Type_Tablette_Label).getValue()){
                                                                         eq.Name= 'Tablette '; 
                                                                         eq.Name+= eq.Marque_Tablette__c!=null?mapPickListMarqTabl.get(eq.Marque_Tablette__c).getLabel():'';
                                                                     } else if(eq.Type__c == mapPickList.get(Label.EQF_Type_Mobile_Label).getValue()){
                                                                         eq.Name= 'Mobile '; 
                                                                         eq.Name+= eq.Marque_de_telephone__c!=null?mapPickListMarqTel.get(eq.Marque_de_telephone__c).getLabel():'';
                                                                     }
                                                                 }
                                                                 return eq;
                                                             }
    

    
    public static void UpdatePeripheriqueName(List<Equipements_du_foyer__c> listEquipementFoyer, Map<Id, Equipements_du_foyer__c>mapOldEquipements){
        
        List<Equipements_du_foyer__c> listPeripheriqueToUpdate = new List<Equipements_du_foyer__c>();
        Id posteRecordTypeId =Schema.SObjectType.Equipements_du_foyer__c.getRecordTypeInfosByName().get('Poste TV').getRecordTypeId();
        Set<Id> idsPoste = new Set<Id>();
        for(Equipements_du_foyer__c eq : listEquipementFoyer){
            if(eq.Numero_de_poste__c != mapOldEquipements.get(eq.Id).Numero_de_poste__c && eq.RecordTypeId==posteRecordTypeId){
                idsPoste.add(eq.Id);
            }
        }
        Id peripheriqueRecordTypeId =Schema.SObjectType.Equipements_du_foyer__c.getRecordTypeInfosByName().get(Label.EQPF_RecordType_Peripheriques).getRecordTypeId();
        
        List<Equipements_du_foyer__c> listPeripheriques = new List<Equipements_du_foyer__c>
            ([SELECT Id, Name, Poste_TV__r.Id, Poste_TV__r.Name
              FROM Equipements_du_foyer__c
              WHERE Poste_TV__c  IN : idsPoste 
              AND RecordTypeId=: peripheriqueRecordTypeId
              ORDER BY CreatedDate 
             ]);
        
        String regExp = 'POSTE [0-9]';
        String regExp2 = 'Poste [0-9]';

        
        if(listPeripheriques.size()>0){
            for(Equipements_du_foyer__c eq : listPeripheriques){
                String replacement = eq.Poste_TV__r.Name;
                eq.Name = eq.Name.replaceAll(regExp, replacement);
                eq.Name = eq.Name.replaceAll(regExp2, replacement);
                listPeripheriqueToUpdate.add(eq);
            }
            update listPeripheriqueToUpdate;
        }
    }
    
}