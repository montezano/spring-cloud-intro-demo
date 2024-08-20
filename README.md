# Sample Credit Card application eco-system

This branch contains the demo with Spring Cloud Netflix Eureka. To see the same demo with other service registries, see the other branches.

After running all the apps execute POST at `localhost:9080/application` passing 
`cardApplication.json` as body.

```bash
http POST localhost:9080/application < cardApplication.json
```

- new card applications registered via `card-service`
- user registered via `user-service`
- `fraud-service` called by `card-service` and `user-service` to verify 
card applications and new users


```
+-------+                         +-------------+       +-------------+          +-------+             +---------------+  +-------+
| User  |                         | CardService |       | UserService |          | Proxy |             | FraudVerifier |  | Proxy |
+-------+                         +-------------+       +-------------+          +-------+             +---------------+  +-------+
    |                                    |                     |                     |                         |              |
    | Register application               |                     |                     |                         |              |
    |----------------------------------->|                     |                     |                         |              |
    |                                    |                     |                     |                         |              |
    |                                    | Create new user     |                     |                         |              |
    |                                    |------------------------------------------>|                         |              |
    |                                    |                     |                     |                         |              |
    |                                    |                     |     Create new user |                         |              |
    |                                    |                     |<--------------------|                         |              |
    |                                    |                     |                     |                         |              |
    |                                    |                     | Verify new user     |                         |              |
    |                                    |                     |-------------------->|                         |              |
    |                                    |                     |                     |                         |              |
    |                                    |                     |                     | Verify new user         |              |
    |                                    |                     |                     |------------------------>|              |
    |                                    |                     |                     |                         |              |
    |                                    |                     |                     |           User verified |              |
    |                                    |                     |                     |<------------------------|              |
    |                                    |                     |                     |                         |              |
    |                                    |                     |       User verified |                         |              |
    |                                    |                     |<--------------------|                         |              |
    |                                    |                     |                     |                         |              |
    |                                    |        User created |                     |                         |              |
    |                                    |<--------------------|                     |                         |              |
    |                                    |                     |                     |                         |              |
    |                                    |                     |                     |                         | User created |
    |                                    |<-----------------------------------------------------------------------------------|
    |                                    |                     |                     |                         |              |
    |                                    | Verify card application                   |                         |              |
    |                                    |-------------------------------------------------------------------->|              |
    |                                    |                     |                     |                         |              |
    |                                    |                     |                     Card application verified |              |
    |                                    |<--------------------------------------------------------------------|              |
    |                                    |                     |                     |                         |              |
    |        Card application registered |                     |                     |                         |              |
    |<-----------------------------------|                     |                     |                         |              |
    |                                    |                     |                     |                         |              |
```


# Setup using new stack

## Client side load-balancing using LoadBalancerClient

- `@LoadBalanced RestTemplate` uses Spring Cloud LoadBalancer under the hood

## Apps communicating via Gateway:
- Routes have to be explicitly defined
- Possibility to configure routes either via properties or Java configuration
- All headers passed by default
- Routes matched using predicates, requests modified using filters

## Spring Cloud Circuit Breaker + Resilience4J
- Interactions defined using injected `CircuitBreakerFactory` via the `create()` method
- HTTP call and fallback method defined
- Circuit breaker configuration modified in `Customizer<CircuitBreaker` bean 
in a `@Configuration` class 
- Resilience4J used underneath																																
## Centralised configuration with Spring Cloud ConfigServer
- card-service connects to ConfigServer to retrieve property values
- ConfigServer backed by a git repository
- Updating property values in a running application by using `@RefreshScope` beans and `/actuator/refresh` endpoint


## Micrometer + Prometheus
- HTTP traffic monitoring using Micrometer + Prometheus
- Added a Micrometer's `Timer` to `VerificationServiceClient`

# Running
## Spring

- Run the script `run_all.sh` under scripts directory

# Docker

- With docker engine running, execute the script `run_all.sh docker` under scripts directory
