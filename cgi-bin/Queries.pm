#!/usr/bin/perl

package Queries;

use strict;
use warnings;
use DBI;

sub new {
    my ($class, $dbname, $user, $pass) = @_;

    my $dbh = DBI->connect("dbi:Pg:dbname=$dbname", "$user", "$pass");
    my $self = {_dbh => $dbh};
    bless $self, $class;
    return $self;
}

sub getClassWhere {
    my($self, $where) = @_;
    
    my $sql =
   "SELECT * FROM
    (SELECT * FROM sigsClass $where) AS tmp
    LEFT OUTER JOIN files ON (tmp.sha_file = files.sha_file)"; 

    return $self->execute($sql);
}

sub getMethWhere {
    my($self, $where) = @_;

    my $sql =
   "SELECT * FROM 
    (SELECT * FROM sigsMeth $where) AS tmp
    LEFT OUTER JOIN files ON (tmp.sha_file = files.sha_file)";

    return $self->execute($sql);
}

sub getAttrWhere {
    my($self, $where) = @_;
   
    my $sql = 
   "SELECT * FROM 
    (SELECT * FROM sigsAttr $where) AS tmp
    LEFT OUTER JOIN files ON (tmp.sha_file = files.sha_file)";

    return $self->execute($sql);
}

sub getFileWhere {   
    my($self, $where) = @_;
    
    my $sql =
   "SELECT * FROM files $where";
        
    return $self->execute($sql);
}

sub getContainerWhere {
    my($self, $where) = @_;
    
    my $sql =
   "SELECT * FROM containers $where";
    
    return $self->execute($sql);
}

sub getProjectWhere {
    my($self, $where) = @_;
    
    my $sql =
   "SELECT * FROM pomdata $where";
    
    return $self->execute($sql);
}

sub getFileForClass {
    my ($self, $sig_sha) = @_;
    
    my $sql =
   "SELECT * FROM 
    (SELECT * FROM sigsClass WHERE sha_sig = '$sig_sha') AS tmp
    NATURAL JOIN files";

    return $self->execute($sql);
}

sub getFileForMeth {
    my ($self, $sig_sha) = @_;

    my $sql =
   "SELECT * FROM 
    (SELECT * FROM sigsMeth WHERE sha_sig = '$sig_sha') AS tmp
    NATURAL JOIN files";

    return $self->execute($sql);
}

sub getFileForAttr {
    my ($self, $sig_sha) = @_;

    my $sql =
   "SELECT * FROM
    (SELECT * FROM sigsAttr WHERE sha_sig = '$sig_sha') AS tmp
    NATURAL JOIN files";

    return $self->execute($sql);

}

sub getFile {
    my ($self, $sha_file_sig) = @_;

    my $sql =
   "SELECT * FROM files WHERE sha_file_sig = '$sha_file_sig'";

    return $self->execute($sql);
}

sub getContainer {
    my ($self, $sha_container) = @_;

    my $sql =
   "SELECT * FROM containers WHERE sha_container = '$sha_container'";

    return $self->execute($sql);
}

sub getProject {
    my ($self, $sha_pom) = @_;

    my $sql =
   "SELECT * FROM pomdata WHERE sha_pom = '$sha_pom'";

    return $self->execute($sql);
}

sub getContainersForFile {
    my ($self, $sha_file) = @_;

    my $sql =
   "SELECT * FROM
    (SELECT * FROM filetocontainer WHERE sha_file = '$sha_file') AS tmp
    NATURAL JOIN containers";
    
    return $self->execute($sql);
}

sub getContainersForProject {
    my ($self, $sha_pom) = @_;

    my $sql =
   "SELECT * FROM
    (SELECT * FROM pomdata WHERE sha_pom = '$sha_pom') AS tmp
    NATURAL JOIN pomtojar
    INNER JOIN containers ON (pomtojar.related_jar = containers.container_name)";
    
    return $self->execute($sql);
}

sub getFilesForProject {
    my ($self, $sha_pom) = @_;

    my $sql =
   "SELECT * FROM
    (SELECT * FROM pomdata WHERE sha_pom = '$sha_pom') AS tmp
    NATURAL JOIN pomtojar
    INNER JOIN containers ON (pomtojar.related_jar = containers.container_name)
    NATURAL JOIN filetocontainer
    NATURAL JOIN files";
    
    return $self->execute($sql);
}

