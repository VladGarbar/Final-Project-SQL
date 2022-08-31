SELECT * FROM house_rent_dataset;

Select Floor, avg(Rent), avg(Size) #посмотрели ср цену и размер по этажам 
from house_rent_dataset
group by Floor
Order by avg(Rent) Desc;


Select Are_Locality, City, Rent # посмтотрели самые дорогие дома по локации и городам
from house_rent_dataset
#group by Are_Locality, City
Order by Rent desc
limit 20;


Select Area_Type,  avg(Rent) # посмтотрели самые дорогие типы мест по локации и городам
from house_rent_dataset
group by Area_Type
Order by avg(Rent) desc
limit 20;

Select * # посмтотрели топ 5 самые дорогие дома и их характеристики 
from house_rent_dataset
Order by Rent desc
limit 10;

Select Area_Type, Furnishing_Status, min(Rent), max(Rent) # посмтотрели мин цену за аренду и маккс по типам мест по локациям и заполнености квартиры
from house_rent_dataset
group by Area_Type, Furnishing_Status
Order by avg(Rent) desc;

Select Are_Locality, Furnishing_Status , round(std(Rent),2)  #стандартное отклонения по цене локации и заполнения квартиры
from house_rent_dataset
where Furnishing_Status = 'Unfurnished'
group by Are_Locality
Having std(Rent) > 0
Order by std(Rent) desc;


select month(Posted_On), avg(rent)  #показали ср аренду по месяцам где размер больше 500
FROM (select *
	from house_rent_dataset
    where Size > 500) as f
group by month(Posted_On)
Order by avg(rent) desc;


SELECT rent, City,
RANK () OVER(ORDER BY (rent) desc) AS number_ranked
FROM house_rent_dataset;


SELECT rent, City,
Dense_RANK () OVER(partition by City ORDER BY (rent) desc) AS number_ranked
FROM house_rent_dataset;



with avg_rent (avg_rent) as (select avg(rent) from house_rent_dataset) #показываем аренду котоорая выше средней 
select *
from house_rent_dataset as h, avg_rent as av
where h.rent > av.avg_rent
Order by h.rent desc;

Select h.Are_Locality, sum(rent)
from house_rent_dataset as h
group by h.Are_Locality;

select avg(total_rent_per_locality) as avg_rent_for_all_h
from (Select h.Are_Locality, sum(rent) as total_rent_per_locality
		from house_rent_dataset as h
		group by h.Are_Locality) as s;
        
        
        
 Select *
 
 from (Select h.Are_Locality, sum(rent) as total_rent_per_locality  #посмотрели какие лоакации в общем по цене аренды дороже чем ср по вмем местам 
		from house_rent_dataset as h
		group by h.Are_Locality) as total_rent        
join (select round(avg(total_rent_per_locality), 0) as avg_rent_for_all_h
		from (Select h.Are_Locality, sum(rent) as total_rent_per_locality
				from house_rent_dataset as h
				group by h.Are_Locality) as s) avg_rent
on total_rent.total_rent_per_locality > avg_rent.avg_rent_for_all_h;


     
Select h.*,
max(size) over(partition by City) as max_size
from house_rent_dataset as h;

Select * from 

	(Select h.*,
	row_number() over(partition by City order by Are_Locality) as rn # первые локации з каждого города 
	from house_rent_dataset as h) as row_numb
 where row_numb.rn < 3;


 Select h.Are_Locality, h.City, h.Rent,
 lag(Rent) over(partition by City order by Are_Locality) as prev_loc_rent,
 lead(Rent) over(partition by City order by Are_Locality) as next_loc_rent
 from house_rent_dataset as h;
 
 
 Select h.*,
 lag(Rent) over(partition by City order by Are_Locality) as prev_loc_rent,
 Case when h.rent > lag(Rent) over(partition by City order by Are_Locality)  then 'Більше попереднього'
		when h.rent > lag(Rent) over(partition by City order by Are_Locality)  then 'менше попереднього'
		when h.rent < lag(Rent) over(partition by City order by Are_Locality)  then 'дорінює попереднього'
		end ren_range
        	
 from house_rent_dataset as h ;
 