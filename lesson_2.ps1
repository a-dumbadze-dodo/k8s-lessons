# Я запуши наш образ в докерхаб, чтобы можно было работать с нашим девовским кубером
# Теперь наш под называется alexeydoom/test-k8s-3

docker tag test-k8s-3 alexeydoom/test-k8s-3     # переименовал, потому что без первой части в вокерхаб запушить нельзя
docker push alexeydoom/test-k8s-3               # и запушил. Можно посмотреть тут https://hub.docker.com/r/alexeydoom/test-k8s-3


# Создаем неймспейс
kubectl create namespace study-mlc

# =============================================================
# Создаем файл k8s\pod.yaml
# Создаем и конектимся к девовскому куберу
az aks get-credentials -g dev-groundwork-rg -n dev-kube-3       # Создаем
kubectl config use-context dev-kube-3                           # Начинаем использовать
kubectl config get-contexts                                     # Смотрим где мы. Должна стоять звездочка рядом с dev-kube-3


# =============================================================
# Создаем поду
kubectl get pods -n study-mlc                                     # Проверяем, что поды нет
kubectl create -f ./k8s/pod.yaml -n study-mlc                     # Создаем поду
kubectl get pods -n study-mlc                                     # Теперь пода есть

kubectl port-forward weather-pod 5004:80 -n study-mlc             # Пробрасываем порт до пода
curl http://localhost:5004/WeatherForecast                        # Проверяем


# =============================================================
# Создаем сервис
kubectl get pods --show-labels -n study-mlc                               # Смотрим на лэйблы подов, проверяем, что у нас в селекторе так же
kubectl create -f ./k8s/service.yaml -n study-mlc                         # Создаем сервис
kubectl get services -n study-mlc                                         # Проверяем, что все создалось
kubectl port-forward svc/weather-service 5005:80 -n study-mlc             # Пробрасываем порт до сервиса
curl http://localhost:5005/WeatherForecast                                # Проверяем


# =============================================================
# Создаем деплойметн
kubectl create -f ./k8s/deployment.yaml -n study-mlc                      # Создаем деплоймент
kubectl get deployment -n study-mlc
kubectl get pods --show-labels -n study-mlc                               # Обращаем внимание на странное название второго пода
kubectl delete pod weather-pod -n study-mlc                               # Удаляем под созданный руками


# =============================================================
# Все чистим
kubectl delete svc weather-service -n study-mlc
kubectl delete deployment weather-deployment -n study-mlc
kubectl delete pod weather-pod -n study-mlc

