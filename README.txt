Operation of Site:

-User enters a name into a search bar and chooses any combination of objects that they wish to search for.
-They are then taken to a page that displays a tabbed section where each tab is for the type of object they searched for (if there are results). 
 Inside each tab is a table displaying the the objects that matched the search name. 
 The table can be sorted by any of its columns, and you can change the number of results in each page of the table.
 The user can then click on any object in the tables, which will take them to the next page. 
 Everytime the  user does this an entry in the navigation bar to the left will be created.
-At this point the user will be looking at all the data for a single  object.
 The user can then click on one of the queries which will take the user back to the listing page to show all the objects that are a result of that query. 
-Entries in the navigation bar can be clicked to return to a previously viewed single object.  
-The user can also search for a new object via the search bar at the top of each page. 

File Description:

/cgi-bin
 -Perl scripts that generate the pages.

	Queries.pm
	 -Stores all the queries in functions that execute its query and then return the results in an array of hash references. 
	displayObjects.cgi
	 -Generates the main listing page
	inputHandler.pm
	 -Is used to handle input from the search bar and from internal links. 
          It handles both query and search type inputs, each of which is handled differently.
          Query type inputs are requests to specific query functions in Queries.pm, these are only used internally.
          Search type is what is used by the serach bars (as well as some internal links). 
          See the comments in the file about search type inputs for an explanation of how it they are handled.
	navbarParser.pm
	 -parses the cookie that stores the navigation information and creates an array of hash references for use in the navigation bar template.  
	showAllData.cgi
	 -Generates the page that displays all the data for a single given object and also displays the queries you can use for that object. 

/tempates
  -All the files in here are fairly self explanitory. They are the html templates that are loaded by the perl scripts to actually display the data. 

  objectList.tmpl
   -The only template the might actually require some explanation.  
    This template controls the other list templates.
    It will only load the other templates if there are results for that object type.
    If there are no results at all, then the div used by the javascript that creates the tabs, is changed such that it displays a message indicating no results. 


/www
 -houses the homepage called index.html and two directory for javascript and css.

