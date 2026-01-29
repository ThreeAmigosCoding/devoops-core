CREATE DATABASE user_db;
CREATE DATABASE accommodation_db;
CREATE DATABASE notification_db;
CREATE DATABASE rating_db;
CREATE DATABASE reservation_db;
CREATE DATABASE search_db;

CREATE USER "user-service" WITH PASSWORD 'user-service-pass';
CREATE USER "accommodation-service" WITH PASSWORD 'accommodation-service-pass';
CREATE USER "notification-service" WITH PASSWORD 'notification-service-pass';
CREATE USER "rating-service" WITH PASSWORD 'rating-service-pass';
CREATE USER "reservation-service" WITH PASSWORD 'reservation-service-pass';
CREATE USER "search-service" WITH PASSWORD 'search-service-pass';

GRANT ALL PRIVILEGES ON DATABASE user_db TO "user-service";
GRANT ALL PRIVILEGES ON DATABASE accommodation_db TO "accommodation-service";
GRANT ALL PRIVILEGES ON DATABASE notification_db TO "notification-service";
GRANT ALL PRIVILEGES ON DATABASE rating_db TO "rating-service";
GRANT ALL PRIVILEGES ON DATABASE reservation_db TO "reservation-service";
GRANT ALL PRIVILEGES ON DATABASE search_db TO "search-service";

\c user_db
GRANT ALL ON SCHEMA public TO "user-service";
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON TABLES TO "user-service";
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON SEQUENCES TO "user-service";

\c accommodation_db
GRANT ALL ON SCHEMA public TO "accommodation-service";
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON TABLES TO "accommodation-service";
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON SEQUENCES TO "accommodation-service";

\c notification_db
GRANT ALL ON SCHEMA public TO "notification-service";
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON TABLES TO "notification-service";
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON SEQUENCES TO "notification-service";

\c rating_db
GRANT ALL ON SCHEMA public TO "rating-service";
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON TABLES TO "rating-service";
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON SEQUENCES TO "rating-service";

\c reservation_db
GRANT ALL ON SCHEMA public TO "reservation-service";
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON TABLES TO "reservation-service";
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON SEQUENCES TO "reservation-service";

\c search_db
GRANT ALL ON SCHEMA public TO "search-service";
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON TABLES TO "search-service";
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON SEQUENCES TO "search-service";
