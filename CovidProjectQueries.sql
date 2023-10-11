Select * 
from dbo.CovidDeaths
where continent is not null
order by 3,4

--Select * 
--from dbo.covidvaccinations
--where continent is not null
--order by 3,4

-- Data to be used

Select Location, date, total_cases, new_cases, total_deaths, population 
from dbo.CovidDeaths
where continent is not null
order by 1,2

-- Total Cases vs Total Deaths by Percentage showing the likelihood of dying if you contact the virus in your country

SELECT Location, date, total_cases, total_deaths, 
       (CONVERT(float, total_deaths) / CONVERT(float, total_cases)) * 100 AS DeathPercentage
FROM dbo.CovidDeaths
Where location like '%states%' AND
	continent is not null
ORDER BY 1, 2;


-- Total Cases vs the Population showing the percentage of Population contacting covid

SELECT Location, date, total_cases, population, 
       (CONVERT(float, total_cases)/population) * 100 AS PercentPopulationInfected
FROM dbo.CovidDeaths
Where location like '%states%'  AND
	continent is not null
ORDER BY 1, 2;


-- Countries with Highest Infection Rate Compared to Population

SELECT Location, population, Max(total_cases) as HighestInfectionCount, 
       Max((CONVERT(float, total_cases)/population)) * 100 AS PercentPopulationInfected
FROM dbo.CovidDeaths
--Where location like '%states%'
where continent is not null
Group by location, population
ORDER BY PercentPopulationInfected desc;


-- Countries with Highest Death Count Per Population

SELECT Location, Max(Cast(total_deaths as int)) as TotalDeathCount
FROM dbo.CovidDeaths
--Where location like '%states%'
where continent is not null
Group by location
ORDER BY TotalDeathCount desc;

-- Breakdown By Continent 
-- Total Deaths Count

SELECT continent, Max(Cast(total_deaths as int)) as TotalDeathCount
FROM dbo.CovidDeaths
--Where location like '%states%'
where continent is not null
Group by continent
ORDER BY TotalDeathCount desc;

--Continent With High Death Count per Population

-- Total Cases vs Total Deaths by Percentage showing the likelihood of dying if you contact the virus in your Continent

SELECT continent, date, total_cases, total_deaths, 
       (CONVERT(float, total_deaths) / CONVERT(float, total_cases)) * 100 AS DeathPercentage
FROM dbo.CovidDeaths
--Where continent like '%states%'
where continent is not null
ORDER BY 1, 2;


-- Total Cases vs the Population showing the percentage of Population contacting covid

SELECT continent, date, total_cases, population, 
       (CONVERT(float, total_cases)/population) * 100 AS PercentPopulationInfected
FROM dbo.CovidDeaths
--Where continent like '%states%'  AND
where continent is not null
ORDER BY 1, 2;


-- Continents with Highest Infection Rate Compared to Population

SELECT continent, population, Max(total_cases) as HighestInfectionCount, 
       Max((CONVERT(float, total_cases)/population)) * 100 AS PercentPopulationInfected
FROM dbo.CovidDeaths
--Where location like '%states%'
where continent is not null
Group by continent, population
ORDER BY PercentPopulationInfected desc;


-- Continents with Highest Death Count Per Population

SELECT continent, Max(Cast(total_deaths as int)) as TotalDeathCount
FROM dbo.CovidDeaths
--Where location like '%states%'
where continent is not null
Group by continent
ORDER BY TotalDeathCount desc;


-- Country with the highest total deaths in a single day

SELECT Location, date, total_deaths
FROM dbo.CovidDeaths
WHERE total_deaths = (SELECT MAX(total_deaths) FROM dbo.CovidDeaths);

-- Percentage of Population Infected in locations where it is higher than the average of their continent

SELECT Location, date, total_cases, population
FROM dbo.CovidDeaths AS cd1
WHERE (total_cases / population) > (
    SELECT AVG(total_cases / population)
    FROM dbo.CovidDeaths AS cd2
    WHERE cd1.continent = cd2.continent
);

-- Rank Countries by their total deaths within their continent

SELECT Location, date, total_deaths,
    RANK() OVER (PARTITION BY continent ORDER BY total_deaths DESC) AS DeathRank
FROM dbo.CovidDeaths
WHERE continent IS NOT NULL;

-- Pivoting data to show total cases for each location by date

SELECT *
FROM (
    SELECT Location, date, total_cases
    FROM dbo.CovidDeaths
    WHERE continent IS NOT NULL
) AS SourceData
PIVOT (
    MAX(total_cases)
    FOR date IN ([2023-01-01], [2023-01-02], [2023-01-03])
) AS PivotTable;


-- GLOBAL NUMBERS

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From dbo.CovidDeaths
--Where location like '%states%'
where continent is not null 
--Group By date
order by 1,2

-- Total Population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From dbo.CovidDeaths dea
Join dbo.CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
order by 2,3


-- Using CTE to perform Calculation on Partition By in previous query

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From dbo.CovidDeaths dea
Join dbo.CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
--order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac


-- Using Temp Table to perform Calculation on Partition By in previous query

DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From dbo.CovidDeaths dea
Join dbo.CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
--where dea.continent is not null 
--order by 2,3

Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated


--Creating View to store data for later visualizations

Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From dbo.CovidDeaths dea
Join dbo.CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
--order by 2,3


