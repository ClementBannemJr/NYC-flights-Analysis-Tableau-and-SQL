libname groupA "C:\Users\abannem\Documents\GitHub\BRT\Group assignment";

/*Average departure and arrival delays by airlines companies*/
proc sql;
create table DelaysByAirlinesCompanies as
select distinct avg(b.arr_delay) as AverageArrivalDelay, avg(dep_delay) as AverageDepartureDelay, a.name
from groupA.airlines as a, groupA.Flights as b
where a.carrier = b.carrier
	and b.dep_delay > 0
	and b.arr_delay > 0
group by a.name
;
quit;

/*Average departure and arrival delays by Airports*/
proc sql;
create table DelaysByAirports as
select distinct a.name as AirportName, a.faa as AirportsAbbr, avg(b.dep_delay) as AverageDepartureDelay, avg(arr_delay) as AverageArrivalDelay
from groupA.airports as a, groupA.Flights as b
where a.faa = b.origin
group by a.name
;
quit;

proc sql;
/*Delays Per Destination And Distance*/
create table Destination_Delays as
select distinct a.name as Destination_Airport, c.name as Origin_Airport
	,b.distance as MilesBetweenOrigin_Dest, a.faa as AirportAbbr
	, avg(b.arr_delay) as AverageArrivalDelay, month(datepart(b.time_hour)) as Month
from groupA.airports as a, groupA.flights as b, groupA.airports as c
where a.faa = b.dest
	and a.name <> 'La Guardia'
	and c.faa = b.origin
	and b.arr_delay > 0
group by 1
order by 6
;
quit;

/*Delays Per Destination And Distance Without Month*/
proc sql;
create table Destination_Delays_NoMonth as
select distinct c.name as Origin_Airport, a.name as Destination_Airport
	,b.distance as MilesBetweenOrigin_Dest,b.origin as OriginAirportAbbr, b.dest as DestAirportAbbr
	, avg(b.arr_delay) as AverageArrivalDelay
from groupA.airports as a, groupA.flights as b, groupA.airports as c
where a.faa = b.dest
	and c.faa = b.origin
	and b.arr_delay > 0
group by 2
;
quit;


/*Delays Per TimeZone*/
proc sql;
create table DelaysPerTimeZone as
select distinct a.tzone, avg(b.arr_delay) as AvgArrDelay, month(datepart(b.time_hour)) as Month,
year(datepart(b.time_hour)) as Year
from groupA.airports as a, groupA.flights as b
where a.faa = b.dest
and tzone is not null
and b.arr_delay > 0
group by 1,3
order by 3
;
quit;
