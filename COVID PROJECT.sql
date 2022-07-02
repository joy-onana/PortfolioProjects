-----COVID WORLD VACCINATIONS

select * from dbo.['project portfolio$']

---1-Figures by Population (Continent)
select location, max(cast(people_vaccinated as int)) as vaccinations,population
from dbo.['project portfolio$']
where continent is null
and location != 'International'
group by location, population


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


--------previous day figure (Nigeria as case study)
with Nigeria_data ( date_,location,total_cases,vaccinations,population,percentage_vaccinated)
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
select Nigeria_data.*, 
round((percentage_vaccinated/ LAG(percentage_vaccinated) OVER (ORDER BY date_) - 1),2) as vac_growth,
round((vaccinations/ Lag(vaccinations) OVER (ORDER BY date_) - 1),2) as vac_growth2
from o
order by date_ asc

--------day on day growth (Nigeria as case study)
with all_vac
as 
(select date,
location, total_cases,
max(cast(people_vaccinated as int)) as curent_vaccinations,
lag(max(cast(people_vaccinated as int))) OVER (ORDER BY date - 1) as previous_vaccinations
,population,
round((cast(people_vaccinated as int))/population*100,2) as percentage_vaccinated,
LAG(max((cast(people_vaccinated as int))/population*100)) OVER (ORDER BY date - 1) as previous_per_vaccinated
from dbo.['project portfolio$']
where location = 'Nigeria'
and cast( date as date) >= '2021-03-01'
group by location, population,date,total_cases,
cast(people_vaccinated as int),
round((cast(people_vaccinated as int))/population*100,2))
select all_vac.*, 
(curent_vaccinations) - (previous_vaccinations)/(previous_vaccinations) as growth,
(curent_vaccinations) - (previous_vaccinations)/(previous_vaccinations) * 100 as per_growth
from all_vac
order by date desc




-----FINAL DATA SCRIPTING FOR PERSONAL PROJECT
select date,
location, total_cases,new_cases,cast(total_deaths as int) as total_deaths,
max(cast(people_vaccinated as int)) as curent_vaccinations, 
cast(people_fully_vaccinated as int) as fully_vaccinated,
lag(max(cast(people_vaccinated as int))) OVER (ORDER BY date - 1) as previous_vaccinations
,population,
round((cast(people_vaccinated as int))/population*100,2) as percentage_vaccinated,
LAG(max((cast(people_vaccinated as int))/population*100)) OVER (ORDER BY date - 1) as previous_per_vaccinated
from [dbo].['owid-covid-data (2)$']
where continent is null
and location not in  ('International', 'World')
and cast( date as date) >= '2021-03-01'
group by location, population,date,total_cases,new_cases,cast(total_deaths as int),
cast(people_vaccinated as int),cast(people_fully_vaccinated as int),
round((cast(people_vaccinated as int))/population*100,2)




