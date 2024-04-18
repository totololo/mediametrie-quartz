/**
 * @description       : 
 * @author            : Anes BOUZOUINA
 * @group             : 
 * @last modified on  : 09-26-2022
 * @last modified by  : Anes BOUZOUINA
**/

public class JSON2Apex {

	public List<Columns> columns;
	public String developerName;
	public Boolean done;
	public String id;
	public String label;
	public List<Records> records;
	public Integer size;

	public class Columns {
		public String ascendingLabel;
		public String descendingLabel;
		public String fieldNameOrPath;
		public Boolean hidden;
		public String label;
		public Boolean searchable;
		public String selectListItem;
		public String sortDirection;
		public Integer sortIndex;
		public Boolean sortable;
		public String type;
	}

	public class Records {
		public List<Columns_Z> columns;
	}

	public class Columns_Z {
		public String fieldNameOrPath;
		public String value;
	}
	
   

    public String token;
  public static Json2Apex parse(String json) {
        return (Json2Apex) System.JSON.deserialize(json, Json2Apex.class);
    }
	
	
}