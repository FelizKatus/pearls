#!/usr/bin/perl -w

#Error handling
use strict;
# use warnings;
use CGI::Carp qw(fatalsToBrowser);

# Form handling
# use CGI qw(:standard);
# OOP form handling
use CGI;

# Dumper
use Data::Dumper;

# Log4perl
use Log::Log4perl qw(:easy);
Log::Log4perl->easy_init({
  file  => '>> ../debug.log',
  level => $DEBUG
});

# Add current working dir to @INC
use File::Basename;
use lib dirname(__FILE__);

# -----------------------------------------------------------------------------

print "Content-Type: text/html\n\n";

my $post_location;
my $posts_path = '/mnt/d/dev/pearls/html/posts/';

chdir($posts_path);
opendir(DIR, $posts_path) or die("Error al abrir directorio: $!");
foreach(readdir(DIR)) {
  $post_location = $posts_path . $_;
  if(-f $post_location) {
    f_print_post($post_location);
  }
}

sub f_print_post($post_location) {
  open(FILE, "<$post_location") or die("Error al abrir fichero: $!");
  flock(FILE, 2) or die("Error al bloquear fichero: $!");
  {
    local $/ = "\n\n";
    my @post = <FILE>;
    chomp @post;

    print '<h1>' . $post[0] . '</h1>';
    print "<img src=\"$post[1]\">";

    for(my $i = 2; $i < @post; $i++) {
      print '<p>' . $post[$i] . '</p>';
    }
  }
  flock(FILE, 8) or die("Error al desbloquear fichero: $!");
  close FILE;
}
