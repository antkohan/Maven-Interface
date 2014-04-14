#!/usr/bin/perl

use strict;
use warnings;
use inputHandler;
use navbarParser;
use CGI;
use CGI::Cookie;
use HTML::Template;

my $rows;
my $navRows;
my $cgi = CGI->new;
my $np = navbarParser->new;
my $ih = inputHandler->new;
my $tmpl = HTML::Template->new(
    filename => "../templates/objectList.tmpl",
    die_on_bad_params => 0);

my $input = $cgi->param("input");
my $submit = $cgi->param("submit");
my $type = $cgi->param("type");

my %cookies = CGI::Cookie->fetch;
my $cookie = $cookies{'navbar'};
if($cookie){
    my $val = $cookie->value;
    $navRows = $np->parseNavCookie($val);
    if($navRows){$tmpl->param(NAV_BAR => $navRows);}
}

my @paramNames = $cgi->param;
for my $i (3 .. $#paramNames){

    #each paramValue should be the name of the type of object to search for
    my $paramValue = $cgi->param($paramNames[$i]);

    if($type eq "query"){
	$rows = $ih->handleQuery( $input);
	if($rows){$tmpl->param($paramValue . _LINKS => $rows);}
    } else {
	$rows = $ih->handleSearch($paramValue, $input);
	if($rows){$tmpl->param($paramValue . _LINKS => $rows);}
    }
}

print $cgi->header;
print $cgi->start_html(
    -title =>'Object List',
    -style =>{-src=>['/css/site.css', '/css/list.css','/css/topbar.css',
		     '/css/jquery-ui-1.10.4.custom.css','/css/navbar.css']},
    -script=>[{type=>'text/javascript', src=>'/js-bin/jquery-1.11.0.min.js' },
              {type=>'text/javascript', src=>'/js-bin/jquery.tablesorter.min.js'},
              {type=>'text/javascript', src=>'/js-bin/jquery.cookie.js'},
              {type=>'text/javascript', src=>'/js-bin/navBar.js'},
              {type=>'text/javascript', src=>'/js-bin/list.js'},
	      {type=>'text/javascript', src=>'/js-bin/jquery-ui-1.10.4.custom.min.js'},
              {type=>'text/javascript', src=>'/js-bin/jquery.tablesorter.pager.js'}]
);


print $tmpl->output;
print $cgi->end_html;

