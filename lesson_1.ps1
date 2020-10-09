# Супер локальный запуск с нуля

dotnet new api --name WeatherApi
cd WetherApi
dotnet build
dotnet run
https://localhost:5001/WeatherForecast

# Запуск из докер имеджа
# Сначала все удалим
docker rm $(docker ps -a -q)
docker rmi $(docker images -q)

# =============================================================================
# Не практичный докер файл, огромного размера, т.к. запускает на имедже с SDK.
# Билдит все одним шагом.
docker build -f ./1.Dockerfile -t test-k8s-1 .
docker images

# Запускаем и смотрим результат
docker run --rm -p 127.0.0.1:5000:80 --name container-name-1 test-k8s-1
curl http://localhost:5000/WeatherForecast

# Проверяем, что контейнер запущен, убиваем его по имени
docker ps
docker stop container-name-1

# =============================================================================
# Билдим и запускаем вторую версию докер имеджа.
# в docker images видим, что новый контейнер меньше чем прежний
# замечаем новые безымянные контейнеры - это промежуточные контейнеры для билда
docker build -f ./2.Dockerfile -t test-k8s-2 .
docker images

# =============================================================================
# Билдим и запускаем третью версию докер имеджа.
# В ней шаг рестора и билда и рестора разделены, и билд не будет скачивать пол интернета при изменении комментария  в коде
docker build -f ./3.Dockerfile -t test-k8s-3 .
docker images

docker run --rm -p 127.0.0.1:5003:80 --name container-name-3 test-k8s-3
curl http://localhost:5003/WeatherForecast

response=$(curl -sb -H "Accept: application/json" "http://localhost:5003/WeatherForecast")
docker stop container-name-3
