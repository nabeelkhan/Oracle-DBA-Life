/*
 * createUser.sql
 * Chapter 10, Oracle10g PL/SQL Programming
 * by Ron Hardman, Michael McLaughlin and Scott Urman
 *
 * This script creates users for Chapter 8.
 */

create user usera identified by usera;
grant resource to usera;
grant connect to usera;

create user userb identified by userb;
grant resource to userb;
grant connect to userb;

create user example identified by example;
grant resource to example;
grant connect to example;
