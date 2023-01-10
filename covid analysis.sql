select *from dbo.CovidDeaths 
select *from dbo.CovidVaccinations

select *from portfolio1..CovidDeaths order by 3,4


--Rows that are presented in the table
select count(*)
from CovidDeaths


select *from dbo.CovidDeaths 

--selected data which I am going to use 

select  location,date, total_cases,new_cases, total_deaths, population from portfolio1..CovidDeaths 

--ordered by location and date 

select  location,date, total_cases,new_cases, total_deaths, population 
from portfolio1..CovidDeaths 
order by 1,2
 

 -- To get the list of countries
select distinct location 
from dbo.CovidDeaths 
order by location 

-- To get the total number of countries 
select count (distinct location)as Total_num_countries  
from dbo.CovidDeaths  
 

 
--Total cases vs total deaths in percentage  of every country

select  location,date, total_cases,new_cases, total_deaths, population, (total_deaths/total_cases)*100 as Deathpercentage
from portfolio1..CovidDeaths 
order by 1,2

--Total cases vs total deaths in percentage in Germany

select  location,date, total_cases,new_cases, total_deaths, population, (total_deaths/total_cases)*100 as Deathpercentage
from portfolio1..CovidDeaths 
where location = 'Germany'
order by 1,2

-- Counting the numbe of rows where location = Germany
select  count(location)
from portfolio1..CovidDeaths 
where location = 'Germany'

--Total cases vs total deaths in percentage in Germany and India
select   location,date, total_cases,new_cases, total_deaths, population, (total_deaths/total_cases)*100 as Deathpercentage 
from dbo.CovidDeaths 
where location = 'Germany' or  location = 'India'
order by location desc

-- Total cases vs total deaths in percentage that countries name starts with "G"
select   location,date, total_cases,new_cases, total_deaths, population, (total_deaths/total_cases)*100 as Deathpercentage 
from dbo.CovidDeaths 
where location like 'G%'
order by 1,2



select new_cases from dbo.CovidDeaths where location = 'Germany' and date = '2021-04-30'

select *from dbo.CovidDeaths where location like 'G%'
select *from dbo.CovidDeaths where location like '%G'

select *from portfolio1..CovidDeaths where location not like '%[g]%'


--Looking at the total cases vs total population of Germany
--It shows what percentage of population got COVID
select  location,date, total_cases,new_cases, total_deaths, population, (total_cases/population)*100 as PercentPopulation_Infected
from portfolio1..CovidDeaths 
where location = 'Germany'
order by 1,2


--Looking at the total cases vs total population
--It shows what percentage of population got COVID
select  location,date, total_cases,new_cases, total_deaths, population, (total_cases/population)*100 as PercentPopulation_Infected
from portfolio1..CovidDeaths 
order by 1,2


select max(population)
from dbo.CovidDeaths 
group by location
order by population desc


--Looking at countries with highest infection rate compared to population 
select location, population, max(total_cases) as HighestInfectionCount, max(total_cases/population)*100   as PercentPopulation_Infected
from dbo.CovidDeaths
group by location, Population
order by PercentPopulation_Infected desc



-- Showing countries with highest death count per population
select location, max(cast(total_deaths as int)) as TotaldeathCount
from dbo.CovidDeaths
where continent is not null
group by location
order by TotaldeathCount desc


-- Showing countries with highest death count per population as percenatge 
select location,  population, max(cast(total_deaths as int)) as TotaldeathCount,  max(total_deaths/population)*100 as Death_Percentage_comparedTo_population
from dbo.CovidDeaths 
where continent is not null
group by location, population
order by Death_Percentage_comparedTo_population desc


--Showing TotalDeathCount by Continent wise
select continent, max(cast(total_deaths as int)) as TotalDeathCount
from dbo.CovidDeaths	
where continent is not null
group by continent
order by TotalDeathCount desc

--Showing total deaths date wise of Germany
select date, sum(cast(total_deaths as int)) as Totaldeathsbydate
from portfolio1..CovidDeaths
where location = 'GERMANY'
group by date
order by Totaldeathsbydate

-- Showing the totaldeaths of Germany until the 30.04.2021
select (max(cast(total_deaths as int)))
from dbo.CovidDeaths 
where location = 'Germany'

-- Daily Global numbers
Select date, sum(new_cases) as daily_cases, sum(cast(new_deaths as int)) as daily_deaths, (sum(cast(new_deaths as int))/sum(new_cases)*100) as death_percentage
from portfolio1..CovidDeaths
where continent is not null
group by date
order by 1,2


-- Looking at Daily vaccinations
select CovidDeaths.continent, CovidDeaths.location, CovidDeaths.date, CovidDeaths.population, CovidVaccinations.new_vaccinations
from portfolio1..CovidDeaths
join portfolio1..CovidVaccinations
	on CovidDeaths.location = CovidVaccinations.location
	and coviddeaths.date = CovidVaccinations.date
	where coviddeaths.continent is not null 
	order by 2,3

-- Looking at daily vaccinations and Total Vaccinations
select CovidDeaths.continent, CovidDeaths.location, CovidDeaths.date, CovidDeaths.population, CovidVaccinations.new_vaccinations as daily_vaccinations,
sum(convert(int, CovidVaccinations.new_vaccinations)) over (partition by coviddeaths.location order by coviddeaths.location, coviddeaths.date) as  Total_People_Vaccinated
from portfolio1..CovidDeaths
join portfolio1..CovidVaccinations
	on CovidDeaths.location = CovidVaccinations.location
	and coviddeaths.date = CovidVaccinations.date
	where coviddeaths.continent is not null 
	order by 2,3
