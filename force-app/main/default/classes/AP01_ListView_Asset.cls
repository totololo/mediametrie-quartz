/*
* @author: Ayoub GHAMMAZ
* @date: 26/11/2021
* @ Description: 
* @TestClass: AP01_ListView_Asset_Test
* @Coverage: 86%
* * History
* <Date of modification>   		<Author>    		<Description of modification>
*/

public with sharing  class AP01_ListView_Asset {
    private ApexPages.StandardController controller;
    public List<Asset> getIDs;
    public List<Asset> assIds{get;set;} 
    public String val{get;set;} 
    public asset ass {get;set;}
    public List<SelectOption> options {get;set;}
    public Boolean  selected {get;set;}
    
    public AP01_ListView_Asset(ApexPages.StandardSetController controller){
        
        System.debug('Get Selected');
        getIDs = controller.getSelected();
        assIds =new List<Asset>();  
        for(Asset ass : getIDs){
            assIds.add(ass); 
            System.debug('Asset ID : '+assIds);
        }
        options = new List<SelectOption>();
        List<Schema.Picklistentry> fieldResult = Asset.Status.getDescribe().getPicklistValues();
        for(Schema.PicklistEntry f : fieldResult) {
            options.add(new SelectOption(f.getValue(), f.getLabel()));
        }
        if(assIds !=null && assIds.size()>0){
            selected=true;
        }else{
             ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Veuillez selectionner un enregistrement'));
            selected=false;
        }
        //accIds = accIds.removeEnd(','); 
    } 
    
    
    public void lic(){
        System.debug('-----------2'+val);
    }
    public PageReference show(){
        List<Asset> equiToUpdate = new List<Asset>();
        for(asset equ :assIds){
            equ.status=val;
            equiToUpdate.add(equ);
        }
        System.debug('----1'+assIds);
        System.debug('----1'+equiToUpdate);
        if(equiToUpdate!=null && equiToUpdate.size()>0){
            try{ 
                database.update(equiToUpdate);
            }Catch(exception ex){
                system.debug('update asset Exception Error:'+ex.getmessage());
            }
        }
        Schema.DescribeSObjectResult result = Asset.SObjectType.getDescribe(); 
        PageReference pageRef = new PageReference('/' + result.getKeyPrefix()); 
        pageRef.setRedirect(true);  
        return pageRef;
        
    }
    public PageReference back(){
        Schema.DescribeSObjectResult result = Asset.SObjectType.getDescribe(); 
        PageReference pageRef = new PageReference('/' + result.getKeyPrefix()); 
        pageRef.setRedirect(true);  
        return pageRef;
    }
    
}