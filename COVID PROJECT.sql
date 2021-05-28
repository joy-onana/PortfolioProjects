-----COVID WORLD VACCINATIONS

select * from dbo.['project portfolio$']

---1-Figures by Population (Continent)
select location, max(cast(people_vaccinated as int)) as vaccinations,population
from dbo.['project portfolio$']
where continent is null
and location != 'International'
group by location, population,month(cast( date as date))


---2---- Including percentage vaccinated (continent)
select location, max(cast(people_vaccinated as int)) as vaccinations,population,
round((max(cast(people_vaccinated as int)))/population*100,2) as percentage_vaccinated
from dbo.['project portfolio$']
where continent is null
and location != 'International'
group by location, population 

------3---- creating a month column from the date column
select cast( date as date), DATENAME(mm,cast( date as date)) as monthname
from dbo.['project portfolio$']

-----4----including the month column in script 2 
select DATENAME(mm,cast( date as date)) as monthname,
location, max(cast(people_vaccinated as int)) as vaccinations,population,
round((max(cast(people_vaccinated as int)))/population*100,2) as percentage_vaccinated
from dbo.['project portfolio$']
where continent is null
and location != 'International'
and cast( date as date) >= '2021-03-01'
group by location, population,DATENAME(mm,cast( date as date))


--------day on day vaccinated growth 9Nigeria as case study)
with o ( date_,location,total_cases,vaccinations,population,percentage_vaccinated)
as   
(
select cast( date as date) as date_,
location, total_cases,
cast(people_vaccinated as int) as vaccinations
,population,
round((max(cast(people_vaccinated as int)))/population*100,2) as percentage_vaccinated
from dbo.['project portfolio$']
where location = 'Nigeria'
and cast( date as date) >= '2021-03-01'
group by location, population,cast( date as date),total_cases,cast(people_vaccinated as int)
)
select o.*, 
round((percentage_vaccinated/ LAG(percentage_vaccinated) OVER (ORDER BY date_) - 1),2) as vac_growth,
round((vaccinations/ Lag(vaccinations) OVER (ORDER BY date_) - 1),2) as vac_growth2
from o
order by date_ asc