#!/usr/bin/perl

package navbarParser;

use strict;
use warnings;
use Switch;

sub new {
    my ($class) = @_;

    my $self = {};
    bless $self, $class;
    return $self;
}

#Parses the cookie with is storing the navigation bar's data 
#and builds an array of hash references for use in the navigation
#bar's html template.
sub parseNavCookie {
    my ($self, $cookieVal) = @_;

    my $bar;
    my $type;
    my @fields = split(';', $cookieVal);
    
    for my $field (@fields) {
	my ($title, $name, $sha) = split(':', $field);
	switch($title){
	    case "Class" {$type = "class";}
	    case "Method" {$type = "meth";}
	    case "Attribute" {$type = "attr";}
	    case "File" {$type = "file";}
	    case "Container" {$type = "container";}
	    case "Project" {$type = "project";}
	}

	my $hashref = {'title' => $title, 'name' => $name, 'sha' => $sha, 'type' => $type};
		
	push @{$bar}, $hashref;
    }

    return $bar;
}

1;
