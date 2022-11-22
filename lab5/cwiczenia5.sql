CREATE EXTENSION postgis;

-- ZADANIE 1
CREATE TABLE obiekty(id int, geometry geometry, name varchar);

INSERT INTO obiekty VALUES
(1, ST_Collect(ARRAY['LINESTRING(0 1, 1 1)','CIRCULARSTRING(1 1, 2 0, 3 1)','CIRCULARSTRING(3 1, 4 2, 5 1)','LINESTRING(5 1, 6 1)']), 'obiekt1')

INSERT INTO obiekty VALUES
(2, ST_Collect(
		ARRAY[
			'LINESTRING(10 6, 14 6)',
			'CIRCULARSTRING(14 6, 16 4, 14 2)',
			'CIRCULARSTRING(14 2, 12 0, 10 2)',
			'LINESTRING(10 2, 10 6)',
			'CIRCULARSTRING(11 2, 12 3, 13 2)',
			'CIRCULARSTRING(11 2, 12 1, 13 2)']
		),
		'obiekt2');

INSERT INTO obiekty VALUES
(3,ST_Collect(array['LINESTRING(7 15,10 17)','LINESTRING(10 17,12 13)','LINESTRING(12 13,7 15)']) ,'obiekt3');

INSERT INTO obiekty VALUES
(4,ST_Collect(array['LINESTRING(20 20,25 25)','LINESTRING(25 25,27 24)','LINESTRING(27 24,25 22)','LINESTRING(25 22,26 21)','LINESTRING(26 21,22 19)','LINESTRING(22 19,20.5 19.5)']) ,'obiekt4');

INSERT INTO obiekty VALUES
(5,ST_Collect('POINT(30 30 59)','POINT(38 32 234)') ,'obiekt5');

INSERT INTO obiekty VALUES
(6,ST_Collect('POINT(4 2)','LINESTRING(1 1, 3 2)') ,'obiekt6');

-- ZADANIE 2

select ST_Area(ST_Buffer(ST_ShortestLine(o1.geometry,o2.geometry),5)) from obiekty o1, obiekty o2 where o1.name = 'obiekt3' and o2.name = 'obiekt4'

-- ZADANIE 3
--Obiekt4 może byc poligonem jezeli bedzie to figura zamknięta (pierwszy i ostatni punkt sa takie same), neleży zmienić jeden punkt aby zamknąć obiekt, lub dodać linię, która go zamknie

update obiekty set geometry = 'MULTILINESTRING ((20 20, 25 25), (25 25, 27 24), (27 24, 25 22), (25 22, 26 21), (26 21, 22 19), (22 19, 20.5 19.5),(20.5 19.5, 20 20))' where name = 'obiekt4'
update obiekty set geometry = ST_MakePolygon(st_linemerge( geometry)) where name = 'obiekt4'

--ZADANIE 4
INSERT INTO obiekty values (7,(select ST_Collect(o1.geometry,o2.geometry) from obiekty o1, obiekty o2 where o1.name = 'obiekt3' and o2.name = 'obiekt4'),'obiekt7')

--ZADANIE 5
select ST_AREA(ST_Buffer(geometry,5)) from obiekty where ST_HasArc(geometry) = FALSE
