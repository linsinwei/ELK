# 簡易 ELK 建置

## Elasticsearch
* Azure VM
    * Host IP: 13.76.90.118 (for test)
    * OS: Ubuntu 18.04
    * Required:
        * Docker Version: 19.03.6
        * Docker Compose Version: 1.25.5

* Build Service
    * [Config file](./elasticsearch/)
    * run elasticsearch service container via docker-compose
    ```sh
    docker-compose up -d
    ```
    * shutdown service
    ```sh
    docker-compose down
    ```
* TODO: Internal network and firewall

## Kibana

* Azure VM
    * Host IP: 104.215.155.251 (for test)
    * OS: Ubuntu 18.04
    * Required:
        * Docker Version: 19.03.6
        * Docker Compose Version: 1.25.5
* Build Service
    * [Config file](./kibana/)
    * run kibana service container via docker-compose
    ```sh
    docker-compose up -d
    ```
    * shutdown service
    ```sh
    docker-compose down
    ```
* TODO: Internal network and firewall

## Filebeat
* The filebeat service is run for each node on K8S cluster.

    * Step1. Build image on local
        ```sh
        docker build --no-cache -t filebeat-image -f Dockerfile .
        ```
    * Step2. Login docker-hub(harbor) and push image
        * Login
        ```sh
        docker login -u admin -p P@sswordnull123 http://20.189.72.69:8888    
        ```
        * Tag image prefix and version on local
        ```sh
        docker tag filebeat-image http://20.189.72.69:8888/wishcloud/filebeat-image:latest
        ```
        * Push image
        ```sh
        docker push http://20.189.72.69:8888/wishcloud/filebeat-image:latest
        ```
    * TODO: Integrate to CI/CD flow 

* Filebeat service deploy
    * [deploy yaml files](./deploy/)
    * Step1. Login K8S cluster
    * Step2. Deploy or delete service
        * Deploy service
        ```sh
        kubectl apply -f filebeat_node1.yaml
        ```
        * Delete service
        ```sh
        kubectl delete -f filebeat_node1.yaml
        ```
## Configure filebeat
* [yaml files](./filebeat/)
##### Log files path
```sh
    paths:
        - "/usr/share/filebeat/webapplog/*/*.log"
```

##### Log format for json
```sh
    json.keys_under_root: true
    json.add_error_key: true
```

##### Limit the log content length
```sh
    - truncate_fields:
      fields:
      - message
      max_characters: 4096
      fail_on_error: false
      ignore_missing: true    
```

##### Index

* For example, Index the log file document by custom property "serviceName":
```sh
  indices:
    - index: "sport-%{[beat.version]}"
      when:
        regexp: 
            serviceName: ".*sportService.*"   
      fields: ["serviceName"]
    - index: "oauth-%{[beat.version]}"
      when:
        regexp: 
            serviceName: ".*oauthService.*"   
      fields: ["serviceName"]
    - index: "merchantauth-%{[beat.version]}"
      when:
        regexp: 
            serviceName: ".*merchantAuthService.*"   
      fields: ["serviceName"]
    - index: "wallet-%{[beat.version]}"
      when:
        regexp: 
            serviceName: ".*walletService.*"   
      fields: ["serviceName"]
    - index: "systemsetting-%{[beat.version]}"
      when:
        regexp: 
            serviceName: ".*systemSettingService.*"   
      fields: ["serviceName"]
    - index: "frontendlog-%{[beat.version]}"
      when:
        regexp: 
            serviceName: ".*frontendLoggerService.*"   
      fields: ["serviceName"]
```
##### Output
```sh
output.elasticsearch:
  hosts: ["http://13.76.90.118:9200"]
```

    
