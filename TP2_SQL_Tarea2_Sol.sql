--Diego Pérez Reyes - 181059
--Isaac Alejandro Pimentel Morales - 184041

--a. Escribir el nombre de las universidades que tienen carreras en el área de ‘Ingeniería’, junto con
--el nombre de dichas carreras y el de sus egresados.

select NomOrg, NomCar, NomA 
from Organización o, Autor a, Carrera c, Estudió e
where c.Área = 'Ingeniería' and e.IdCar = c.IdCar and e.IdA = a.IdA and e.IdCar = c.IdCar and e.IdOrg = o.IdOrg
order by NomOrg desc

--b. Listar el título de las tesis que participaron en concursos del año pasado. Ordenar
--descendentemente por nombre del concurso y ascendentemente por nombre de la tesis.

select NomT, NomCon
from Tesis t, Concurso c, Ganó g
where extract (year from FechaFin) = extract(year from sysdate)-1 and extract (year from FechaIni) = extract(year from sysdate)-1 and t.IdT = g.IdT and c.IdCon = g.IdCon
order by NomCon desc, NomT asc

--c. Mostrar el nombre de las empresas que han participado en la organización de concursos con
--montos mínimos de 40,000. Ordenar descendentemente por año y por monto.

select e.NomOrg, extract(year from c.FechaFin), Monto
from Organizó o, Organización e, Concurso c
where o.Monto >= 40000 and o.IdOrg = e.IdOrg and c.IdCon = o.IdCon
order by extract(year from c.FechaFin) desc, Monto desc

--d. Obtener el nombre de todas las carreras que son licenciaturas, junto con el nombre de las
--universidades en que se imparten.

select NomCar, NomOrg
from Carrera c, Imparte i, Escuela e
where c.Área like 'Licenciatura' and i.IdCar = c.IdCar and e.IdOrg = i.IdOrg

--e. Escribir el nombre de los concursos, y el año, en los cuales no participaron egresados del ITAM.
--Ordenar ascendentemente por año.

select NomCon, extract(c.FechaFin, year)
from Concurso c, Ganó g, Tesis T, Estudió e, Organización o
where o.NomOrg not like 'ITAM' and o.IdOrg = e.IdOrg and e.IdT = t.IdT and g.IdT = t.IdT and c.IdCon = g.IdCon
 
--f. Listar el nombre de las tesis que ganaron algún lugar en los concursos BANAMEX y AMIME
--del año pasado (en ambos, no sólo en uno u otro).

select NomT
from Tesis t, Ganó g, Concurso c
where c.NomCon like 'BANAMEX' and extract(c.FechaFin, year) < '2020' and extract(c.FechaIni, year) = '2019' and t.IdT = g.IdT and g.IdCon = c.IdCon and t.NomT in (select NomT from Tesis t, Ganó g, Concurso c
where c.NomCon like 'AMIME' and extract(c.FechaFin, year) < '2020' and extract(c.FechaIni, year) = '2019' and t.IdT = g.IdT and g.IdCon = c.IdCon)

--g. Mostrar el nombre de los autores que participaron en algún concurso tanto el año pasado como
--éste (en ambos, no sólo en uno u otro). Acompañarlos con el nombre de la(s) carrera(s) de la(s)
--que egresaron.

select NomA, NomCar
from Autor a, Estudió e, Carrera ca, Tesis t, Ganó g, Concurso co
where extract(co.FechaFin, year) < '2020' and extract(co.FechaIni, year) = '2019' and co.IdCon in (select IdCon from Concurso c where extract(c.FechaFin, year) = '2020' and extract(c.FechaIni, year) = '2020') 
and e.IdA = a.IdA and e.IdCar = ca.IdCar and t.IdT = e.IdT and g.IdT = t.IdT and co.IdCon = g.IdCon
order by NomA desc

--h. Obtener el nombre de los alumnos que egresaron de alguna carrera del área de ‘Administrativas’
--o que participaron en algún concurso celebrado este año.

