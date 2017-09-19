public class changelistupper 
{
public List<String> mycontvalue = new List<String> ();
public Integer i;

public void setmycontvalue(List<String> s)
{
for (i=0;i<s.size();i++) 
{
mycontvalue.add (s[i].toUpperCase());
}
}

public List<String> getmycontvalue()
{
return mycontvalue;
}

}