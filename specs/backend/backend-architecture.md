# nagizone: Backend Architecture

## Abstract
This document describes the backend architecture of the _nagizone_ web platform.

The document relies in the information contained in other documents, specifically those included in the section [Related documents](related-documents), so the reading of those documents is recommended prior to read this document.

## Background
_nagizone_ is a web solution designed for swimmers, offering storage and statistics for their swimming sessions.

_nagizone_ obtains its source data from swimming pools equipped with _nagi_. _nagi_ is an indoor tracking solution for swimmers that provides security features and allows swimmers to monitor their swim activities, including sessions and related statistics.

Swimmers using _nagi_ wear a Bluetooth tag while swimming, enabling _nagi_ to determine their precise location in the pool and track their swimming activity (speed, duration, distance).

## Architecture Premises

### Design
The _nagizone_ backend architecture is based on microservices and is intended to run in a cloud environment, specifically on Google Cloud Platform (GCP).

When running on GCP, the microservices will be implemented either as Google Cloud Run services or Google Cloud Functions, depending on the number of endpoints required for each microservice:
- If a microservice is intended to have a single endpoint, it will be deployed as a Google Cloud Function.
- If a microservice is intended to have more than one endpoint, it will be deployed as a Google Cloud Run service.

### Communication
All backend microservices will expose an API that supports both Protobuf-based **Remote Procedure Calls (RPCs)** and REST requests with JSON payloads.

While supporting REST calls, each microservice will primarily communicate with other microservices using **Protobuf-based RPCs**. Thus, the RPC mechanism using Protobuf can be considered the main backend communication method (or "bus" conceptually).

### Event-Driven Architecture
The backend system will operate as an event-driven architecture. Upon certain changes, messages will be published by the involved microservices, triggering actions in other microservices that subscribe to these messages.

Given that the backend runs on GCP, the messaging system supporting this event-driven behavior will be Google Cloud Pub/Sub, specifically utilizing push subscriptions. Pub/Sub push messages are delivered as HTTP POST calls, which is compatible with the REST support mentioned for the microservice APIs.

Therefore, the backend system will have, in addition to the main RPC communication, a secondary communication layer based on Pub/Sub Push notifications.

### Storage
The backend storage design is outside the scope of this document. Information related to data storage is defined in the document "nagizone: Backend Data Entities and Storage".

### Logging
All the microservices in the backend will log to the Google Cloud Logging facility with different severity levels.


## Architecture Components
This section defines the microservices within the backend system and describes how they will interact.

### users service
The `users` service will be in charge of managing users, specifically:
- creating new users,
- updating the existing users information,
- deleting existing users,
- serving user information

### sessions service
The `sessions` service will be in charge of managing entities information, specifically:
- Create new sessions
- Return sessions information

Sessions cannot neither being updated nor deleted, so those operations are out of the scope of this service.

## Related documents
- "nagizone: Backend Data Entities and Storage": Data entities and storage solutions used in the backend system of the _nagizone_ web platform
- "nagi.zone.v1" protobuf specification: Protobuf specification including all the backend services and their messages.