# Cloud Foundry UAA and OAuth 2.0

Cloud Foundry User Account and Authentication (CF UAA) is an identity management and authorization service

## Description

-[DockerHub](https://cloud.docker.com/repository/registry-1.docker.io/shinyay/uaa)

### OAuth2.0

OAuth 2.0 flow we can identify the following roles:
- **Resource Owner**: the entity that can grant access to a protected resource. Typically this is the end-user.

- **Resource Server**: the server hosting the protected resources. This is the API you want to access.

- **Client**: the app requesting access to a protected resource on behalf of the Resource Owner.

- **Authorization Server**: the server that authenticates the Resource Owner, and issues Access Tokens after getting proper authorization. In this case, UAA. Other is like Auth0.

![oauth2-flow](images/oauth2-generic-flow.png)

## Demo

## Features

- feature:1
- feature:2

## Requirement

## Usage
### UAA Configuration `uaa.yml`
- [required_configuration.yml](https://github.com/cloudfoundry/uaa/blob/4.35.0/uaa/src/main/resources/required_configuration.yml)

### JWS Key Pair Configuration
UAA needs to have a private key to sign each JWT that UAA issues

#### OpenSSL for JWT
- Authorization server will sign the JWT with the private key.
  - `JWT_TOKEN_SIGNING_KEY`
  - **jwt.token.signing-key** (in uaa.yml)
- Client and resource server will verify that signature with the public key.
  - `JWT_TOKEN_VERIFICATION_KEY`
  - **jwt.token.verification-key** (in uaa.yml)

```
$ openssl genrsa -out signingkey.pem 2048
$ openssl rsa -in signingkey.pem -pubout -out verificationkey.pem
```

```
export JWT_TOKEN_SIGNING_KEY=$(cat signingkey.pem)
export JWT_TOKEN_VERIFICATION_KEY=$(cat verificationkey.pem)
```

## Installation

## Licence

Released under the [MIT license](https://gist.githubusercontent.com/shinyay/56e54ee4c0e22db8211e05e70a63247e/raw/34c6fdd50d54aa8e23560c296424aeb61599aa71/LICENSE)

## Author

[shinyay](https://github.com/shinyay)
