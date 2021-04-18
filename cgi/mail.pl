#!/usr/bin/perl -w

# Error handling
use strict;
# use warnings;
use CGI::Carp qw(fatalsToBrowser);

# Form handling
# use CGI qw(:standard);
# OOP form handling:
use CGI;

# Dumper
use Data::Dumper;

# Log4perl
use Log::Log4perl qw(:easy);
Log::Log4perl->easy_init({
  file => ">> ..debug.log",
  level => $DEBUG
});

# Add current working dir to @INC
use File::Basename;
use lib dirname(__FILE__);

# -----------------------------------------------------------------------------

print "Content-Type: text/html\n\n";

my $form = new CGI;
my $to = "contact\@example.com";
my $from = $form->param('from');
my $subject = $form->param('subject');
my $message = $form->param('message');
my $check = $form->param('check');
my $smail = '/usr/sbin/sendmail';

if(defined($check)) {
  open(MAIL, "|$smail -t $to") or die("Error can't open $smail: $!\n");

  print MAIL "To: $to\n";
  print MAIL "From: $from\n";
  print MAIL "Subject: $subject\n";
  print MAIL "$message";

  close MAIL or die("Error can't close $smail: $!");
} else {
  print 'Eres un robot';
}