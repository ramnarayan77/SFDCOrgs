public with sharing class MapAccCont {

private Map<String,SObjectType> VfMapSobj{get;set;}

private Integer i=2;

public MapAccCont ()
{
loadCustomObject();
}

public Map<String,SObjectType> getretCustomObjects()

{
return VfMapSobj;
}

public Integer getIncrcount()

{
i=i+1;
return i;
}


public void loadCustomObject()

{
VfMapSobj = Schema.getGlobalDescribe();
}

}