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

### <a id='scopes'></a>Scopes ##

UAA covers multiple scopes of privilege, including access to UAA, access to [Cloud Controller](index.html#cc), and access to the [router](index.html#router).

See the tables below for a description of the scopes covered by UAA:

* [UAA Scopes](#uaa-scopes)
* [Cloud Controller Scopes](#cc-scopes)
* [Router Scopes](#routing-scopes)
* [Other Scopes](#other-scopes)

#### <a id="uaa-scopes"></a>UAA Scopes
<table>
  <tr>
    <th>Scope</th>
    <th>Description</th>
  </tr>
  <tr>
    <td><code>uaa.user</code></td>
    <td>This scope indicates that this is a user. It is required in the token if submitting a GET request to the OAuth 2 <code>/authorize</code> endpoint.</td>
  </tr>
  <tr>
    <td><code>uaa.none</code></td>
    <td>This scope indicates that this client will not be performing actions on behalf of a user.</td>
  </tr>
  <tr>
    <td><code>uaa.admin</code></td>
    <td>This scopes indicates that this is the superuser.</td>
  </tr>
  <tr>
    <td><code>scim.write</code></td>
    <td>This scope gives admin write access to all SCIM endpoints, <code>/Users</code>, and <code>/Groups</code>.</td>
  </tr>
  <tr>
    <td><code>scim.read</code></td>
    <td>This scope gives admin read access to all SCIM endpoints, <code>/Users</code>, and <code>/Groups</code>.</td>
  </tr>
  <tr>
    <td><code>scim.create</code></td>
    <td>This scope gives the ability to create a user with a POST request to the <code>/Users</code> endpoint, but not to modify, read, or delete users.</td>
  </tr>
  <tr>
    <td><code>scim.userids</code></td>
    <td>This scope is required to convert a username and origin into a user ID and vice versa.</td>
  </tr>
  <tr>
    <td><code>scim.invite</code></td>
    <td>This scope is required to participate in invitations using the <code>/invite_users</code> endpoint.</td>
  </tr>
  <tr>
    <td><code>groups.update</code></td>
    <td>This scope gives the ability to update a group. This ability can also be provided by the broader <code>scim.write</code> scope.</td>
  </tr>
  <tr>
    <td><code>password.write</code></td>
    <td>This admin scope gives the ability to change a user's password.</td>
  </tr>
  <tr>
    <td><code>openid</code></td>
    <td>This scope is required to access the <code>/userinfo</code> endpoint. It is intended for OpenID clients.</td>
  </tr>
  <tr>
    <td><code>idps.read</code></td>
    <td>This scope gives read access to retrieve identity providers from the <code>/identity-providers</code> endpoint.</td>
  </tr>
  <tr>
    <td><code>idps.write</code></td>
    <td>This scope gives the ability to create and update identity providers from the <code>/identity-providers</code> endpoint.</td>
  </tr>
  <tr>
    <td><code>clients.admin</code></td>
    <td>This scope gives the ability to create, modify, and delete clients.</td>
  </tr>
  <tr>
    <td><code>clients.write</code></td>
    <td>This scope is required to create and modify clients. The scopes are prefixed with the scope holder's client ID. For example, <code>id:testclient authorities:client.write</code> gives the ability to create a client that has scopes with the <code>testclient.</code> prefix. Authorities are limited to <code>uaa.resource</code>.</td>
  </tr>
  <tr>
    <td><code>clients.read</code></td>
    <td>This scope gives the ability to read information about clients.</code></td>
  </tr>
  <tr>
    <td><code>clients.secret</code></td>
    <td>This admin scope is required to change the password of a client.</td>
  </tr>
  <tr>
    <td><code>zones.read</code></td>
    <td>This scope is required to invoke the <code>/identity-zones</code> endpoint to read identity zones.</td>
  </tr>
  <tr>
    <td><code>zones.write</code></td>
    <td>This scope is required to invoke the <code>/identity-zones</code> endpoint to create and update identity zones.</td>
  </tr>
  <tr>
    <td><code>scim.zones</code></td>
    <td>This is a limited scope that only allows adding a user to, or removing a user from, zone management groups under the path <code>/Groups/zones</code>.</td>
    <tr>
      <td><code>oauth.approval</code></td> 
      <td><code>/approvals endpoint</code>. This scope is required to approve or reject clients to act on a user's behalf. This is a default scope defined in the <code>uaa.yml</code> file.</td>
    </tr>
    <tr>
      <td><code>oauth.login</code></td>
      <td>This scope is used to indicate a login app, such as external login servers, can perform trusted operations, such as creating users not authenticated in the UAA.</td>
    </tr>
    <tr>
      <td><code>approvals.me</code></td>
      <td>This scope is not currently used.</td>
    </tr>
    <tr>
      <td><code>uaa.resource</code></td>
      <td>This scope indicates that this is a resource server, used for the <code>/introspect</code> endpoint.</td>
    </tr>
    <tr>
      <td nowrap><code>zones.ZONE-ID.admin</code></td>
      <td>This scope permits operations in a designated zone, such as creating identity providers or clients in another zone, by authenticating against the default zone. This scope is used with the <code>X-Identity-Zone-Id header</code>.</td>
    </tr>
    <tr>
      <td nowrap><code>zones.ZONE-ID.read</code></td>
      <td>This scope permits reading the given identity zone. This scope is used with the <code>X-Identity-Zone-Id header</code>.</td>
    </tr>
    <tr>
      <td nowrap><code>zones.ZONE-ID.clients.admin</code></td>
      <td>This scope translates into <code>clients.admin</code> after zone switch completes. This scope is used with the <code>X-Identity-Zone-Id header</code>.</td>  
    </tr>
    <tr>
      <td nowrap><code>zones.ZONE-ID.clients.read</code></td>
      <td>This scope translates into <code>clients.read</code> after zone switch completes. This scope is used with the <code>X-Identity-Zone-Id header</code>.</td>
    </tr>
    <tr>
      <td nowrap><code>zones.ZONE-ID.clients.write</code></td>
      <td>This scope translates into <code>clients.write</code> after zone switch completes. This scope is used with the <code>X-Identity-Zone-Id header</code>.</td>
    </tr>
    <tr>
      <td nowrap><code>zones.ZONE-ID.clients.scim.read</code></td>
      <td>This scope translates into <code>scim.read</code> after zone switch completes. This scope is used with the <code>X-Identity-Zone-Id header</code>.</td>
    </tr>
    <tr>
      <td nowrap><code>zones.ZONE-ID.clients.scim.create</code></td>
      <td>This scope translates into <code>scim.create</code> after zone switch completes. This scope is used with the <code>X-Identity-Zone-Id header</code>.</td>
    </tr>
    <tr>
      <td nowrap><code>zones.ZONE-ID.clients.scim.write</code></td>
      <td>This scope translates into <code>scim.write</code> after zone switch completes. This scope is used with the <code>X-Identity-Zone-Id header</code>.</td>
    </tr>
    <tr>
      <td nowrap><code>zones.ZONE-ID.idps.read</code></td>
      <td>This scope translates into <code>idps.read</code> after zone switch completes. This scope is used with the <code>X-Identity-Zone-Id header</code>.</td>
    </tr>
  </tr> 
</table>

#### <a id="cc-scopes"></a>Cloud Controller Scopes

<table>
  <tr>
    <th>Scope</th>
    <th>Description</th>
  </tr>
  <tr>
    <td><code>cloud_controller.read</code></td>
    <td>This scope gives the ability to read from any Cloud Controller route the token has access to.</td>
  </tr>
  <tr>
    <td><code>cloud_controller.write</code></td>
    <td>This scope gives the ability to post to Cloud Controller routes the token has access to.</td>
  </tr>
  <tr>
    <td><code>cloud_controller.admin</code></td>
    <td>This admin scope gives full permissions to Cloud Controller.</td>
  </tr>
  <tr>
    <td><code>cloud_controller.admin_read_only</code></td>
    <td>This admin scope gives read permissions to Cloud Controller.</td>
  </tr>
  <tr>
    <td><code>cloud_controller.global_auditor</code></td>
    <td>This scope gives read-only access to all Cloud Controller API resources except for secrets such as environment variables.</td>
  </tr>
</table>

#### <a id="routing-scopes"></a>Routing Scopes

<table>
  <tr>
    <th>Scope</th>
    <th>Description</th>
  </tr>
  <tr>
    <td><code>routing.routes.read</code></td>
    <td>This scope gives the ability to read the full routing table from the router.</td>
  </tr>
  <tr>
    <td><code>routing.routes.write</code></td>
    <td>This scope gives the ability to write the full routing table from the router.</td>
  </tr>
  <tr>
    <td><code>routing.router_groups.read</code></td>
    <td>This scope gives the ability to read the full list of routing groups.</td>
  </tr>
  <tr>
    <td><code>routing.router_groups.write</code></td>
    <td>This scopes gives the ability to write the full list of routing groups.</td>
  </tr>
</table>

#### <a id="other-scopes"></a>Other Scopes

<table>
  <tr>
    <th>Scope</th>
    <th>Description</th>
  </tr>
  <tr>
    <td><code>doppler.firehose</code></td>
    <td>This scope gives the ability to read logs from the <%= vars.loggregator_firehose_link %> endpoint.</td>
  </tr>
  <tr>
    <td><code>notifications.write</code></td>
    <td>This scope gives the ability to send notifications through the <%= vars.notifications_link %>.</td>
  </tr>
</table> 

## Installation

## Licence

Released under the [MIT license](https://gist.githubusercontent.com/shinyay/56e54ee4c0e22db8211e05e70a63247e/raw/34c6fdd50d54aa8e23560c296424aeb61599aa71/LICENSE)

## Author

[shinyay](https://github.com/shinyay)
