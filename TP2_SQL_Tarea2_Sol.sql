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


