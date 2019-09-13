-- verify if there is more than one street with the same name
select ou.id, ou.name from streets_pilot_area ou
where (
	select count(*) 
	from streets_pilot_area inr
	where inr.name = ou.name
) > 1
ORDER BY ou.name, ou.id;
