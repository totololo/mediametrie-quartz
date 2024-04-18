public with sharing class getEquipementsduFoyer {
    @AuraEnabled
    public static wrapperType getEquipementsduFoyer() {
        wrapperType tableData = new wrapperType();
        EquipmentWrapper equipmentWrapper = new EquipmentWrapper();
        Id contactId;
        
        List<user> connectedUser = [SELECT Id, contactId, Contact.Contact_principal__c, Contact.AccountId
                                    FROM user 
                                    WHERE Id = :UserInfo.getUserId()];
        if(connectedUser.size() > 0){
            contactId = connectedUser[0].contactId;
        }
        
        System.debug('contactId ' + contactId);
        if(String.isNotBlank(contactId)){
            for(Individu_Paneliste__c ind :[SELECT Id, Composition_du_foyer__c, Foyer_paneliste__r.RecordType.Name
                                            FROM Individu_Paneliste__c 
                                            WHERE Composition_du_foyer__c = :contactId
                                            LIMIT 1])
            {
                tableData.userRecordTypeName = ind.Foyer_paneliste__r.RecordType.Name;
            }
            
            if(String.isNotBlank(connectedUser[0].Contact.AccountId)){
                //Get equipment types Picklist labels
                Map<String, String> equipmentTypesMap = new Map<String, String>();
                for(ContactFormulaire.wrapperType equipement : ContactFormulaire.getPicklistValues(Equipements_du_foyer__c.Type__c)){
                    equipmentTypesMap.put(equipement.value, equipement.label);
                }
                String contactType = ContactFormulaire.contactType();
                if(contactType == 'AIP'){
                    String assetType;
                    for(Asset asset : [SELECT Id, ToLabel(Emplacement_dans_le_foyer__c), Batterie__c, Date_de_premiere_installation__c, 
                                       ToLabel(Type_de_materiel__c)
                                       FROM Asset
                                       WHERE AccountId = :connectedUser[0].Contact.AccountId
                                       ORDER BY Name ASC NULLS LAST ])
                    {
                        assetType = asset.Type_de_materiel__c == 'Pager' ? 'Audimètre porté' : asset.Type_de_materiel__c == 'Setmeter' ? 
                                    'Audimètre fixe' : asset.Type_de_materiel__c == 'Beacon' ? ' Borne de localisation' : asset.Type_de_materiel__c;

                        equipmentWrapper = new EquipmentWrapper(assetType, String.valueOf(asset.Batterie__c), 
                                                                asset.Emplacement_dans_le_foyer__c, 
                                                                String.valueOf(asset.Date_de_premiere_installation__c),
                                                                '-', '-');
                         tableData.equipements.add(equipmentWrapper);
                    }
                }else{
                    for(Equipements_du_foyer__c equipement :[SELECT Id, Name, ToLabel(Emplacement__c), ToLabel(Marque_TV__c),ToLabel(Marque_Tablette__c), 
                                                         ToLabel(Marque_du_magnetoscope__c), ToLabel(Marque_de_telephone__c),
                                                         ToLabel(Marque_d_ordinateur__c), Utilisateur_principal__r.FirstName,
                                                         Utilisateur_principal__r.Name, Batterie__c, Date_d_installation__c, ToLabel(Type__c)
                                                         FROM Equipements_du_foyer__c
                                                         WHERE Foyer__c =:connectedUser[0].Contact.AccountId
                                                         OR Utilisateur_principal__r.AccountId =: connectedUser[0].Contact.AccountId
                                                         ORDER BY Name ASC NULLS LAST 
                                                        ])
                    {
                        equipmentWrapper = new EquipmentWrapper(equipement.Type__c, String.valueOf(equipement.Batterie__c), equipement.Emplacement__c, 
                                                                String.valueOf(equipement.Date_d_installation__c), equipement.Utilisateur_principal__r.FirstName, '-');
                        
                        equipmentWrapper.marque = String.isNotBlank(equipement.Marque_TV__c) ? equipement.Marque_TV__c : 
                        String.isNotBlank(equipement.Marque_Tablette__c) ? equipement.Marque_Tablette__c :
                        String.isNotBlank(equipement.Marque_du_magnetoscope__c) ? equipement.Marque_du_magnetoscope__c :
                        String.isNotBlank(equipement.Marque_de_telephone__c) ? equipement.Marque_de_telephone__c :
                        String.isNotBlank(equipement.Marque_d_ordinateur__c) ? equipement.Marque_d_ordinateur__c :
                        String.isNotBlank(equipement.Marque_de_telephone__c) ? equipement.Marque_de_telephone__c : '-';
                        
                        tableData.equipements.add(equipmentWrapper);
                    }
                    
                }
                
                
            }
        }
        return tableData;
    }
    
    public class wrapperType {
        public wrapperType(){
            this.userRecordTypeName = '';
            this.equipements = new List<EquipmentWrapper>();
            this.totalEquipements = 0;
        }
        @AuraEnabled
        public String userRecordTypeName;
        @AuraEnabled
        public List<EquipmentWrapper> equipements;
        @AuraEnabled
        public Integer totalEquipements;
    }
    
    public class EquipmentWrapper {
        public EquipmentWrapper(){
            this.type = '-';
            this.batterie = '-';
            this.emplacement = '-';
            this.dateInstallation = '-';
            this.utilisateurPrincipal = '-';
            this.marque = '-';            
        }
        public EquipmentWrapper(String type, String batterie, String emplacement, String dateInstallation, String utilisateurPrincipal, String marque){
            this.type = type;
            this.batterie = batterie;
            this.emplacement = emplacement;
            this.dateInstallation = dateInstallation;
            this.utilisateurPrincipal = utilisateurPrincipal;
            this.marque = marque;            
        }
        @AuraEnabled
        public String type;
        @AuraEnabled
        public String batterie;
        @AuraEnabled
        public String emplacement;
        @AuraEnabled
        public String dateInstallation;
        @AuraEnabled
        public String utilisateurPrincipal;
        @AuraEnabled
        public String marque;
    }
}