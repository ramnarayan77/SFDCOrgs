public class getleads {

String searchText;
List<Account> lds;

public String getSearchText() {
return searchText;
}

public void setSearchText(String s) {
searchText=s;
}

public List<Account> getResults() {
return lds;
}

public PageReference doSearch() {
lds = (List<Account>)[FIND :searchText RETURNING Account(Name, Id, Phone)][0];
return null;
}

}