select NomA
from Autor a, Carrera c, Estudió e
where c.Área like 'Administrativas' and c.IdCar = e.IdCar and e.IdA = a.IdA

union

select NomA
from Autor a, Estudió e, Tesis t, Ganó g, Concurso c
where extract(c.FechaFin, year) = '2020' and extract(c.FechaIni, year) = '2020' and g.IdCon = c.IdCon and t.IdT = g.IdT and e.IdT = t.IdT and e.IdA = a.IdA

--i. Por empresa y por año, contar la cantidad de concursos que han organizado.

select NomOrg, extract(c.FechaFin, year), count(*)
from Organización org, Organizó o, Concurso c
where org.Tipo like 'Empresa' and o.IdOrg = org.IdOrg and o.IdCon = c.IdCon

--j. Escribir el nombre de las escuelas cuyos egresados han ganado algún lugar en más de dos
--concursos distintos.

select NomOrg
from Escuela o, Estudió e, Tesis t, Concurso c, Ganó g
where g.IdCon = c.IdCon and t.IdT = g.IdT and e.IdT = t.IdT and e.IdOrg = o.IdOrg
having countdif(IdCon)

--k. Listar el nombre de los concursos cuyo monto total de organización 
--fue de al menos 100,000. Acompañarlos con el nombre de las organizaciones 
--participantes, ordenando ascendentemente por nombre del concurso y descendentemente 
--por el de la organización.

select NomCon,NomOrg from Concurso c, Organizó o, Organización org
    where c.IdCon=o.IdCon and o.IdOrg=org.IdOrg and o.Monto>=100000
    order by NomCom asc, NomOrg desc

--l. Encontrar el nombre de los autores que ganaron el 
--primer lugar en máximo un concurso durante el año pasado. 
--Acompañarlos con el nombre de la tesis con la cual ganaron.

select NomA,NomT from Autor a, Estudió e, Tesis t, Ganó g, Concurso c 
    where a.IdA=e.IdA and e.IdT=t.IdT and t.IdT=g.IdT and g.IdCon=c.IdCon
        and g.lugar=1 and extract(year from c.FechaIni)=extract(year from sysdate)-1
        group by NomA having count(*)<=1

--m. Obtener el nombre de la(s) organización(es) que más 
--concursos ha(n) organizado.

select NomOrg from Organizó o, Organización org
    where o.IdOrg=org.IdOrg 
    group by org.NomOrg having count(*) >= all(select count(*) from Organizó o, Organización org
    where o.IdOrg=org.IdOrg 
    group by org.NomOrg)

--n. Mostrar el nombre de las carreras cuyos egresados tienen menos 
--participaciones en los concursos. Mostrar también el nombre 
--de las universidades en que se imparten.

select NomCar, NomOrg from Carrera c, Imparte i, Escuela e
    where c.IdCar=i.IdCar and i.IdOrg=e.IdOrg
        and NomCar in (select NomCar from Ganó g, Tesis t, Estudió e, Carrera c
    where g.IdT=t.IdT and t.IdT=e.IdT and e.IdCar=c.IdCar
    group by NomCar having count(*) <= all(select count(*) from Ganó g, Tesis t, Estudió e, Carrera c
    where g.IdT=t.IdT and t.IdT=e.IdT and e.IdCar=c.IdCar
    group by NomCar))

--o. Listar el nombre de las tesis, y el de sus autores, 
--que han participado en más concursos.

select NomT, NomA, count(*) from Tesis t, Ganó g, Estudió e, Autor a
    where t.IdT=g.IdT and i.idT=e.IdT and e.IdA=a.IdA
    group by t.IdT having count(*) >= all(select count(*) from Tesis t, Ganó g where t.IdT=g.IdT
    group by t.IdT)


--p. Escribir el nombre de las organizaciones (escuelas o empresas) 
--que han participado en la
--organización de todos los concursos registrados.

select NomOrg, count(*) from Concurso c, Organizó o
    where c.IdCon=o.IdCon 
    group by NomOrg having count(*)=(select count(*) from concurso)


