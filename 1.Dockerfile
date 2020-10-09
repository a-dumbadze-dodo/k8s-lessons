FROM mcr.microsoft.com/dotnet/core/sdk:3.1
WORKDIR /src
COPY ./WeatherApi/. .
RUN dotnet publish --configuration Release --output out
WORKDIR /src/out
ENV ASPNETCORE_ENVIRONMENT Production
ENV ASPNETCORE_URLS "http://0.0.0.0:80"
EXPOSE 80
ENTRYPOINT ["dotnet", "WeatherApi.dll"]