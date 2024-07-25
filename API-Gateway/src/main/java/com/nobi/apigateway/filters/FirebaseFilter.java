package com.nobi.apigateway.filters;

import com.google.firebase.auth.FirebaseAuth;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.http.server.reactive.ServerHttpRequest;
import org.springframework.stereotype.Component;
import org.springframework.cloud.gateway.filter.GlobalFilter;
import org.springframework.cloud.gateway.filter.GatewayFilterChain;
import org.springframework.core.Ordered;
import org.springframework.web.server.ResponseStatusException;
import org.springframework.web.server.ServerWebExchange;
import reactor.core.publisher.Mono;

@Component
public class FirebaseFilter implements GlobalFilter, Ordered {

    private static final Logger logger = LoggerFactory.getLogger(FirebaseFilter.class);

    @Override
    public Mono<Void> filter(ServerWebExchange exchange, GatewayFilterChain chain) {
        logger.info("Filter triggered");

        // Skip processing for CORS preflight requests
        if ("OPTIONS".equals(exchange.getRequest().getMethod())) {
            return chain.filter(exchange);
        }

        System.out.println(exchange.getRequest().getHeaders());
        System.out.println(exchange.getRequest().getPath());

        // Try to extract the token from the Authorization header first
        String authHeader = exchange.getRequest().getHeaders().getFirst("Authorization");
        String token = null;
        if (authHeader != null && authHeader.startsWith("Bearer ")) {
            token = authHeader.substring(7);
        } else {
            // If the header is not present, check for a token in the query parameters
            token = exchange.getRequest().getQueryParams().getFirst("token");
        }

        if (token == null) {
            logger.warn("Unauthorized access attempt - No token found in header or query parameters");
            exchange.getResponse().setStatusCode(HttpStatus.UNAUTHORIZED);
            return Mono.error(new ResponseStatusException(HttpStatus.UNAUTHORIZED, "Unauthorized"));
        }

        String finalToken = token;
        return Mono.fromCallable(() -> FirebaseAuth.getInstance().verifyIdToken(finalToken))
                .flatMap(decodedToken -> {
                    logger.info("Authenticated UID: {}", decodedToken.getUid());

                    // Add the UID as a new header
                    ServerHttpRequest modifiedRequest = exchange.getRequest().mutate()
                            .header("uid", decodedToken.getUid())
                            .build();
                    ServerWebExchange modifiedExchange = exchange.mutate().request(modifiedRequest).build();

                    return chain.filter(modifiedExchange);
                })
                .onErrorResume(e -> {
                    logger.error("Authentication failed: {}", e.getMessage());
                    exchange.getResponse().setStatusCode(HttpStatus.UNAUTHORIZED);
                    return Mono.empty();
                });
    }

    @Override
    public int getOrder() {
        return -1; // Set the order
    }
}
