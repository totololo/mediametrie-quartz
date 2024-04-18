/**
 * @description       : 
 * @author            : Anes BOUZOUINA
 * @group             : 
 * @last modified on  : 09-26-2022
 * @last modified by  : Anes BOUZOUINA
**/

@IsTest
public class JSON2Apex_Test {
	
	static testMethod void testParse() {
		String json = '{'+
		'  \"columns\" : [ {'+
		'    \"ascendingLabel\" : \"Z-A\",'+
		'    \"descendingLabel\" : \"A-Z\",'+
		'    \"fieldNameOrPath\" : \"CaseNumber\",'+
		'    \"hidden\" : false,'+
		'    \"label\" : \"Case Number\",'+
		'    \"searchable\" : true,'+
		'    \"selectListItem\" : \"CaseNumber\",'+
		'    \"sortDirection\" : \"ascending\",'+
		'    \"sortIndex\" : 0,'+
		'    \"sortable\" : true,'+
		'    \"type\" : \"string\"'+
		'  }, {'+
		'    \"ascendingLabel\" : \"Z-A\",'+
		'    \"descendingLabel\" : \"A-Z\",'+
		'    \"fieldNameOrPath\" : \"Contact.Name\",'+
		'    \"hidden\" : false,'+
		'    \"label\" : \"Contact Name\",'+
		'    \"searchable\" : false,'+
		'    \"selectListItem\" : \"Contact.Name\",'+
		'    \"sortDirection\" : null,'+
		'    \"sortIndex\" : null,'+
		'    \"sortable\" : true,'+
		'    \"type\" : \"string\"'+
		'  }, {'+
		'    \"ascendingLabel\" : \"Z-A\",'+
		'    \"descendingLabel\" : \"A-Z\",'+
		'    \"fieldNameOrPath\" : \"Subject\",'+
		'    \"hidden\" : false,'+
		'    \"label\" : \"Subject\",'+
		'    \"searchable\" : true,'+
		'    \"selectListItem\" : \"Subject\",'+
		'    \"sortDirection\" : null,'+
		'    \"sortIndex\" : null,'+
		'    \"sortable\" : true,'+
		'    \"type\" : \"string\"'+
		'  }, {'+
		'    \"ascendingLabel\" : \"Low to High\",'+
		'    \"descendingLabel\" : \"High to Low\",'+
		'    \"fieldNameOrPath\" : \"Status\",'+
		'    \"hidden\" : false,'+
		'    \"label\" : \"Status\",'+
		'    \"searchable\" : true,'+
		'    \"selectListItem\" : \"toLabel(Status)\",'+
		'    \"sortDirection\" : null,'+
		'    \"sortIndex\" : null,'+
		'    \"sortable\" : true,'+
		'    \"type\" : \"picklist\"'+
		'  }, {'+
		'    \"ascendingLabel\" : \"Low to High\",'+
		'    \"descendingLabel\" : \"High to Low\",'+
		'    \"fieldNameOrPath\" : \"Priority\",'+
		'    \"hidden\" : false,'+
		'    \"label\" : \"Priority\",'+
		'    \"searchable\" : true,'+
		'    \"selectListItem\" : \"toLabel(Priority)\",'+
		'    \"sortDirection\" : null,'+
		'    \"sortIndex\" : null,'+
		'    \"sortable\" : true,'+
		'    \"type\" : \"picklist\"'+
		'  }, {'+
		'    \"ascendingLabel\" : \"New to Old\",'+
		'    \"descendingLabel\" : \"Old to New\",'+
		'    \"fieldNameOrPath\" : \"CreatedDate\",'+
		'    \"hidden\" : false,'+
		'    \"label\" : \"Date/Time Opened\",'+
		'    \"searchable\" : false,'+
		'    \"selectListItem\" : \"CreatedDate\",'+
		'    \"sortDirection\" : null,'+
		'    \"sortIndex\" : null,'+
		'    \"sortable\" : true,'+
		'    \"type\" : \"datetime\"'+
		'  }, {'+
		'    \"ascendingLabel\" : \"Z-A\",'+
		'    \"descendingLabel\" : \"A-Z\",'+
		'    \"fieldNameOrPath\" : \"Owner.NameOrAlias\",'+
		'    \"hidden\" : false,'+
		'    \"label\" : \"Case Owner Alias\",'+
		'    \"searchable\" : false,'+
		'    \"selectListItem\" : \"Owner.NameOrAlias\",'+
		'    \"sortDirection\" : null,'+
		'    \"sortIndex\" : null,'+
		'    \"sortable\" : true,'+
		'    \"type\" : \"string\"'+
		'  }, {'+
		'    \"ascendingLabel\" : null,'+
		'    \"descendingLabel\" : null,'+
		'    \"fieldNameOrPath\" : \"Id\",'+
		'    \"hidden\" : true,'+
		'    \"label\" : \"Case ID\",'+
		'    \"searchable\" : false,'+
		'    \"selectListItem\" : \"Id\",'+
		'    \"sortDirection\" : null,'+
		'    \"sortIndex\" : null,'+
		'    \"sortable\" : false,'+
		'    \"type\" : \"id\"'+
		'  }, {'+
		'    \"ascendingLabel\" : null,'+
		'    \"descendingLabel\" : null,'+
		'    \"fieldNameOrPath\" : \"RecordTypeId\",'+
		'    \"hidden\" : true,'+
		'    \"label\" : \"Record Type ID\",'+
		'    \"searchable\" : false,'+
		'    \"selectListItem\" : \"RecordTypeId\",'+
		'    \"sortDirection\" : null,'+
		'    \"sortIndex\" : null,'+
		'    \"sortable\" : false,'+
		'    \"type\" : \"reference\"'+
		'  }, {'+
		'    \"ascendingLabel\" : null,'+
		'    \"descendingLabel\" : null,'+
		'    \"fieldNameOrPath\" : \"LastModifiedDate\",'+
		'    \"hidden\" : true,'+
		'    \"label\" : \"Last Modified Date\",'+
		'    \"searchable\" : false,'+
		'    \"selectListItem\" : \"LastModifiedDate\",'+
		'    \"sortDirection\" : null,'+
		'    \"sortIndex\" : null,'+
		'    \"sortable\" : false,'+
		'    \"type\" : \"datetime\"'+
		'  }, {'+
		'    \"ascendingLabel\" : null,'+
		'    \"descendingLabel\" : null,'+
		'    \"fieldNameOrPath\" : \"SystemModstamp\",'+
		'    \"hidden\" : true,'+
		'    \"label\" : \"System Modstamp\",'+
		'    \"searchable\" : false,'+
		'    \"selectListItem\" : \"SystemModstamp\",'+
		'    \"sortDirection\" : null,'+
		'    \"sortIndex\" : null,'+
		'    \"sortable\" : false,'+
		'    \"type\" : \"datetime\"'+
		'  }, {'+
		'    \"ascendingLabel\" : null,'+
		'    \"descendingLabel\" : null,'+
		'    \"fieldNameOrPath\" : \"Contact.Id\",'+
		'    \"hidden\" : true,'+
		'    \"label\" : \"Contact ID\",'+
		'    \"searchable\" : false,'+
		'    \"selectListItem\" : \"Contact.Id\",'+
		'    \"sortDirection\" : null,'+
		'    \"sortIndex\" : null,'+
		'    \"sortable\" : false,'+
		'    \"type\" : \"id\"'+
		'  }, {'+
		'    \"ascendingLabel\" : null,'+
		'    \"descendingLabel\" : null,'+
		'    \"fieldNameOrPath\" : \"ContactId\",'+
		'    \"hidden\" : true,'+
		'    \"label\" : \"Contact ID\",'+
		'    \"searchable\" : false,'+
		'    \"selectListItem\" : \"ContactId\",'+
		'    \"sortDirection\" : null,'+
		'    \"sortIndex\" : null,'+
		'    \"sortable\" : false,'+
		'    \"type\" : \"reference\"'+
		'  }, {'+
		'    \"ascendingLabel\" : null,'+
		'    \"descendingLabel\" : null,'+
		'    \"fieldNameOrPath\" : \"Contact.RecordTypeId\",'+
		'    \"hidden\" : true,'+
		'    \"label\" : \"Record Type ID\",'+
		'    \"searchable\" : false,'+
		'    \"selectListItem\" : \"Contact.RecordTypeId\",'+
		'    \"sortDirection\" : null,'+
		'    \"sortIndex\" : null,'+
		'    \"sortable\" : false,'+
		'    \"type\" : \"reference\"'+
		'  }, {'+
		'    \"ascendingLabel\" : null,'+
		'    \"descendingLabel\" : null,'+
		'    \"fieldNameOrPath\" : \"Owner.Id\",'+
		'    \"hidden\" : true,'+
		'    \"label\" : \"Owner ID\",'+
		'    \"searchable\" : false,'+
		'    \"selectListItem\" : \"Owner.Id\",'+
		'    \"sortDirection\" : null,'+
		'    \"sortIndex\" : null,'+
		'    \"sortable\" : false,'+
		'    \"type\" : \"id\"'+
		'  }, {'+
		'    \"ascendingLabel\" : null,'+
		'    \"descendingLabel\" : null,'+
		'    \"fieldNameOrPath\" : \"OwnerId\",'+
		'    \"hidden\" : true,'+
		'    \"label\" : \"Owner ID\",'+
		'    \"searchable\" : false,'+
		'    \"selectListItem\" : \"OwnerId\",'+
		'    \"sortDirection\" : null,'+
		'    \"sortIndex\" : null,'+
		'    \"sortable\" : false,'+
		'    \"type\" : \"reference\"'+
		'  } ],'+
		'  \"developerName\" : \"RecentlyViewedCases\",'+
		'  \"done\" : true,'+
		'  \"id\" : \"00B3X00000D2rHW\",'+
		'  \"label\" : \"Recently Viewed Cases\",'+
		'  \"records\" : [ {'+
		'    \"columns\" : [ {'+
		'      \"fieldNameOrPath\" : \"CaseNumber\",'+
		'      \"value\" : \"01352235\"'+
		'    }, {'+
		'      \"fieldNameOrPath\" : \"Contact.Name\",'+
		'      \"value\" : null'+
		'    }, {'+
		'      \"fieldNameOrPath\" : \"Subject\",'+
		'      \"value\" : null'+
		'    }, {'+
		'      \"fieldNameOrPath\" : \"Status\",'+
		'      \"value\" : \"Nouveau\"'+
		'    }, {'+
		'      \"fieldNameOrPath\" : \"Priority\",'+
		'      \"value\" : \"Moyen\"'+
		'    }, {'+
		'      \"fieldNameOrPath\" : \"CreatedDate\",'+
		'      \"value\" : \"Mon Sep 05 11:14:50 GMT 2022\"'+
		'    }, {'+
		'      \"fieldNameOrPath\" : \"Owner.NameOrAlias\",'+
		'      \"value\" : \"abouz\"'+
		'    }, {'+
		'      \"fieldNameOrPath\" : \"Id\",'+
		'      \"value\" : \"5007E00000CyLBlQAN\"'+
		'    }, {'+
		'      \"fieldNameOrPath\" : \"RecordTypeId\",'+
		'      \"value\" : \"0123X000001GJ50QAG\"'+
		'    }, {'+
		'      \"fieldNameOrPath\" : \"LastModifiedDate\",'+
		'      \"value\" : \"Mon Sep 05 11:30:47 GMT 2022\"'+
		'    }, {'+
		'      \"fieldNameOrPath\" : \"SystemModstamp\",'+
		'      \"value\" : \"Mon Sep 05 11:30:47 GMT 2022\"'+
		'    }, {'+
		'      \"fieldNameOrPath\" : \"Contact.Id\",'+
		'      \"value\" : null'+
		'    }, {'+
		'      \"fieldNameOrPath\" : \"ContactId\",'+
		'      \"value\" : null'+
		'    }, {'+
		'      \"fieldNameOrPath\" : \"Contact.RecordTypeId\",'+
		'      \"value\" : null'+
		'    }, {'+
		'      \"fieldNameOrPath\" : \"Owner.Id\",'+
		'      \"value\" : \"0057E00000DdfTHQAZ\"'+
		'    }, {'+
		'      \"fieldNameOrPath\" : \"OwnerId\",'+
		'      \"value\" : \"0057E00000DdfTHQAZ\"'+
		'    } ]'+
		'  }, {'+
		'    \"columns\" : [ {'+
		'      \"fieldNameOrPath\" : \"CaseNumber\",'+
		'      \"value\" : \"01352236\"'+
		'    }, {'+
		'      \"fieldNameOrPath\" : \"Contact.Name\",'+
		'      \"value\" : null'+
		'    }, {'+
		'      \"fieldNameOrPath\" : \"Subject\",'+
		'      \"value\" : null'+
		'    }, {'+
		'      \"fieldNameOrPath\" : \"Status\",'+
		'      \"value\" : \"Nouveau\"'+
		'    }, {'+
		'      \"fieldNameOrPath\" : \"Priority\",'+
		'      \"value\" : \"Moyen\"'+
		'    }, {'+
		'      \"fieldNameOrPath\" : \"CreatedDate\",'+
		'      \"value\" : \"Mon Sep 05 11:30:29 GMT 2022\"'+
		'    }, {'+
		'      \"fieldNameOrPath\" : \"Owner.NameOrAlias\",'+
		'      \"value\" : \"Pôle Agenda\"'+
		'    }, {'+
		'      \"fieldNameOrPath\" : \"Id\",'+
		'      \"value\" : \"5007E00000CyLJVQA3\"'+
		'    }, {'+
		'      \"fieldNameOrPath\" : \"RecordTypeId\",'+
		'      \"value\" : \"0123X000001GJ50QAG\"'+
		'    }, {'+
		'      \"fieldNameOrPath\" : \"LastModifiedDate\",'+
		'      \"value\" : \"Mon Sep 05 11:30:41 GMT 2022\"'+
		'    }, {'+
		'      \"fieldNameOrPath\" : \"SystemModstamp\",'+
		'      \"value\" : \"Mon Sep 05 11:30:41 GMT 2022\"'+
		'    }, {'+
		'      \"fieldNameOrPath\" : \"Contact.Id\",'+
		'      \"value\" : null'+
		'    }, {'+
		'      \"fieldNameOrPath\" : \"ContactId\",'+
		'      \"value\" : null'+
		'    }, {'+
		'      \"fieldNameOrPath\" : \"Contact.RecordTypeId\",'+
		'      \"value\" : null'+
		'    }, {'+
		'      \"fieldNameOrPath\" : \"Owner.Id\",'+
		'      \"value\" : \"00G3X000006AviiUAC\"'+
		'    }, {'+
		'      \"fieldNameOrPath\" : \"OwnerId\",'+
		'      \"value\" : \"00G3X000006AviiUAC\"'+
		'    } ]'+
		'  } ],'+
		'  \"size\" : 2'+
		'}'+
		''+
		''+
		'Requested in 0.502 sec'+
		'Workbench 55.0.0';
		JSON2Apex obj = JSON2Apex.parse(json);
		System.assert(obj != null);
	}
}