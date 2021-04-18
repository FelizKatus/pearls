#!/usr/bin/perl -w

# Error handling
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
  file  => ">> ../debug.log",
  level => $DEBUG
});

# Add current working dir to @INC
use File::Basename;
use lib dirname(__FILE__);

# -----------------------------------------------------------------------------

print "Content-Type: text/html\n\n";

sub f_get_file_location {
  my $posts_path = '../html/posts/';
  my $file_location = $posts_path . 'post_' . time() . '.txt';
  return $file_location;
}

my $form = new CGI;
my $title = $form->param('title');
my $text = $form->param('text');
my $image = $form->param('image');
my $check = $form->param('check');

if(defined($check)) {
  my $file_location = f_get_file_location();
  my $image_path = '/assets/img/';

  open(FILE, ">$file_location") or die("Error al abrir fichero de entrada: $!");
  flock(FILE, 2) or die("Error al bloquear fichero de entrada: $!");
  print FILE $title;
  print FILE "\n\n";
  if($image ne '') {
    print FILE $image_path . $image;
    print FILE "\n\n";
  }
  print FILE $text;
  flock(FILE, 8) or die("Error al desbloquear fichero de entrada: $!");
  close FILE;

  if($image ne '') {
    $image =~ m/([^\/\\:]+)$/;
    my $image_name = $1;
    my $image_location = $image_path . $image_name;
    open(FILE, ">$image_location") or die("Error al abrir fichero de imagen: $!");
    binmode(FILE);
    print FILE <$image>;
    close(FILE);
  }

  if(-e $file_location) {
    print 'La entrada está publicada';
  } else {
    print 'Error al publicar la entrada';
  }
} else {
  print 'Eres un robot';
}
