# =============================================================
# устанавливаем helm версии 2.11.0

# mac:
# brew install helm@2

# windows:
# choco install kubernetes-helm --version=2.11.0

# ubuntu:
# https://helm.baltorepo.com/stable/debian/packages/helm2/
# sudo curl https://baltocdn.com/helm/signing.asc | sudo apt-key add -
# sudo apt-get install apt-transport-https --yes
# echo "deb https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
# sudo apt-get update
# sudo apt-get install helm2=2.11.0 -v


# =============================================================
# Вам это не надо, но также сделал два ендпойта для хелсчека
docker build -f ./3.Dockerfile -t alexeydoom/test-k8s-3:stable .
docker push alexeydoom/test-k8s-3:stable


# =============================================================
# Проверяем, что все хорошо
kubectl config use-context dev-kube-3           # Переключаем контекст
helm list                                       # Смотрим список релизов
helm status dev-mlc-datacatalog                 # Смотрим на статус релиза
# Смотрим информацию о темплейте релиза
helm get dev-mlc-recentorders > template_dev-mlc-recentorders.yaml


# =============================================================
# Создание темплейта
mkdir k8s-lessons
cd k8s-lessons
helm create .

# Изучаем файлы шаблона, смотрим во что они преобразуются на выходе
helm template . | cat > ../template_result.yaml

# Обращаем внимание на
# { include "..fullname" . }}       - _helpers.tpl
# {{ .Values.replicaCount }}        - values.yaml
# {{ .Release.Name }}               - https://stackoverflow.com/questions/51718202/helm-how-to-define-release-name-value


# =============================================================
# Настраиваем шаблон под нас

# Удаляем:
rm ./templates/NOTES.txt
rm ./templates/ingress.yaml

# Меняем Chart.yaml
    # name:                     "mlc-k8s-test"

# Меняем values.yaml 
    # nameOverride:             mlc-k8s-test-adumbadze
    # fullnameOverride:         mlc-k8s-test-adumbadze
    # service.type:             LoadBalancer
    # resources                 расскоментируем
    # replicaCount:             1
    # image.repository:         alexeydoom/test-k8s-3
    
    # Удаляем разделы nodeSelector и ниже


# меняем в templates/deployment.yaml
    #   readinessProbe:
    #     httpGet:
    #       path: /health/healthy
    #       port: http
    #     initialDelaySeconds: 5
    #   livenessProbe:
    #     httpGet:
    #       path: /health/healthy
    #       port: http
    #     initialDelaySeconds: 5
    
    # Удаляем разделы nodeSelector и ниже


# =============================================================
# Деплоим
helm upgrade --install mlc-k8s-test-adumbadze --namespace study-mlc .
helm list                           # Тут мы понимаем, что он показывает не все релиз
helm list --namespace study-mlc     # Указваем немспейс
helm status mlc-k8s-test-adumbadze

# Проверяем поды, и видим один
kubectl get pods -n study-mlc

# меняем в templates/deployment.yaml
    #   readinessProbe:
    #     httpGet:
    #       path: /health/unhealthy
    #   livenessProbe:
    #     httpGet:
    #       path: /health/unhealthy

# Деплоим еще раз
helm upgrade --install mlc-k8s-test-adumbadze --namespace study-mlc .
helm list --namespace study-mlc                 # Видим по-прежнему один релиз (чарт?)
helm status mlc-k8s-test-adumbadze              # Видим, что второй релиз в статусе CrashLoopBackOff


helm delete mlc-k8s-test-adumbadze --purge      # Удаляем за собой все
kubectl get pods -n study-mlc                   # Видим, что подов нет