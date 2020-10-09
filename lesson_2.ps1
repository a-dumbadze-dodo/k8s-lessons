# Я запуши наш образ в докерхаб, чтобы можно было работать с нашим девовским кубером
# Теперь наш под называется alexeydoom/test-k8s-3

docker tag test-k8s-3 alexeydoom/test-k8s-3     # переименовал, потому что без первой части в вокерхаб запушить нельзя
docker push alexeydoom/test-k8s-3               # и запушил. Можно посмотреть тут https://hub.docker.com/r/alexeydoom/test-k8s-3


# =============================================================
# Создаем файл k8s\pod.yaml
# Создаем и конектимся к девовскому куберу
az aks get-credentials -g dev-groundwork-rg -n dev-kube-3       # Создаем
kubectl config use-context dev-kube-3                           # Начинаем использовать
kubectl config get-contexts                                     # Смотрим где мы. Должна стоять звездочка рядом с dev-kube-3


# =============================================================
# Создаем поду
kubectl get pods -n dev-mlc                                     # Проверяем, что поды нет
kubectl create -f ./k8s/pod.yaml -n dev-mlc                     # Создаем поду
kubectl get pods -n dev-mlc                                     # Теперь пода есть

kubectl port-forward weather-pod 5004:80 -n dev-mlc             # Пробрасываем порт до пода
curl http://localhost:5004/WeatherForecast                      # Проверяем


# =============================================================
# Создаем сервис
kubectl get pods --show-labels -n dev-mlc                               # Смотрим на лэйблы подов, проверяем, что у нас в селекторе так же
kubectl create -f ./k8s/service.yaml -n dev-mlc                         # Создаем сервис
kubectl get services -n dev-mlc                                         # Проверяем, что все создалось
kubectl port-forward svc/weather-service 5005:80 -n dev-mlc             # Пробрасываем порт до сервиса
curl http://localhost:5005/WeatherForecast                              # Проверяем


# =============================================================
# Создаем деплойметн
kubectl create -f ./k8s/deployment.yaml -n dev-mlc                      # Создаем деплоймент
kubectl get deployment -n dev-mlc
kubectl get pods --show-labels -n dev-mlc                               # Обращаем внимание на странное название второго пода
kubectl delete pod weather-pod -n dev-mlc                               # Удаляем под созданный руками


# =============================================================
# Все чистим
kubectl delete svc weather-service -n dev-mlc
kubectl delete deployment weather-deployment -n dev-mlc
kubectl delete pod weather-pod -n dev-mlc

