FROM mcr.microsoft.com/dotnet/core/sdk:3.1 AS build
WORKDIR /src

COPY ./WeatherApi/WeatherApi.csproj .
RUN dotnet restore ./WeatherApi.csproj

COPY ./WeatherApi/. .
RUN dotnet publish --no-restore --configuration Release --output out

# =======================================
FROM mcr.microsoft.com/dotnet/core/aspnet:3.1

COPY --from=build ./src/out ./
ENV ASPNETCORE_ENVIRONMENT Production
ENV ASPNETCORE_URLS "http://0.0.0.0:80"
EXPOSE 80
ENTRYPOINT ["dotnet", "WeatherApi.dll"]