sub getClassesForContainer {
    my ($self, $sha_container) = @_;

    my $sql =
   "SELECT * FROM
    (SELECT * FROM containers WHERE sha_container = '$sha_container') AS tmp
    NATURAL JOIN filetocontainer
    NATURAL JOIN files
    NATURAL JOIN sigsclass";
    
    return $self->execute($sql);
}

sub getMethodsForContainer {
    my ($self, $sha_container) = @_;

    my $sql =
   "SELECT * FROM
    (SELECT * FROM containers WHERE sha_container = '$sha_container') AS tmp
    NATURAL JOIN filetocontainer
    NATURAL JOIN files
    NATURAL JOIN sigsmeth";
    
    return $self->execute($sql);
}

sub getAttributesForContainer {
    my ($self, $sha_container) = @_;

    my $sql =
   "SELECT * FROM
    (SELECT * FROM containers WHERE sha_container = '$sha_container') AS tmp
    NATURAL JOIN filetocontainer
    NATURAL JOIN files
    NATURAL JOIN sigsattr";
    
    return $self->execute($sql);
}

sub getFilesForContainer {
    my ($self, $sha_container) = @_;

    my $sql =
   "SELECT * FROM
    (SELECT * FROM containers WHERE sha_container = '$sha_container') AS tmp
    NATURAL JOIN filetocontainer
    NATURAL JOIN files";
    
    return $self->execute($sql);
}

sub getProjectsForMeth {
    my ($self, $sha_sig) = @_;

    my $sql =
   "SELECT * FROM 
    (SELECT * FROM sigsmeth WHERE sha_sig = '$sha_sig') as tmp
    NATURAL JOIN filetocontainer
    NATURAL JOIN containers
    INNER JOIN pomtojar ON (containers.container_name = pomtojar.related_jar)
    NATURAL JOIN pomdata;";
      
    return $self->execute($sql);
}

sub getProjectsForClass {
    my ($self, $sha_sig) = @_;

    my $sql =
   "SELECT * FROM 
    (SELECT * FROM sigsclass WHERE sha_sig = '$sha_sig') as tmp
    NATURAL JOIN filetocontainer
    NATURAL JOIN containers
    INNER JOIN pomtojar ON (containers.container_name = pomtojar.related_jar)
    NATURAL JOIN pomdata;";
      
    return $self->execute($sql);
}

sub getProjectsForAttr {
    my ($self, $sha_sig) = @_;

    my $sql =
   "SELECT * FROM 
    (SELECT * FROM sigsattr WHERE sha_sig = '$sha_sig') as tmp
    NATURAL JOIN filetocontainer
    NATURAL JOIN containers
    INNER JOIN pomtojar ON (containers.container_name = pomtojar.related_jar)
    NATURAL JOIN pomdata;";
      
    return $self->execute($sql);
}

sub getProjectsForFile {
    my ($self, $sha_file) = @_;

    my $sql =
   "SELECT * FROM 
    (SELECT * FROM files WHERE sha_file = '$sha_file') as tmp
    NATURAL JOIN filetocontainer
    NATURAL JOIN containers
    INNER JOIN pomtojar ON (containers.container_name = pomtojar.related_jar)
    NATURAL JOIN pomdata;";
      
    return $self->execute($sql);
}

sub getProjectsForContainer {
    my ($self, $sha_container) = @_;

    my $sql =
   "SELECT * FROM 
    (SELECT * FROM containers WHERE sha_container = '$sha_container') as tmp
    INNER JOIN pomtojar ON (tmp.container_name = pomtojar.related_jar)
    NATURAL JOIN pomdata;";
      
    return $self->execute($sql);
}

sub execute {
    my($self, $sql) = @_;
    my $rows;
    
    my $query = $self->{_dbh}->prepare($sql);
    $query->execute;
    push @{$rows}, $_ while $_ = $query->fetchrow_hashref();
    return $rows;
}

sub disconnect {
    my($self) = @_;
    $self->{_dbh}->disconnect;
}

1;
