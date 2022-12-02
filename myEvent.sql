use master
GO

drop database if exists myEvent_v1;

CREATE database myEvent_v1;


-- DOWN

if exists(select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS 
    where CONSTRAINT_NAME='fk_tickets_ticket_person_id')
    alter table tickets drop constraint fk_tickets_ticket_person_id

GO
drop table if exists tickets 

if exists(select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS 
    where CONSTRAINT_NAME='fk_reviews_review_person_id')
    alter table reviews drop constraint fk_reviews_review_person_id

GO
drop table if exists reviews 

Go


if exists(select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS 
    where CONSTRAINT_NAME='fk_people_person_zipcode')
    alter table people drop constraint fk_people_person_zipcode

GO
drop table if exists people
GO


if exists(select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS 
    where CONSTRAINT_NAME='fk_events_event_type')
    alter table events drop constraint fk_events_event_type

GO

if exists(select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS 
    where CONSTRAINT_NAME='fk_events_event_venue_id')
    alter table events drop constraint fk_events_event_venue_id
GO   

if exists(select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS 
    where CONSTRAINT_NAME='fk_events_event_service_id')
    alter table events drop constraint fk_events_event_service_id
GO 

drop table if exists events
GO

drop table if exists event_types
GO

drop table if exists services
GO


if exists(select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS 
    where CONSTRAINT_NAME='fk_venues_venue_zipcode')
    alter table venues drop constraint fk_venues_venue_zipcode

GO    

drop table if exists venues
GO


drop table if exists zipcodes
GO

drop table if exists type_of_services
-- UP Metadata


GO
create table zipcodes (
    zipcode char(5) not null,
    zipcode_area_name varchar(20) not null,
    zipcode_city varchar(10) not null,
    zipcode_state char(2) not null,
    constraint pk_zipcodes_zipcode primary key(zipcode)
)
GO

create table type_of_services (
    type_id int identity not null,
    type_name varchar(20) not null,
    type_food_offered int not null default 0,
    type_alcohol_offered int not null default 0,
    constraint pk_services_types_type_id primary key (type_id),   
 )



GO
create table services (
    service_id int identity not null,
    my_service_name varchar(20) not null,
    service_price money not null,
    service_type_id int not null,
    service_provider_id int not null,
    constraint pk_services_service_id primary key (service_id),   
 )
 GO
 /*
alter table services 
    add constraint fk_services_venue_zipcode foreign key (venue_zipcode)
        references zipcodes(zipcode)
*/

GO
create table venues (
    venue_id int identity not null,
    venue_name varchar(50) not null,
    venue_capacity int not null,
    venue_street_address varchar(50) not null,
    venue_zipcode char(5) not null,
    venue_owner_id int not null,
    constraint pk_venues_venue_id primary key (venue_id),   
 )
 GO
alter table venues 
    add constraint fk_venues_venue_zipcode foreign key (venue_zipcode)
        references zipcodes(zipcode)



create table event_types (
    event_type varchar(50) not null, 
    constraint pk_event_type  primary key (event_type),   
)

create table events (
    event_id int identity not null,
    event_type varchar(50) not null,
    event_date datetime not null,
    event_length int not null,
    event_organizer_id int not null,
    event_venue_id int not null,
    event_service_id int not null,
    event_description varchar(100),  
    constraint pk_events_event_id primary key (event_id),   
)
Go
alter table events 
    add constraint fk_events_event_type foreign key (event_type)
        references event_types(event_type)
GO        
alter table events 
    add constraint fk_events_event_venue_id foreign key (event_venue_id)
        references venues(venue_id)
GO      
alter table events 
    add constraint fk_events_event_service_id foreign key (event_service_id)
        references services(service_id)

GO
create table people (
    person_id int identity not null,
    person_email varchar(50) not null,
    person_firstname varchar(50) not null,
    person_lastname varchar(50) not null,
    person_phone_no char(10) not null,
    person_year varchar(10),
    person_street_address varchar(50) not null,
    person_house_no varchar(6),
    person_zipcode char(5) not NULL, 
    constraint pk_people_person_id primary key (person_id),
    constraint u_people_person_email unique (person_email),
    
)
GO
alter table people 
    add constraint fk_people_person_zipcode foreign key (person_zipcode)
        references zipcodes(zipcode)

GO
create table reviews (
    review_id int identity not null,
    review_text varchar(200) not null,
    review_date DATETIME not null,
    review_rating int not null,
    review_event_id int not null,
    review_person_id int not null,
   
    constraint pk_reviews_review_id primary key (review_id), 
)        

GO
alter table reviews
    add constraint fk_reviews_review_person_id foreign key (review_person_id)
        references people(person_id)
Go
alter table reviews
    add constraint fk_reviews_review_event_id foreign key (review_event_id)
        references events(event_id)


GO
create table tickets (
    ticket_id int identity not null,
    ticket_attended int not null default 0 ,
    ticket_issued_date DATETIME not null,
    ticket_event_id int not null,
    ticket_person_id int not null,
   
    constraint pk_tickets_ticket_id primary key (ticket_id), 
)        

GO
alter table tickets
    add constraint fk_tickets_ticket_person_id foreign key (ticket_person_id)
        references people(person_id)
Go
alter table tickets
    add constraint fk_tickets_ticket_event_id foreign key (ticket_event_id)
        references events(event_id)



-- UP Data

insert into type_of_services
    (type_name ) 
    values
    ('Food and Beverage'), ('Music'), ('Organizing')


GO 


insert into zipcodes 
    (zipcode, zipcode_area_name, zipcode_city,zipcode_state ) 
    values
    ('13210','Brighton PL', 'Syracuse', 'NY')

GO 

insert into venues
    ( venue_name,venue_capacity, venue_street_address, venue_zipcode,venue_owner_id)  
    values
    ('Hinds iCafe', 20,'school of Information Studies','13210',1)

GO


insert into services
    ( my_service_name,service_price, service_type_id, service_provider_id)  
    values
    ('Food and Beverage', 20,1,1)


GO
insert into event_types
    (event_type)  
    values
    ('Conference'),('Seminars'),('Reunion'),('Food festival')

 insert into events 
    (event_type,event_date, event_length, event_organizer_id,event_venue_id, event_service_id)
    VALUES
    ('Conference',2022-12-01,3,1,1,1)     


GO
insert into people
    (person_email, person_firstname, person_lastname, person_phone_no, person_year, person_street_address,person_house_no,person_zipcode )  
    values
    ('sabdelra@syr.edu', 'Somia', 'Abdelrahman', '3157607703', 'Graduate', '4101 Brighton Pl', '3413', '13210')

GO
insert into reviews
    (review_text, review_date, review_rating, review_event_id, review_person_id )  
    values
    ('The event was excellent',2022-02-01 ,5, 1, 1)

GO
insert into tickets
    (ticket_issued_date, ticket_event_id, ticket_person_id )  
    values
    (2022-02-01 , 1, 1) 




  




-- Verify
select * from zipcodes
select * from people
select * from reviews
select * from tickets
select * from event_types 
select * from events
select * from venues
select * from services 

GO