select *
from covid$

-- TOTAL CASES VS TOTAL DEATHS
select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as deathpercentage
from covid$
where continent is not null
order by location

--TOTAL CASE VS POPULATION
select location, date, total_cases, population, total_cases/population as CasePerPopulation
from covid$
where continent is not null
order by location

--COUNTRY WITH HIGHEST INFECTION RATE
select continent, location, MAX(total_cases) as Total_Case, population, MAX(total_cases/population)*100 as InfectionRate
from covid$
where continent is not null
group by continent, location, population
order by InfectionRate desc

--COUNTRY WITH HIGHEST DEAD RATE PER POPULATION
select continent, location, MAX(total_deaths) as Total_Death, population, MAX(total_deaths/population)*100 as DeathRatePerPopulation
from covid$
where continent is not null
group by continent, location, population
order by DeathRatePerPopulation desc

--TOTAL DEATH IN EACH COUNTRIES
select location, MAX(convert(int,total_deaths)) as total_deaths
from covid$
where continent is not null
group by location
order by total_deaths desc

--TOTAL DEATH IN EACH CONTINENT
select location, MAX(convert(int,total_deaths)) as total_deaths
from covid$
where continent is null
group by location
order by total_deaths desc

--GLOBAL NUMBERS
select date, SUM(new_cases) as Total_Cases
from covid$
where continent is not null
group by date
order by 1,2

select date, SUM(new_cases) as Total_Cases, SUM(convert(int,new_deaths)) as Total_Death, 
	SUM(convert(int,new_deaths))/SUM(new_cases)*100 as DeathPercentage
from covid$
where continent is not null
group by date
order by 1,2

--VACCINATION VS POPULATION
select continent, location, date, population, new_vaccinations, (new_vaccinations/population)*100 as DailyVaccinationRate
from covid$
where continent is not null 
order by 1,2,3

--TOTAL VACCINATIONS IN EACH COUNTRIES
select location, population, SUM(cast(new_vaccinations as int)) as Total_Vaccinations
from covid$
where continent is not null 
group by location, population
order by Total_Vaccinations desc

--USING CTE
With VaccinationRate (location, population, Total_Vaccinations)
as
(
select location, population, SUM(cast(new_vaccinations as int)) as Total_Vaccinations 
from covid$
where continent is not null 
group by location, population
)

select *, (Total_Vaccinations/population)*100 as PercentageVaccinated
from VaccinationRate
order by location

--CREATE VIEW

create view PercentageVaccinated as
With VaccinationRate (location, population, Total_Vaccinations)
as
(
select location, population, SUM(cast(new_vaccinations as int)) as Total_Vaccinations 
from covid$
where continent is not null 
group by location, population
)

select *, (Total_Vaccinations/population)*100 as PercentageVaccinated
from VaccinationRate
