-- AURA Initial Database Schema Baseline
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE TABLE IF NOT EXISTS appliance_profiles (
    id VARCHAR(128) PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    manufacturer VARCHAR(128) NOT NULL,
    model_number VARCHAR(128) NOT NULL,
    category VARCHAR(64) NOT NULL,
    schema_version VARCHAR(16) NOT NULL,
    verification_status VARCHAR(32) NOT NULL DEFAULT 'verified',
    profile_data JSONB NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_appliance_category ON appliance_profiles(category);
CREATE INDEX IF NOT EXISTS idx_appliance_model ON appliance_profiles(manufacturer, model_number);
