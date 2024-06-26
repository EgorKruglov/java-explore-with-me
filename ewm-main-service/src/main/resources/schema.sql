DROP TABLE IF EXISTS users CASCADE;
DROP TABLE IF EXISTS location CASCADE;
DROP TABLE IF EXISTS categories CASCADE;
DROP TABLE IF EXISTS event CASCADE;
DROP TABLE IF EXISTS compilations CASCADE;
DROP TABLE IF EXISTS compilations_events CASCADE;
DROP TABLE If EXISTS request CASCADE;
DROP TABLE If EXISTS comment CASCADE;

CREATE TABLE IF NOT EXISTS users (
    id BIGINT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    email VARCHAR(255)                   UNIQUE NOT NULL,
    user_name VARCHAR(255)                      NOT NULL
);

CREATE TABLE IF NOT EXISTS location (
    id BIGINT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    lat NUMERIC                                  NOT NULL,
    lon NUMERIC                                  NOT NULL
);

CREATE TABLE IF NOT EXISTS categories (
    id BIGINT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    cat_name VARCHAR(255)                UNIQUE NOT NULL
);

CREATE TABLE IF NOT EXISTS event (
    id BIGINT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    annotation VARCHAR(2000)                    NOT NULL,
    category_id BIGINT                          NOT NULL,
    created_on TIMESTAMP WITHOUT TIME ZONE      NOT NULL,
    description VARCHAR(10000)                  NOT NULL,
    event_date TIMESTAMP WITHOUT TIME ZONE      NOT NULL,
    initiator_id BIGINT                         NOT NULL,
    location_id BIGINT                          NOT NULL,
    paid BOOLEAN                                NOT NULL,
    participant_limit int                       NOT NULL,
    request_moderation BOOLEAN                  DEFAULT TRUE,
    state_event VARCHAR(255)                    NOT NULL,
    title VARCHAR(255)                          NOT NULL,
    published_on TIMESTAMP WITHOUT TIME ZONE,

    CONSTRAINT fk_event_category_id FOREIGN KEY (category_id) REFERENCES categories (id) ON DELETE CASCADE,
    CONSTRAINT fk_event_initiator_id FOREIGN KEY (initiator_id) REFERENCES users (id) ON DELETE CASCADE,
    CONSTRAINT fk_event_location_id FOREIGN KEY (location_id) REFERENCES location (id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS compilations (
    id BIGINT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    pinned BOOLEAN                              DEFAULT FALSE,
    title VARCHAR(255)                   UNIQUE NOT NULL
);

CREATE TABLE IF NOT EXISTS compilations_events (
    compilations_id BIGINT                      NOT NULL,
    events_id       BIGINT                      NOT NULL,

    CONSTRAINT pk_compilations_events PRIMARY KEY (compilations_id, events_id),
    CONSTRAINT fk_compilations FOREIGN KEY (compilations_id) REFERENCES compilations (id) ON DELETE CASCADE,
    CONSTRAINT fk_events FOREIGN KEY (events_id) REFERENCES event (id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS request (
    id BIGINT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    created TIMESTAMP WITHOUT TIME ZONE          NOT NULL,
    event_id BIGINT                              NOT NULL,
    requester_id BIGINT                          NOT NULL,
    status VARCHAR(50)                           NOT NULL,

    CONSTRAINT fk_request_event_id FOREIGN KEY (event_id) REFERENCES event (id) ON DELETE CASCADE,
    CONSTRAINT fk_request_requester_id FOREIGN KEY (requester_id) REFERENCES users (id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS comment (
    id              BIGINT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    text            VARCHAR(2000) NOT NULL,
    event_id        BIGINT NOT NULL,
    author_id       BIGINT NOT NULL,
    created         TIMESTAMP WITHOUT TIME ZONE,
    last_updated_on TIMESTAMP WITHOUT TIME ZONE,

    CONSTRAINT fk_comment_event_id FOREIGN KEY (event_id) REFERENCES event (id) ON DELETE CASCADE,
    CONSTRAINT fk_comment_user_id FOREIGN KEY (author_id) REFERENCES users (id) ON DELETE CASCADE
);
