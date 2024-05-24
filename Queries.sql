/*
https://mystery.knightlab.com/
A crime has taken place and the detective needs your help. The detective gave you the crime scene report, but you somehow lost it. 
You vaguely remember that the crime was a ​murder​ that occurred sometime on ​Jan.15, 2018​ and that it took place in ​SQL City​. 
*/

SELECT description
FROM crime_scene_report
WHERE TYPE = 'murder'
  AND city = 'SQL City'
  AND date = '20180115' 

-- new lead: id of witness 1 = 16371

  SELECT *
  FROM person WHERE address_street_name = 'Northwestern Dr'
ORDER BY address_number DESC -- new lead: id of witness 2  = 14887

SELECT *
FROM facebook_event_checkin
WHERE person_id = 14887
  SELECT *
  FROM facebook_event_checkin WHERE person_id = 16371 -- new lead : event id: 4719, both witnesses attended it

  SELECT count(*)
  FROM facebook_event_checkin WHERE event_id= 4719 

-- new lead: the event had only 24 people, narrows our search pool

  SELECT *
  FROM interview WHERE person_id = 14887 

/*
 new lead:
The membership number on the bag started with "48Z".
Only gold members have those bags.
The man got into a car with a plate that included "H42W".
*/

  SELECT *
  FROM interview WHERE person_id = 16371 

/*new lead: 
I saw the murder happen,
and I recognized the killer from my gym when I was working out
last week on January the 9th.

So far we know about killer:
- goes to get fit now
- gold member
- went to the gym on jan 9th and the time the witness and the killer were there overlapped
at some point
- his membership started with 48Z
- plate number included H42W
*/
  SELECT *
  FROM
    (SELECT *
     FROM get_fit_now_member AS members
     JOIN get_fit_now_check_in AS ch ON ch.membership_id = members.id
     WHERE membership_status= 'gold'
       AND id like '48Z%' ) AS g
  INNER JOIN get_fit_now_check_in AS ch2 ON ((g.check_in_time <= ch2.check_in_time
                                              AND g.check_out_time >= ch2.check_in_time)
                                             OR (g.check_in_time >= ch2.check_in_time
                                                 AND g.check_in_time <= ch2.check_out_time)
                                             AND (g.check_in_date = ch2.check_in_date
                                                  AND g.check_in_date = '20180109'))
  INNER JOIN person ON g.person_id = person.id
  INNER JOIN drivers_license AS d ON d.id = person.license_id WHERE d.plate_number like '%H42W%'

/*
Congrats, you found the murderer!
*/
