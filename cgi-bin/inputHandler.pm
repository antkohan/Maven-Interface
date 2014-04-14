#!/usr/bin/perl

package inputHandler;

use strict;
use warnings;
use Queries;
use DBI;
use Switch;

sub new {
    my ($class) = @_;
    
    my $qh = Queries->new("mavensite", "tony", "");
    my $self = {_qh => $qh};
    bless $self, $class;
    return $self;
}

#Handles inputs that get results using a query function name instead 
#of searching by a column. 
#Format is <query>:<parameter>
#This is only used internally so that I could create links that return
#results from arbitrarily complicated queries. 
sub handleQuery {
    my ($self, $input) = @_;

    my $rows;
    my ($query, $param) = split(':', $input);
    $rows = $self->{_qh}->$query($param);
   
    return $rows;
}

#Parses the search input and builds a where clause to send to the query handler.
#Search input format is any number of <tag>:<value> clauses separated by spaces.
#Tag names are translated to the database's column name via hashes. This is so
#different tables that have different names for a column of a similar type could 
#be referenced by the same tag name. 
#If no tag is supplied, the default column to search is the name.
sub handleSearch {
    my ($self, $type, $input) = @_;

    my ($column, $where, $rows);
    my (@prefixs, @values);
    $self->splitSearchInput(\@prefixs, \@values, $input);
       
    switch($type){
	case "class" {
	    my %colNames = ("default"=>"class_name", "name"=>"class_name",
			    "full_name"=>"full_class_name", "class"=>"class_name",
			    "full_class"=>"full_class_name", "path"=>"class_path",
		            "sha"=>"sha_sig", "sha_file"=>"sha_file");
	    $where = $self->buildWhere(\@prefixs, \@values, \%colNames);
	    $rows = $self->{_qh}->getClassWhere($where);
	}
        case "meth" {
	    my %colNames = ("default"=>"meth_id", "name"=>"meth_id", 
			    "full_name"=>"meth_full_id","class"=>"class_name",
			    "full_class"=>"full_class_name", "type"=>"type",
		            "sha"=>"sha_sig", "sha_file"=>"sha_file");
	    $where = $self->buildWhere(\@prefixs, \@values, \%colNames);
	    $rows = $self->{_qh}->getMethWhere($where);
	}
        case "attr" {
	    my %colNames = ("default"=>"attr_id", "name"=>"attr_id",
			    "class"=>"class_name", "full_class"=>"full_class_name",
			    "sha"=>"sha_sig", "sha_file"=>"sha_file");
	    $where = $self->buildWhere(\@prefixs, \@values, \%colNames);
	    $rows = $self->{_qh}->getAttrWhere($where);
	}
	case "file" {
	    my %colNames = ("default"=>"file_name", "name"=>"file_name",
			    "extension"=>"extension", "path"=>"file_path",
			    "sha_file"=>"sha_file");
	    $where = $self->buildWhere(\@prefixs, \@values, \%colNames);
	    $rows = $self->{_qh}->getFileWhere($where);
	}
        case "container" {
	    my %colNames = ("default"=>"container_name", "name"=>"container_name",
			    "path"=>"container_path", "sha_container"=>"sha_container");
	    $where = $self->buildWhere(\@prefixs, \@values, \%colNames);
	    $rows = $self->{_qh}->getContainerWhere($where);
	}
	case "project" {
	    my %colNames = ("default"=>"artifact", "name"=>"artifact",
		            "organization"=>"org_name", "pom"=>"pom_name",
			    "group"=>"group_id");
	    $where = $self->buildWhere(\@prefixs, \@values, \%colNames);
	    $rows = $self->{_qh}->getProjectWhere($where);
	}
    }
    
    return $rows;
}

sub splitSearchInput {
    my ($self, $prefixs, $values, $input) = @_;

    my ($prefix, $value);
    my @fields = split(' ', $input);

    for my $field (@fields){
	$prefix = "default";
	$value = $field;
	if(index($field, ':') != -1){
  	    ($prefix, $value) = split(':', $field);
	}
	
	push(@$prefixs, $prefix);
	push(@$values, $value);
    }
}

sub buildWhere {
    my ($self, $prefixs, $values, $colNames) = @_;

    my $where;
    my $column;
    my $prefix = $$prefixs[0];
    my $value = $$values[0];

    $column = $$colNames{$prefix};
    $where = "WHERE $column = '$value'";
    for my $i (1..$#$prefixs){
	$column = $$colNames{$$prefixs[$i]};
	$value = $$values[$i];
	$where .= " AND $column = '$value'";
    }

    return $where;
}

1;
