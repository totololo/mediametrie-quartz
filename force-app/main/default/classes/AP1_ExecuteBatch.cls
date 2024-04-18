public with sharing class AP1_ExecuteBatch {
    @AuraEnabled
    public static void runBatchPrecodage() {
        Database.executeBatch(new Batch002_PrecodageControle());
    } 
    @AuraEnabled
    public static void runBatchCreationRequete() {
        Database.executeBatch(new Batch003_CreationRequeteControle());
  } 
    @AuraEnabled
    public static void runBatchRecuperationRdv() {
        Database.executeBatch(new Batch008_SMSviaNP6());
  } 
    @AuraEnabled
    public static void runBatchShareNote() {
        Database.executeBatch(new Batch0017_ShareNote());
  } 
    @AuraEnabled
    public static void runBatchCtrAband() {
        Database.executeBatch(new Batch001_ControleAbandone());
  } 
    @AuraEnabled
    public static void runBatchRemiseSolde() {
        Database.executeBatch(new Batch009_Debit_RemiseSoldeAZero());
  } 
    
    @AuraEnabled
    public static void runBatchCreditExcep() {
        Database.executeBatch(new Batch016_CreditAutomatique());
  } 
    
    @AuraEnabled
    public static void runBatchDelEven() {
        Database.executeBatch(new Batch0013_Delete_Evenement());
  } 
    @AuraEnabled
    public static void runBatch021() {
        Database.executeBatch(new Batch021_RequeteSuiviSetMeter());
  } 
    @AuraEnabled
    public static void runBatchCloseCase009() {
        Database.executeBatch(new Batch009_ClotureRequeteAutomatique());
  } 
     @AuraEnabled
    public static void runBatch017() {
        Database.executeBatch(new Batch017_InstallControlesSoftMeters());
  } 
    @AuraEnabled
    public static void runBatch014() {
        Database.executeBatch(new Batch014_CreateCaseForBattery());
  } 
    @AuraEnabled
    public static void runBatch022RM() {
        Database.executeBatch(new Batch022_CreationRequete_RetourMateriel());
  } 
    @AuraEnabled
    public static void runBatch025inactif() {
        Database.executeBatch(new Batch025_ClotureAuto_CaseInactifMeter());
  } 
    @AuraEnabled
    public static void runBatch025majetiq() {
        Database.executeBatch(new Batch025_MAJ_Etiquette());
  } 
    @AuraEnabled
    public static void runBatch026() {
        Database.executeBatch(new Batch026_ClotureCaseSansControle());
  } 
     @AuraEnabled
    public static void runBatch010() {
        Database.executeBatch(new Batch010_RequeteProcessusRestitution45j());
  } 
    @AuraEnabled
    public static void runBatch018() {
        Database.executeBatch(new Batch0018_MajCtrl_Precode_RS());
  } 
    
   /* @AuraEnabled
    public static void runBatchCreateAppel() {
        Database.executeBatch(new Batch022_CreateAvayaCalls());
  } */
}