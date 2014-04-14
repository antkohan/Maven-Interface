#!/usr/bin/perl

use strict;
use warnings;
use Queries;
use navbarParser;
use CGI;
use CGI::Cookie;
use HTML::Template;
use Switch;

my $rows;
my $navRows;
my $tmpl;
my $cgi = CGI->new;
my $np = navbarParser->new;
my $qh = Queries->new("mavensite", "tony", "");

my $type = $cgi->param("type");
my $sha = $cgi->param("sha");

my %cookies = CGI::Cookie->fetch;
my $cookie = $cookies{'navbar'};
if($cookie){
    my $val = $cookie->value;
    $navRows = $np->parseNavCookie($val);
}

if($type eq "class"){
    $tmpl = HTML::Template->new(
	filename => "../templates/classData.tmpl",
	die_on_bad_params => 0);

    $rows = $qh->getFileForClass($sha);
    if($rows){$tmpl->param(CLASS_DATA => $rows);}
    if($navRows){$tmpl->param(NAV_BAR => $navRows);}

} elsif($type eq "meth") {
    $tmpl = HTML::Template->new(
	filename => "../templates/methData.tmpl",
	die_on_bad_params => 0);

    $rows = $qh->getFileForMeth($sha);
    if($rows){$tmpl->param(METH_DATA => $rows);}
    if($navRows){$tmpl->param(NAV_BAR => $navRows);}

} elsif($type eq "attr") {
    $tmpl = HTML::Template->new(
	filename => "../templates/attrData.tmpl",
	die_on_bad_params => 0);

    $rows = $qh->getFileForAttr($sha);
    if($rows){$tmpl->param(ATTR_DATA => $rows);}
    if($navRows){$tmpl->param(NAV_BAR => $navRows);}

} elsif($type eq "file") {
    $tmpl = HTML::Template->new(
	filename => "../templates/fileData.tmpl",
	die_on_bad_params => 0);

    $rows = $qh->getFile($sha);
    if($rows) {$tmpl->param(FILE_DATA => $rows);}
    if($navRows){$tmpl->param(NAV_BAR => $navRows);}

} elsif($type eq "container") {
    $tmpl = HTML::Template->new(
	filename => "../templates/containerData.tmpl",
	die_on_bad_params => 0);

    $rows = $qh->getContainer($sha);
    if($rows){$tmpl->param(CONTAINER_DATA => $rows);}
    if($navRows){$tmpl->param(NAV_BAR => $navRows);}

} elsif($type eq "project") {
    $tmpl = HTML::Template->new(
	filename => "../templates/projectData.tmpl",
	die_on_bad_params => 0);

    $rows = $qh->getProject($sha);
    if($rows){$tmpl->param(PROJECT_DATA => $rows);}
    if($navRows){$tmpl->param(NAV_BAR => $navRows);}
}

print $cgi->header;
print $cgi->start_html(
    -title =>'Object Data',
    -style =>{-src=>['/css/site.css', '/css/objectData.css','/css/topbar.css','/css/navbar.css']},
    -script=>[{type=>'text/javascript', src=>'/js-bin/jquery-1.11.0.min.js' },
	      {type=>'text/javascript', src=>'/js-bin/jquery.cookie.js'},
              {type=>'text/javascript', src=>'/js-bin/navBar.js'}]
);

print $tmpl->output;
print $cgi->end_html;

$qh->disconnect;
