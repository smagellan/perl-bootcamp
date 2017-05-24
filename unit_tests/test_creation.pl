#! /usr/bin/perl

use strict;
use warnings FATAL => 'all';

use lib "/home/smagellan/yandex-perl/selenium-web-driver/lib/perl5";
use lib "/home/smagellan/proj/perl-bootcamp";
use BootcampSettings;
use Selenium::Remote::Driver;
use Test::More tests=>4;

my $driver = Selenium::Remote::Driver->new({browser_name => "chromium"});
$driver->get("http://localhost:".HTTP_PORT."/add/");

$driver->find_element('student_name','name')->send_keys("TestName");
$driver->find_element('student_surname','name')->send_keys("TestSurname");
$driver->find_element("//input[\@name='student_sex' and \@value='F']")->click();
$driver->find_element("student_birthday", "name")->send_keys("1987-12-01");
$driver->find_element("student_birthday", "name")->send_keys("1987-12-01");
$driver->find_element("student_nationality", "name")->send_keys("Russian");
$driver->find_element("student_address", "name")->send_keys("Test Address");
$driver->find_element("student_mark", "name")->send_keys("5");


sleep(30);
$driver->quit();
