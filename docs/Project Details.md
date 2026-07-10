SafeRoute – AI-Based Smart Safety Navigation & Emergency Assistance System

Project Title

SafeRoute – AI-Based Smart Safety Navigation & Emergency Assistance System

Problem Statement

Many navigation applications focus primarily on finding the shortest or fastest route without considering user safety. Travelers may unknowingly pass through high-risk areas or face emergencies without quick access to assistance. There is a need for a smart navigation system that provides safer route recommendations, real-time safety alerts, and emergency assistance features to improve user security during travel.

Objectives

1. To provide safe route navigation based on safety-related data.
2. To predict risk-prone areas using AI and historical incident information.
3. To enable users to send emergency SOS alerts with their live location.
4. To provide real-time safety notifications during travel.
5. To support live location sharing with trusted emergency contacts.
6. To develop a secure and user-friendly mobile application for safety-focused navigation.

Modules

1. User Authentication Module

- User Registration
- User Login
- Firebase Authentication

2. Safe Route Navigation Module

- Source and Destination Selection
- Route Generation using Google Maps API
- Safe Route Recommendation

3. AI Risk Prediction Module

- Risk Analysis
- Safety Score Calculation
- High-Risk Area Detection

4. Emergency Assistance Module

- SOS Alert System
- Emergency Contact Management
- Live Location Sharing

5. Notification Module

- Safety Alerts
- Emergency Notifications
- Firebase Cloud Messaging (FCM)

6. Admin Module

- User Management
- Incident Monitoring
- Safety Data Management

Database Tables

USERS

- user_id (PK)
- name
- email
- phone
- password

EMERGENCY_CONTACTS

- contact_id (PK)
- user_id (FK)
- contact_name
- contact_phone
- relationship

ROUTES

- route_id (PK)
- user_id (FK)
- source
- destination
- safety_score
- route_date

SAFETY_ALERTS

- alert_id (PK)
- user_id (FK)
- alert_type
- location
- alert_time
- status

INCIDENT_REPORTS

- report_id (PK)
- user_id (FK)
- location
- description
- risk_level
- reported_at

NOTIFICATIONS

- notification_id (PK)
- user_id (FK)
- message
- status
- sent_time

Technologies Used

- Frontend: Flutter / React Native
- Backend: Spring Boot (Java)
- Database: MySQL
- Maps: Google Maps API
- Authentication: Firebase Authentication
- Notifications: Firebase Cloud Messaging (FCM)
- AI Module: Python + TensorFlow

Expected Outcome

SafeRoute provides users with safer navigation by combining AI-based risk prediction, real-time safety alerts, emergency assistance, and live location sharing within a single mobile application.
