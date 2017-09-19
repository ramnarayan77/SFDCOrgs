public class userfields {

public List<String> Uservalues = new List<String>();
public Map<String,Schema.Sobjectfield> UserMapvalues;

public userfields() 
{

Uservalues.add(UserInfo.getName());
Uservalues.add(UserInfo.getLanguage());
UserMapvalues = Schema.SObjecttype.User.fields.getMap();
}

public List<String> getUservalues ()
{
return (List<String>) Uservalues;
}

public Map<String,Sobjectfield> getUserMapvalues ()
{
return UserMapvalues;
}


}