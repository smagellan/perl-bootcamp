#! /usr/bin/perl

use strict;
use warnings FATAL => 'all';

use utf8;
use open qw(:std :utf8);
use lib "/home/smagellan/yandex-perl/selenium-web-driver/lib/perl5";
use lib "/home/smagellan/proj/perl-bootcamp";
use BootcampSettings;
use Selenium::Remote::Driver;
use Test::More tests=>2;

my $driver = Selenium::Remote::Driver->new({browser_name => "chromium"});


my $server_root_url = "http://localhost:".HTTP_PORT;
$driver->get($server_root_url."/add/");

$driver->find_element('student_name','name')->send_keys("TestName");
$driver->find_element('student_surname','name')->send_keys("TestSurname");
$driver->find_element("//input[\@name='student_sex' and \@value='F']")->click();
$driver->find_element("student_birthday", "name")->send_keys("1987-12-01");
$driver->find_element("student_birthday", "name")->send_keys("1987-12-01");
$driver->find_element("student_nationality", "name")->send_keys("Russian");
$driver->find_element("student_address", "name")->send_keys("Test Address");
$driver->find_element("student_mark", "name")->send_keys("5");
$driver->find_element("submit_form_btn", "name")->click();
is($driver->get_current_url(), $server_root_url."/", "post-edit redirect to root page");
my $table_text = $driver->get_text("students_list_table", "id");
ok($table_text =~ "TestName" && $table_text =~ "TestSurname", "list table contains our's entry");

$driver->quit();
