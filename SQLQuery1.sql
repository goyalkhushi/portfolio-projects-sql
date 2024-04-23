Select * 
From Project..CovidDeaths$
order by 3,4

Select *
From Project..CovidVaccinations$
order by 3,4

--Select Data that we are going to be using

Select Location, date, total_cases, new_cases, total_deaths, population
From Project..CovidDeaths$
order by 1,2

--Looking at Total Cases vs Total Deaths
Select Location, date, total_cases, new_cases, total_deaths, population
From Project..CovidDeaths$
order by 1,2
--shows likelihood of dying if you contract covid in your country
Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From Project..CovidDeaths$
where Location like '%states%'
order by 1,2


--Looking at Total cases vs population
--shows what percentage of population got
Select Location, date, total_cases, population, (total_cases/population)*100 as DeathPercentage
From Project..CovidDeaths$
--where Location like '%states%'
order by 1,2

--Looking at countries with Highest Infection rate compared to population
Select Location,  population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population)*100) as PercentagePopulationInfected
From Project..CovidDeaths$
Group by Location,population
order by 1,2

Select Location,  population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population)*100) as PercentagePopulationInfected
From Project..CovidDeaths$
Group by Location,population
order by PercentagePopulationInfected desc

--Showing the Countries with Highest Death Count per population
Select Location, MAX(total_deaths ) as TotalDeathCount
From Project..CovidDeaths$
Group by Location
order by TotalDeathCount desc

Select Location, MAX(cast(total_deaths as int )) as TotalDeathCount
From Project..CovidDeaths$
where continent is not null
Group by Location
order by TotalDeathCount desc

--Lets break things down by continent
Select continent, MAX(cast(total_deaths as int )) as TotalDeathCount
From Project..CovidDeaths$
where continent is not null
Group by continent
order by TotalDeathCount desc

--More accurate data of above query
Select location, MAX(cast(total_deaths as int )) as TotalDeathCount
From Project..CovidDeaths$
where continent is null
Group by location
order by TotalDeathCount desc
 

-- Showing the Continents with the highest  death count per population
 Select continent, MAX(cast(total_deaths as int )) as TotalDeathCount
From Project..CovidDeaths$
where continent is not null
Group by continent
order by TotalDeathCount desc

--GLobal Numbers
Select  date, SUM(new_cases),SUM(cast(new_deaths as int)), SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
From Project..CovidDeaths$
--where Location like '%states%'
where continent IS NOT NULL
Group by date
order by 1,2

Select *
From Project..CovidDeaths$ dea
join Project..CovidVaccinations$ vac
on dea.location=vac.location

Select   SUM(new_cases) as total_Cases,SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
From Project..CovidDeaths$
--where Location like '%states%'
where continent IS NOT NULL
--Group by date
order by 1,2

--Join both the tables
Select * 
From Project..CovidDeaths$ dea
Join Project..CovidVaccinations$ vac
On dea.location=vac.location
and dea.date=vac.date


--Looking at Total Populaiton vs Vaccination

select * from Project..CovidVaccinations$
 
Select dea.continent, dea.location,dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(int,vac.new_vaccinations )) OVER (Partition by dea.location order by dea.location,dea.date)
as RollingPeopleVaccinated 
From Project..CovidDeaths$ dea
Join Project..CovidVaccinations$ vac
On dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null
order by 2,3




--use CTE
With PopvsVac (Continent,location,date,population, New_Vaccinations,RollinhPeopleVaccinated)
as(Select dea.continent, dea.location,dea.date, dea.population, vac.New_Vaccinations, SUM(CONVERT(int,vac.new_vaccinations )) OVER (Partition by dea.location order by dea.location,dea.date)
as RollingPeopleVaccinated 
From Project..CovidDeaths$ dea
Join Project..CovidVaccinations$ vac
On dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null
order by 2,3
)
select *,(RollinhPeopleVaccinated/population)*100
From PopvsVac

--TEMP TABLE
Drop Table if Exists #PercentPopulatiinVaccinated
Create Table #PercentPopulationVaccinated(
Continent nvarchar(255) ,
location nvarchar(255),
date datetime,
population numeric,
New_Vaccinations numeric,
RollingPeopleVaccinated numeric)

INSERT into #PercentPopulationVaccinated
Select dea.continent, dea.location,dea.date, dea.population, vac.New_Vaccinations, SUM(CONVERT(int,vac.new_vaccinations )) OVER (Partition by dea.location order by dea.location,dea.date)
as RollingPeopleVaccinated 
From Project..CovidDeaths$ dea
Join Project..CovidVaccinations$ vac
On dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null
-- order by 2,3
select *,(RollingPeopleVaccinated/population)*100
From #PercentPopulationVaccinated





--creating view to store data for later visualization
Create View PercentPopulationVaccinated as
Select dea.continent, dea.location,dea.date, dea.population, vac.new_v accinations, SUM(CONVERT(int,vac.new_vaccinations )) OVER (Partition by dea.location order by dea.location,dea.date)
as RollingPeopleVaccinated 
From Project..CovidDeaths$ dea
Join Project..CovidVaccinations$ vac
On dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null
--order by 2,3

Select *
From PercentPopulationVaccinated