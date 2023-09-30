SELECT *
FROM [PORTFOLIO PROJECT]..CovidDeaths
Where continent is not Null
ORDER BY 3,4

--SELECT *
--FROM [PORTFOLIO PROJECT]..[CovidVaccinations]
--ORDER BY 3,4

SELECT Location, Date, Total_cases, new_cases,total_deaths, population
FROM [PORTFOLIO PROJECT]..CovidDeaths
Where continent is not Null
Order by 1,2

SELECT Location, Date, Total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM [PORTFOLIO PROJECT]..CovidDeaths
Where continent is not Null
Order by 1,2

SELECT Location, Date, Total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM [PORTFOLIO PROJECT]..CovidDeaths
--WHERE location Like '%Kenya%'
Where continent is not Null
Order by 1,2

SELECT Location, Date, population Total_cases, (total_deaths/population)*100 as DeathPercentage
FROM [PORTFOLIO PROJECT]..CovidDeaths
--WHERE location like '%Kenya%'
Where continent is not Null
Order by 1,2

SELECT Location, population, MAX(Total_cases)as HighestInfectionCount, MAX((total_cases/population))*100 as PercentPopulationInfected
FROM [PORTFOLIO PROJECT]..CovidDeaths
--WHERE location like '%Kenya%'
Where continent is not Null
Group By Location, population
Order by 1,2

SELECT Location, population, MAX(Total_cases)as HighestInfectionCount, MAX((total_cases/population))*100 as PercentPopulationInfected
FROM [PORTFOLIO PROJECT]..CovidDeaths
--WHERE location like '%Kenya%'
Where continent is not Null
Group By Location, population
Order By percentPopulationInfected desc

Select Location, MAX(CAST(Total_deaths as int)) as TotalDeathCount
From [PORTFOLIO PROJECT]..CovidDeaths
Where continent is not Null
Group by location
Order by TotalDeathCount Desc

Select Location, MAX(CAST(Total_deaths as int)) as TotalDeathCount
From [PORTFOLIO PROJECT]..CovidDeaths
Where continent is Null
Group by location
Order by TotalDeathCount Desc

SELECT Date, SUM(new_cases) as total_cases, SUM(CAST(new_deaths as int)) as total_deaths, SUM(CAST(new_deaths as int))/SUM(New_cases)*100 as DeathPercentage
FROM [PORTFOLIO PROJECT]..CovidDeaths
--WHERE location Like '%Kenya%'
Where continent is not Null
GROUP BY date
Order by 1,2

SELECT SUM(new_cases) as total_cases, SUM(CAST(new_deaths as int)) as total_deaths, SUM(CAST(new_deaths as int))/SUM(New_cases)*100 as DeathPercentage
FROM [PORTFOLIO PROJECT]..CovidDeaths
--WHERE location Like '%Kenya%'
Where continent is not Null
--GROUP BY date
Order by 1,2

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,SUM (convert(int,vac.new_vaccinations)) OVER (Partition by dea.Location order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/Population)*100
FROM [PORTFOLIO PROJECT]..CovidDeaths dea
Join [PORTFOLIO PROJECT]..CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
Where dea. continent is not null
ORDER BY 1,2,3

--USING CTE

WITH POPVSVAC (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,SUM (convert(int,vac.new_vaccinations)) OVER (Partition by dea.Location order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/Population)*100
FROM [PORTFOLIO PROJECT]..CovidDeaths dea
Join [PORTFOLIO PROJECT]..CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
Where dea. continent is not null
--ORDER BY 1,2,3
)
SELECT *, (RollingPeopleVaccinated/Population)*100
FROM POPVSVAC


--using temp table

DROP TABLE IF EXISTS #PercentofPopulationVaccinated
CREATE TABLE #PercentofPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

INSERT INTO #PercentofPopulationVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,SUM (convert(int,vac.new_vaccinations)) OVER (Partition by dea.Location order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/Population)*100
FROM [PORTFOLIO PROJECT]..CovidDeaths dea
Join [PORTFOLIO PROJECT]..CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
Where dea. continent is not null 
ORDER BY 2,3

SELECT *, (RollingPeopleVaccinated/Population)*100
FROM #PercentofPopulationVaccinated


CREATE VIEW PercentofPopulationVaccinated as
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,SUM (convert(int,vac.new_vaccinations)) OVER (Partition by dea.Location order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/Population)*100
FROM [PORTFOLIO PROJECT]..CovidDeaths dea
Join [PORTFOLIO PROJECT]..CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
Where dea. continent is not null 
--ORDER BY 2,3

SELECT*
FROM PercentofPopulationVaccinated